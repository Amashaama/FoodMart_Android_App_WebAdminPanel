<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - FoodMart Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=20261003">
</head>
<body>
<jsp:include page="sidebar.jsp" />

<div class="content">
    <jsp:include page="topbar.jsp" />

    <!-- Welcome Banner with Quick Actions -->
    <div class="dashboard-hero-banner">
        <div class="hero-text-content">
            <span class="hero-tag">System Live</span>
            <h2 class="hero-title">Welcome back, Admin 👋</h2>
            <p class="hero-desc">Here is what is happening across your FoodMart operations today. Monitor catalog stock, track real-time orders, and manage users.</p>
        </div>
        <div class="hero-quick-actions">
            <a href="${pageContext.request.contextPath}/food-items" class="btn-hero btn-hero-primary">
                <span class="material-icons">restaurant_menu</span>
                <span>Manage Food Items</span>
            </a>
            <a href="${pageContext.request.contextPath}/orders" class="btn-hero btn-hero-secondary">
                <span class="material-icons">receipt_long</span>
                <span>View Orders</span>
            </a>
        </div>
    </div>

    <!-- Executive Metric Cards -->
    <div class="cards-grid">
        <div class="metric-card">
            <div class="metric-card-top">
                <div class="metric-icon-box bg-blue-grad">
                    <span class="material-icons">people</span>
                </div>
                <span class="metric-trend text-blue">Accounts</span>
            </div>
            <div class="metric-card-bottom">
                <span class="metric-val">${userCount}</span>
                <span class="metric-label">Registered Users</span>
            </div>
        </div>

        <div class="metric-card">
            <div class="metric-card-top">
                <div class="metric-icon-box bg-amber-grad">
                    <span class="material-icons">fastfood</span>
                </div>
                <span class="metric-trend text-amber">In Catalog</span>
            </div>
            <div class="metric-card-bottom">
                <span class="metric-val">${foodCount}</span>
                <span class="metric-label">Total Food Items</span>
            </div>
        </div>

        <div class="metric-card">
            <div class="metric-card-top">
                <div class="metric-icon-box bg-emerald-grad">
                    <span class="material-icons">shopping_bag</span>
                </div>
                <span class="metric-trend text-emerald">Active</span>
            </div>
            <div class="metric-card-bottom">
                <span class="metric-val">${orderCount}</span>
                <span class="metric-label">Total Orders Placed</span>
            </div>
        </div>

        <div class="metric-card">
            <div class="metric-card-top">
                <div class="metric-icon-box bg-purple-grad">
                    <span class="material-icons">category</span>
                </div>
                <span class="metric-trend text-purple">Sections</span>
            </div>
            <div class="metric-card-bottom">
                <span class="metric-val">${categoryCount}</span>
                <span class="metric-label">Food Categories</span>
            </div>
        </div>

        <!-- Top Sold Item Highlight Card -->
        <div class="metric-card top-seller-card">
            <div class="metric-card-top">
                <div class="metric-icon-box bg-rose-grad">
                    <span class="material-icons">emoji_events</span>
                </div>
                <span class="metric-trend text-rose">#1 Best Seller</span>
            </div>
            <div class="metric-card-bottom">
                <span class="metric-val text-truncate" title="${topSoldName}">${topSoldName}</span>
                <span class="metric-label">Highest Sold Menu Item</span>
            </div>
        </div>
    </div>

    <!-- Latest Items Table Card -->
    <div class="table-card">
        <div class="table-header-toolbar">
            <div class="table-title-group">
                <h2 class="table-title">Latest Added Food Items</h2>
                <span class="table-subtitle">Recent culinary items published by sellers to the mobile catalog.</span>
            </div>
            <div class="table-actions-bar">
                <div class="table-search-box">
                    <span class="material-icons table-search-icon">search</span>
                          <input type="text"
                              id="tableSearchInput"
                              placeholder="Search latest items by item ID..."
                              autocomplete="off" />
                    <button type="button" id="tableSearchClear" class="search-clear-btn" style="display:none;" title="Clear">✕</button>
                </div>
                <a href="${pageContext.request.contextPath}/food-items" class="btn-link-action">
                    <span>View All Food Items</span>
                    <span class="material-icons" style="font-size:16px;">arrow_forward</span>
                </a>
            </div>
        </div>

        <div class="table-responsive">
            <table class="data-table">
                <thead>
                <tr>
                    <th>Item ID</th>
                    <th>Item Name</th>
                    <th>Category</th>
                    <th>Price</th>
                    <th>Sold Count</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="item" items="${latestItems}">
                    <tr data-search-id="${item.itemId}">
                        <td>
                            <code class="uid-tag">${item.itemId}</code>
                        </td>
                        <td>
                            <div class="item-name-cell">
                                <span class="material-icons text-amber" style="font-size:16px;">restaurant</span>
                                <span class="item-name-bold">${item.itemName}</span>
                            </div>
                        </td>
                        <td>
                            <span class="badge badge-category">${item.categoryName}</span>
                        </td>
                        <td>
                            <span class="cell-price">LKR <fmt:formatNumber value="${item.itemPrice}" pattern="#,##0.00"/></span>
                        </td>
                        <td>
                            <span class="cell-sold">
                                <span class="material-icons text-amber" style="font-size: 14px; vertical-align: middle;">local_fire_department</span>
                                <c:out value="${item.soldCount != null ? item.soldCount : 0}"/> orders
                            </span>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>

<script src="${pageContext.request.contextPath}/js/admin.js?v=20261003b"></script>
</body>
</html>
