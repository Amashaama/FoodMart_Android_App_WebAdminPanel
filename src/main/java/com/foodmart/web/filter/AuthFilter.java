package com.foodmart.web.filter;

import jakarta.servlet.*;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

public class AuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;

        String contextPath = req.getContextPath();
        String uri = req.getRequestURI();
        String path = uri.substring(contextPath.length());

        HttpSession session = req.getSession(false);
        boolean loggedIn = (session != null && session.getAttribute("admin") != null);

        // Allow public resources: login, static files, Firebase callbacks if any
        boolean isPublic =
                path.equals("/login") ||
                path.equals("/logout") ||
                path.startsWith("/css/") ||
                path.startsWith("/favicon") ||
                path.startsWith("/resources/");

        if (!loggedIn && !isPublic) {
            resp.sendRedirect(contextPath + "/login");
            return;
        }

        // At this point either logged in or accessing a public path.
        // If logged in and path does not match any known route, force a 404 so web.xml error-page kicks in.
        if (loggedIn) {
            boolean known =
                    path.equals("/") ||
                    path.equals("/login") ||
                    path.equals("/logout") ||
                    path.equals("/dashboard") ||
                    path.equals("/users") ||
                    path.equals("/food-items") ||
                    path.equals("/orders") ||
                    path.equals("/categories") ||
                    path.equals("/lost") ||
                    path.startsWith("/api/") ||
                    path.startsWith("/css/");

            if (!known) {
                resp.sendError(HttpServletResponse.SC_NOT_FOUND);
                return;
            }
        }

        chain.doFilter(request, response);
    }

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // no-op
    }

    @Override
    public void destroy() {
        // no-op
    }
}
