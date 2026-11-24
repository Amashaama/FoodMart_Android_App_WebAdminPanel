<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Food Items - FoodMart Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=20261003">
</head>
<body>
<jsp:include page="sidebar.jsp" />

<div class="content">
    <jsp:include page="topbar.jsp" />

    <c:if test="${not empty statusMessage}">
        <div class="alert-banner alert-success">
            <span class="material-icons alert-icon">check_circle</span>
            <span class="alert-text">${statusMessage}</span>
            <button type="button" class="alert-close" onclick="this.parentElement.remove()">✕</button>
        </div>
    </c:if>

    <!-- Mini Stat Cards for Food Items -->
    <div class="page-stat-row">
        <div class="stat-mini-card">
            <div class="stat-mini-icon bg-amber-light">
                <span class="material-icons text-amber">restaurant</span>
            </div>
            <div class="stat-mini-info">
                <span class="stat-mini-label">Total Food Items</span>
                <span class="stat-mini-val">${totalCount != null ? totalCount : items.size()}</span>
            </div>
        </div>
        <div class="stat-mini-card">
            <div class="stat-mini-icon bg-emerald-light">
                <span class="material-icons text-emerald">check_circle_outline</span>
            </div>
            <div class="stat-mini-info">
                <span class="stat-mini-label">Available in Menu</span>
                <c:set var="availCount" value="0"/>
                <c:forEach var="it" items="${items}">
                    <c:if test="${it.available}"><c:set var="availCount" value="${availCount + 1}"/></c:if>
                </c:forEach>
                <span class="stat-mini-val text-emerald">${availCount}</span>
            </div>
        </div>
        <div class="stat-mini-card">
            <div class="stat-mini-icon bg-rose-light">
                <span class="material-icons text-rose">remove_circle_outline</span>
            </div>
            <div class="stat-mini-info">
                <span class="stat-mini-label">Unavailable / Sold Out</span>
                <span class="stat-mini-val text-rose">${(totalCount != null ? totalCount : items.size()) - availCount}</span>
            </div>
        </div>
    </div>

    <!-- Table Card Container -->
    <div class="table-card">
        <div class="table-header-toolbar">
            <div class="table-title-group">
                <h2 class="table-title">Menu Catalog</h2>
                <span class="table-subtitle">Manage item availability, stock quantities, and pricing.</span>
            </div>

            <!-- Instant Search Bar right on top of Food Items -->
            <div class="table-actions-bar">
                <div class="table-search-box">
                    <span class="material-icons table-search-icon">search</span>
                          <input type="text"
                              id="tableSearchInput"
                              placeholder="Search food items by item ID..."
                              value="<c:out value='${searchQuery}'/>"
                              autocomplete="off" />
                    <button type="button" id="tableSearchClear" class="search-clear-btn" style="display:none;" title="Clear">✕</button>
                </div>

                <div class="table-count-badge">
                    Showing <strong id="filterCount">${items.size()}</strong> of <span id="totalCountBadge">${totalCount != null ? totalCount : items.size()}</span>
                </div>
            </div>
        </div>

        <div class="table-responsive">
            <table class="data-table">
                <thead>
                <tr>
                    <th>Item Info</th>
                    <th>Category</th>
                    <th>Price</th>
                    <th>Stock Qty</th>
                    <th>Sold</th>
                    <th>Status</th>
                    <th>Seller</th>
                    <th style="text-align: right;">Action</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="item" items="${items}">
                    <tr data-status="${item.available ? 'Available' : 'Unavailable'}" data-search-id="${item.itemId}">
                        <td>
                            <div class="item-cell">
                                <div class="item-thumb-box">
                                    <c:choose>
                                        <c:when test="${not empty item.imageUris && not empty item.imageUris[0]}">
                                            <img src="${item.imageUris[0]}" alt="${item.itemName}" class="item-thumb" onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';" />
                                            <div class="item-thumb-fallback" style="display:none;">
                                                <span class="material-icons">fastfood</span>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="item-thumb-fallback">
                                                <span class="material-icons">fastfood</span>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="item-meta">
                                    <span class="item-name">${item.itemName}</span>
                                    <span class="item-id">ID: ${item.itemId}</span>
                                </div>
                            </div>
                        </td>
                        <td>
                            <span class="badge badge-category">${not empty item.categoryName ? item.categoryName : 'Uncategorized'}</span>
                        </td>
                        <td>
                            <span class="cell-price">LKR <fmt:formatNumber value="${item.itemPrice}" pattern="#,##0.00"/></span>
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${item.quantity <= 0}">
                                    <span class="stock-badge stock-out">Out of Stock</span>
                                </c:when>
                                <c:when test="${item.quantity <= 5}">
                                    <span class="stock-badge stock-low">${item.quantity} left</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="stock-badge stock-ok">${item.quantity} in stock</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <span class="cell-sold">
                                <span class="material-icons text-amber" style="font-size: 14px; vertical-align: middle;">local_fire_department</span>
                                ${item.soldCount != null ? item.soldCount : 0}
                            </span>
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${item.available}">
                                    <span class="badge badge-success">
                                        <span class="badge-dot"></span> Available
                                    </span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge badge-danger">
                                        <span class="badge-dot"></span> Unavailable
                                    </span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <div class="seller-cell" title="Seller ID: ${item.sellerId}">
                                <span class="material-icons seller-icon">store</span>
                                <span class="seller-id-text">${item.sellerId}</span>
                            </div>
                        </td>
                        <td style="text-align: right;">
                            <form method="post" action="${pageContext.request.contextPath}/food-items" style="display:inline;">
                                <input type="hidden" name="itemId" value="${item.itemId}" />
                                <c:choose>
                                    <c:when test="${item.available}">
                                        <button type="submit" class="btn-action-danger" title="Mark this item unavailable in mobile app">
                                            <span class="material-icons" style="font-size: 15px;">block</span>
                                            <span>Set Unavailable</span>
                                        </button>
                                    </c:when>
                                    <c:otherwise>
                                        <button type="submit" class="btn-action-success" title="Mark this item available in mobile app">
                                            <span class="material-icons" style="font-size: 15px;">check_circle</span>
                                            <span>Set Available</span>
                                        </button>
                                    </c:otherwise>
                                </c:choose>
                            </form>
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
