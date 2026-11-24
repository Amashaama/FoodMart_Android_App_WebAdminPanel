package com.foodmart.web.api;

import com.foodmart.dao.FoodItemDao;
import com.foodmart.model.FoodItem;
import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "FoodItemsApiServlet", urlPatterns = "/api/food-items")
public class FoodItemsApiServlet extends HttpServlet {

    private final FoodItemDao foodItemDao = new FoodItemDao();
    private final Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<FoodItem> items = foodItemDao.findAll();
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        resp.getWriter().write(gson.toJson(items));
    }
}
