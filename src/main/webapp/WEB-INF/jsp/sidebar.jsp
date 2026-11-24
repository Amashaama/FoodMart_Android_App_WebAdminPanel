<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!-- Google Fonts & Material Icons -->
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
<link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">

<aside class="sidebar" id="sidebar">
    <div class="sidebar-header">
        <a href="${pageContext.request.contextPath}/dashboard" class="sidebar-brand">
            <div class="brand-logo-icon">
                <span class="material-icons">storefront</span>
            </div>
            <div class="brand-text-block">
                <span class="brand-title">FoodMart</span>
                <span class="brand-badge">ADMIN</span>
            </div>
        </a>
        <button type="button" class="sidebar-toggle" title="Collapse sidebar" aria-label="Toggle Navigation">
            <span class="material-icons">chevron_left</span>
        </button>
    </div>

    <div class="sidebar-nav-container">
        <div class="nav-section-label">MAIN NAVIGATION</div>
        <ul class="nav-list">
            <li>
                <a href="${pageContext.request.contextPath}/dashboard"
                   class="nav-link ${activePage == 'dashboard' ? 'active' : ''}">
                    <div class="nav-icon">
                        <span class="material-icons">dashboard</span>
                    </div>
                    <div class="nav-text-block">
                        <span class="nav-text-main">Dashboard</span>
                        <span class="nav-text-sub">Overview &amp; statistics</span>
                    </div>
                </a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/food-items"
                   class="nav-link ${activePage == 'food-items' ? 'active' : ''}">
                    <div class="nav-icon">
                        <span class="material-icons">restaurant_menu</span>
                    </div>
                    <div class="nav-text-block">
                        <span class="nav-text-main">Food Items</span>
                        <span class="nav-text-sub">Menu catalog &amp; stock</span>
                    </div>
                </a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/orders"
                   class="nav-link ${activePage == 'orders' ? 'active' : ''}">
                    <div class="nav-icon">
                        <span class="material-icons">receipt_long</span>
                    </div>
                    <div class="nav-text-block">
                        <span class="nav-text-main">Orders</span>
                        <span class="nav-text-sub">Customer orders &amp; status</span>
                    </div>
                </a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/users"
                   class="nav-link ${activePage == 'users' ? 'active' : ''}">
                    <div class="nav-icon">
                        <span class="material-icons">people_alt</span>
                    </div>
                    <div class="nav-text-block">
                        <span class="nav-text-main">Users</span>
                        <span class="nav-text-sub">Customers &amp; sellers</span>
                    </div>
                </a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/categories"
                   class="nav-link ${activePage == 'categories' ? 'active' : ''}">
                    <div class="nav-icon">
                        <span class="material-icons">category</span>
                    </div>
                    <div class="nav-text-block">
                        <span class="nav-text-main">Categories</span>
                        <span class="nav-text-sub">Catalog organization</span>
                    </div>
                </a>
            </li>
        </ul>
    </div>

    <!-- Sidebar Footer with User Card -->
    <div class="sidebar-footer">
        <div class="sidebar-user-card">
            <div class="user-avatar-circle">
                <span>AD</span>
                <span class="online-indicator" title="Admin Active"></span>
            </div>
            <div class="user-info-text">
                <span class="user-name">Administrator</span>
                <span class="user-email">admin@foodmart.com</span>
            </div>
            <a href="${pageContext.request.contextPath}/logout" class="sidebar-logout-btn" title="Sign out">
                <span class="material-icons">logout</span>
            </a>
        </div>
    </div>
</aside>
