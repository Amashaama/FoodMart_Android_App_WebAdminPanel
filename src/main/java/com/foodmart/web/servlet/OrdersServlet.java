package com.foodmart.web.servlet;

import com.foodmart.dao.OrderDao;
import com.foodmart.model.Order;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "OrdersServlet", urlPatterns = "/orders")
public class OrdersServlet extends HttpServlet {

    private final OrderDao orderDao = new OrderDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setAttribute("activePage", "orders");

        List<Order> orders = orderDao.findAll();
        int totalCount = orders != null ? orders.size() : 0;
        req.setAttribute("totalCount", totalCount);

        String query = req.getParameter("q");
        if (query != null && !query.trim().isEmpty()) {
            String qLower = query.trim().toLowerCase();
            if (orders != null) {
                orders = orders.stream().filter(o ->
                        (o.getOrderId() != null && o.getOrderId().toLowerCase().contains(qLower)) ||
                        (o.getUserId() != null && o.getUserId().toLowerCase().contains(qLower)) ||
                        (o.getFullName() != null && o.getFullName().toLowerCase().contains(qLower)) ||
                        (o.getEmail() != null && o.getEmail().toLowerCase().contains(qLower)) ||
                        (o.getPhone() != null && o.getPhone().toLowerCase().contains(qLower)) ||
                        (o.getCity() != null && o.getCity().toLowerCase().contains(qLower)) ||
                        (o.getStatus() != null && o.getStatus().toLowerCase().contains(qLower)) ||
                        (o.getPaymentMethod() != null && o.getPaymentMethod().toLowerCase().contains(qLower))
                ).collect(java.util.stream.Collectors.toList());
            }
            req.setAttribute("searchQuery", query.trim());
        }

        req.setAttribute("orders", orders);
        req.getRequestDispatcher("/WEB-INF/jsp/orders.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String orderId = req.getParameter("orderId");
        String status = req.getParameter("status");
        if (orderId != null && status != null) {
            orderDao.updateStatus(orderId, status);
        }
        resp.sendRedirect(req.getContextPath() + "/orders");
    }
}
