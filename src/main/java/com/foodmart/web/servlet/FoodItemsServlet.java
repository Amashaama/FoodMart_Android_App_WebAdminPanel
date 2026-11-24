package com.foodmart.web.servlet;

import com.foodmart.dao.FoodItemDao;
import com.foodmart.model.FoodItem;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "FoodItemsServlet", urlPatterns = "/food-items")
public class FoodItemsServlet extends HttpServlet {

    private final FoodItemDao foodItemDao = new FoodItemDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // move flash message from session to request so it shows once
        String statusMessage = (String) req.getSession().getAttribute("statusMessage");
        if (statusMessage != null) {
            req.setAttribute("statusMessage", statusMessage);
            req.getSession().removeAttribute("statusMessage");
        }

        req.setAttribute("activePage", "food-items");

        List<FoodItem> items = foodItemDao.findAll();
        int totalCount = items != null ? items.size() : 0;
        req.setAttribute("totalCount", totalCount);

        String query = req.getParameter("q");
        if (query != null && !query.trim().isEmpty()) {
            String qLower = query.trim().toLowerCase();
            if (items != null) {
                items = items.stream().filter(item ->
                        (item.getItemName() != null && item.getItemName().toLowerCase().contains(qLower)) ||
                        (item.getItemId() != null && item.getItemId().toLowerCase().contains(qLower)) ||
                        (item.getCategoryName() != null && item.getCategoryName().toLowerCase().contains(qLower)) ||
                        (item.getSellerId() != null && item.getSellerId().toLowerCase().contains(qLower)) ||
                        (item.getSellerCity() != null && item.getSellerCity().toLowerCase().contains(qLower))
                ).collect(java.util.stream.Collectors.toList());
            }
            req.setAttribute("searchQuery", query.trim());
        }

        req.setAttribute("items", items);
        req.getRequestDispatcher("/WEB-INF/jsp/food-items.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String itemId = req.getParameter("itemId");
        if (itemId != null && !itemId.isEmpty()) {
            foodItemDao.toggleAvailability(itemId);
            req.getSession().setAttribute("statusMessage", "Food item status changed.");
        }
        // Redirect to avoid resubmission and ensure updated list is loaded via doGet
        resp.sendRedirect(req.getContextPath() + "/food-items");
    }
}
