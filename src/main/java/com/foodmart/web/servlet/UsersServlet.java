package com.foodmart.web.servlet;

import com.foodmart.dao.UserDao;
import com.foodmart.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "UsersServlet", urlPatterns = "/users")
public class UsersServlet extends HttpServlet {

    private final UserDao userDao = new UserDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setAttribute("activePage", "users");

        List<User> users = userDao.findAll();
        int totalCount = users != null ? users.size() : 0;
        req.setAttribute("totalCount", totalCount);

        String query = req.getParameter("q");
        if (query != null && !query.trim().isEmpty()) {
            String qLower = query.trim().toLowerCase();
            if (users != null) {
                users = users.stream().filter(u ->
                        (u.getName() != null && u.getName().toLowerCase().contains(qLower)) ||
                        (u.getEmail() != null && u.getEmail().toLowerCase().contains(qLower)) ||
                        (u.getPhone() != null && u.getPhone().toLowerCase().contains(qLower)) ||
                        (u.getCity() != null && u.getCity().toLowerCase().contains(qLower)) ||
                        (u.getUid() != null && u.getUid().toLowerCase().contains(qLower)) ||
                        (u.getAddress() != null && u.getAddress().toLowerCase().contains(qLower))
                ).collect(java.util.stream.Collectors.toList());
            }
            req.setAttribute("searchQuery", query.trim());
        }

        req.setAttribute("users", users);
        req.getRequestDispatcher("/WEB-INF/jsp/users.jsp").forward(req, resp);
    }
}
