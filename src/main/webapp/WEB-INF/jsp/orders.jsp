<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Orders - FoodMart Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=20261003">
</head>
<body>
<jsp:include page="sidebar.jsp" />

<div class="content">
    <jsp:include page="topbar.jsp" />

    <!-- Orders Mini Stats -->
    <div class="page-stat-row">
        <div class="stat-mini-card">
            <div class="stat-mini-icon bg-indigo-light">
                <span class="material-icons text-indigo">receipt_long</span>
            </div>
            <div class="stat-mini-info">
                <span class="stat-mini-label">Total Orders</span>
                <span class="stat-mini-val">${totalCount != null ? totalCount : orders.size()}</span>
            </div>
        </div>
        <div class="stat-mini-card">
            <div class="stat-mini-icon bg-amber-light">
                <span class="material-icons text-amber">hourglass_top</span>
            </div>
            <div class="stat-mini-info">
                <span class="stat-mini-label">Processing</span>
                <c:set var="procCount" value="0"/>
                <c:forEach var="o" items="${orders}">
                    <c:if test="${o.status == 'Processing'}"><c:set var="procCount" value="${procCount + 1}"/></c:if>
                </c:forEach>
                <span class="stat-mini-val text-amber">${procCount}</span>
            </div>
        </div>
        <div class="stat-mini-card">
            <div class="stat-mini-icon bg-emerald-light">
                <span class="material-icons text-emerald">local_shipping</span>
            </div>
            <div class="stat-mini-info">
                <span class="stat-mini-label">Delivered</span>
                <c:set var="delivCount" value="0"/>
                <c:forEach var="o" items="${orders}">
                    <c:if test="${o.status == 'Delivered'}"><c:set var="delivCount" value="${delivCount + 1}"/></c:if>
                </c:forEach>
                <span class="stat-mini-val text-emerald">${delivCount}</span>
            </div>
        </div>
        <div class="stat-mini-card">
            <div class="stat-mini-icon bg-rose-light">
                <span class="material-icons text-rose">cancel</span>
            </div>
            <div class="stat-mini-info">
                <span class="stat-mini-label">Cancelled</span>
                <c:set var="cancCount" value="0"/>
                <c:forEach var="o" items="${orders}">
                    <c:if test="${o.status == 'Cancelled'}"><c:set var="cancCount" value="${cancCount + 1}"/></c:if>
                </c:forEach>
                <span class="stat-mini-val text-rose">${cancCount}</span>
            </div>
        </div>
    </div>

    <!-- Table Card Container -->
    <div class="table-card">
        <div class="table-header-toolbar">
            <div class="table-title-group">
                <h2 class="table-title">All Customer Orders</h2>
                <span class="table-subtitle">Review order totals, payment methods, delivery details, and update statuses.</span>
            </div>

            <!-- Instant Search Bar right on top of Orders -->
            <div class="table-actions-bar">
                <div class="table-search-box">
                    <span class="material-icons table-search-icon">search</span>
                          <input type="text"
                              id="tableSearchInput"
                              placeholder="Search orders by order ID..."
                              value="<c:out value='${searchQuery}'/>"
                              autocomplete="off" />
                    <button type="button" id="tableSearchClear" class="search-clear-btn" style="display:none;" title="Clear">✕</button>
                </div>

                <div class="table-count-badge">
                    Showing <strong id="filterCount">${orders.size()}</strong> of <span id="totalCountBadge">${totalCount != null ? totalCount : orders.size()}</span>
                </div>
            </div>
        </div>

        <div class="table-responsive">
            <table class="data-table">
                <thead>
                <tr>
                    <th>Order ID</th>
                    <th>Customer</th>
                    <th>Destination</th>
                    <th>Payment</th>
                    <th>Total Amount</th>
                    <th>Status</th>
                    <th>Date / Time</th>
                    <th style="text-align: right;">Update Status</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="o" items="${orders}">
                    <tr data-status="${o.status}" data-search-id="${o.orderId}">
                        <td>
                            <div class="order-id-badge" title="Order ID: ${o.orderId}">
                                <span class="material-icons" style="font-size:14px; opacity:0.7;">tag</span>
                                <code>${o.orderId}</code>
                            </div>
                        </td>
                        <td>
                            <div class="customer-cell">
                                <div class="customer-avatar">
                                    <span>${not empty o.fullName ? o.fullName.substring(0, 1).toUpperCase() : 'U'}</span>
                                </div>
                                <div class="customer-details">
                                    <span class="customer-name">${not empty o.fullName ? o.fullName : 'Guest User'}</span>
                                    <span class="customer-meta">${not empty o.phone ? o.phone : o.userId}</span>
                                </div>
                            </div>
                        </td>
                        <td>
                            <div class="destination-cell">
                                <span class="dest-city">${not empty o.city ? o.city : 'N/A'}</span>
                                <span class="dest-address" title="${o.addressLine1}">${o.addressLine1}</span>
                            </div>
                        </td>
                        <td>
                            <span class="badge badge-payment">
                                <span class="material-icons" style="font-size:13px;">payment</span>
                                ${not empty o.paymentMethod ? o.paymentMethod : 'Cash'}
                            </span>
                        </td>
                        <td>
                            <span class="cell-price-bold">LKR <fmt:formatNumber value="${o.total}" pattern="#,##0.00"/></span>
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${o.status == 'Delivered'}">
                                    <span class="badge badge-delivered">
                                        <span class="badge-dot"></span> Delivered
                                    </span>
                                </c:when>
                                <c:when test="${o.status == 'Processing'}">
                                    <span class="badge badge-processing">
                                        <span class="badge-dot"></span> Processing
                                    </span>
                                </c:when>
                                <c:when test="${o.status == 'Paid'}">
                                    <span class="badge badge-paid">
                                        <span class="badge-dot"></span> Paid
                                    </span>
                                </c:when>
                                <c:when test="${o.status == 'Cancelled'}">
                                    <span class="badge badge-cancelled">
                                        <span class="badge-dot"></span> Cancelled
                                    </span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge badge-neutral">
                                        <span class="badge-dot"></span> ${o.status}
                                    </span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <span class="cell-date">
                                <c:choose>
                                    <c:when test="${not empty o.createdAt}">
                                        <span class="material-icons" style="font-size:13px; opacity:0.6;">calendar_today</span>
                                        ${o.createdAt}
                                    </c:when>
                                    <c:otherwise>Recent</c:otherwise>
                                </c:choose>
                            </span>
                        </td>
                        <td style="text-align: right;">
                            <form method="post" action="${pageContext.request.contextPath}/orders" class="status-update-form">
                                <input type="hidden" name="orderId" value="${o.orderId}" />
                                <div class="status-select-wrap">
                                    <select name="status" class="status-select">
                                        <option value="Paid" ${o.status == 'Paid' ? 'selected' : ''}>Paid</option>
                                        <option value="Processing" ${o.status == 'Processing' ? 'selected' : ''}>Processing</option>
                                        <option value="Delivered" ${o.status == 'Delivered' ? 'selected' : ''}>Delivered</option>
                                        <option value="Cancelled" ${o.status == 'Cancelled' ? 'selected' : ''}>Cancelled</option>
                                    </select>
                                    <button type="submit" class="btn-save-status" title="Save new status">
                                        <span class="material-icons">save</span>
                                    </button>
                                </div>
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
