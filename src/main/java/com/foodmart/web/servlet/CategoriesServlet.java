package com.foodmart.web.servlet;

import com.foodmart.config.FirebaseConfig;
import com.foodmart.dao.CategoryDao;
import com.foodmart.model.Category;
import com.google.firebase.cloud.StorageClient;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.IOException;
import java.io.InputStream;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.List;

@WebServlet(name = "CategoriesServlet", urlPatterns = "/categories")
@MultipartConfig
public class CategoriesServlet extends HttpServlet {

    private final CategoryDao categoryDao = new CategoryDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // highlight Categories in sidebar
        req.setAttribute("activePage", "categories");

        // move flash message from session to request so it shows once
        String statusMessage = (String) req.getSession().getAttribute("statusMessage");
        if (statusMessage != null) {
            req.setAttribute("statusMessage", statusMessage);
            req.getSession().removeAttribute("statusMessage");
        }

        List<Category> categories = categoryDao.findAll();
        req.setAttribute("categories", categories);
        req.getRequestDispatcher("/WEB-INF/jsp/categories.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        String name = req.getParameter("name");
        String activeParam = req.getParameter("active");
        boolean active = "on".equalsIgnoreCase(activeParam) || "true".equalsIgnoreCase(activeParam);

        System.out.println("POST /categories: name=" + name + ", activeParam=" + activeParam);

        if (name != null && !name.trim().isEmpty()) {
            String trimmedName = name.trim();

            // case-insensitive duplicate-name check
            if (categoryDao.existsByNameIgnoreCase(trimmedName)) {
                req.getSession().setAttribute("statusMessage", "Category '" + trimmedName + "' already exists.");
                resp.sendRedirect(req.getContextPath() + "/categories");
                return;
            }

            String imageUrl = null;
            try {
                Part imagePart = req.getPart("imageFile"); // must match input name in JSP

                if (imagePart == null) {
                    System.err.println("imagePart is null. Check input `name` and `enctype` in categories.jsp.");
                } else if (imagePart.getSize() == 0) {
                    System.err.println("Uploaded image is empty.");
                } else {
                    // Derive a safe filename based on category name and original extension
                    String originalFileName = imagePart.getSubmittedFileName();
                    String extension = "";
                    if (originalFileName != null) {
                        int dotIndex = originalFileName.lastIndexOf('.');
                        if (dotIndex >= 0 && dotIndex < originalFileName.length() - 1) {
                            extension = originalFileName.substring(dotIndex); // includes dot
                        }
                    }

                    // Replace spaces and unsafe chars in category name
                    String safeCategoryName = trimmedName.toLowerCase().replaceAll("[^a-z0-9-_]", "-");
                    String fileName = safeCategoryName + extension; // e.g. "fruits.jpg"
                    String objectName = "category-images/" + fileName;

                    StorageClient storageClient = FirebaseConfig.getStorage();
                    try (InputStream in = imagePart.getInputStream()) {
                        storageClient.bucket().create(objectName, in, imagePart.getContentType());
                    }

                    String bucketName = storageClient.bucket().getName();
                    String encodedObject = URLEncoder.encode(objectName, StandardCharsets.UTF_8);
                    imageUrl = String.format(
                            "https://firebasestorage.googleapis.com/v0/b/%s/o/%s?alt=media",
                            bucketName,
                            encodedObject
                    );

                    System.out.println("Image uploaded: " + objectName + " -> " + imageUrl);
                }
            } catch (Exception e) {
                System.err.println("Error during category image upload: " + e.getMessage());
                e.printStackTrace();
                req.getSession().setAttribute("statusMessage", "Failed to upload image. Check server logs.");
            }

            // save to Firestore via DAO with name + imageUrl + active
            categoryDao.addCategory(trimmedName, imageUrl, active);
            if (req.getSession().getAttribute("statusMessage") == null) {
                req.getSession().setAttribute("statusMessage", "Category '" + trimmedName + "' added.");
            }
        }

        resp.sendRedirect(req.getContextPath() + "/categories");
    }
}