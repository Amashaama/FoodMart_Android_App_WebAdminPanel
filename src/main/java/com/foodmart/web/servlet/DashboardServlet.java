package com.foodmart.web.servlet;

import com.foodmart.dao.CategoryDao;
import com.foodmart.dao.FoodItemDao;
import com.foodmart.dao.OrderDao;
import com.foodmart.dao.UserDao;
import com.foodmart.model.FoodItem;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "DashboardServlet", urlPatterns = "/dashboard")
public class DashboardServlet extends HttpServlet {

    private final UserDao userDao = new UserDao();
    private final FoodItemDao foodItemDao = new FoodItemDao();
    private final OrderDao orderDao = new OrderDao();
    private final CategoryDao categoryDao = new CategoryDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setAttribute("activePage", "dashboard");
        long userCount = userDao.count();
        long foodCount = foodItemDao.count();
        long orderCount = orderDao.count();
        long categoryCount = categoryDao.count();

        FoodItem topSold = foodItemDao.findTopSoldItem();
        String topSoldName = topSold != null && topSold.getItemName() != null ? topSold.getItemName() : "N/A";

        List<com.foodmart.model.FoodItem> latestItems = foodItemDao.findAll();
        if (latestItems != null && latestItems.size() > 5) {
            latestItems = latestItems.subList(0, 5);
        }

        req.setAttribute("userCount", userCount);
        req.setAttribute("foodCount", foodCount);
        req.setAttribute("orderCount", orderCount);
        req.setAttribute("categoryCount", categoryCount);
        req.setAttribute("topSoldName", topSoldName);
        req.setAttribute("latestItems", latestItems);

        req.getRequestDispatcher("/WEB-INF/jsp/dashboard.jsp").forward(req, resp);
    }
}
