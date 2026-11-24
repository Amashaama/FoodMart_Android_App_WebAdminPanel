<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Users - FoodMart Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=20261003">
</head>
<body>
<jsp:include page="sidebar.jsp" />

<div class="content">
    <jsp:include page="topbar.jsp" />

    <!-- Users Mini Stat Cards -->
    <div class="page-stat-row">
        <div class="stat-mini-card">
            <div class="stat-mini-icon bg-indigo-light">
                <span class="material-icons text-indigo">groups</span>
            </div>
            <div class="stat-mini-info">
                <span class="stat-mini-label">Total Accounts</span>
                <span class="stat-mini-val">${totalCount != null ? totalCount : users.size()}</span>
            </div>
        </div>
        <div class="stat-mini-card">
            <div class="stat-mini-icon bg-emerald-light">
                <span class="material-icons text-emerald">phone_in_talk</span>
            </div>
            <div class="stat-mini-info">
                <span class="stat-mini-label">With Phone Number</span>
                <c:set var="phoneCount" value="0"/>
                <c:forEach var="u" items="${users}">
                    <c:if test="${not empty u.phone}"><c:set var="phoneCount" value="${phoneCount + 1}"/></c:if>
                </c:forEach>
                <span class="stat-mini-val text-emerald">${phoneCount}</span>
            </div>
        </div>
        <div class="stat-mini-card">
            <div class="stat-mini-icon bg-amber-light">
                <span class="material-icons text-amber">location_city</span>
            </div>
            <div class="stat-mini-info">
                <span class="stat-mini-label">Locations Covered</span>
                <c:set var="cityCount" value="0"/>
                <c:forEach var="u" items="${users}">
                    <c:if test="${not empty u.city}"><c:set var="cityCount" value="${cityCount + 1}"/></c:if>
                </c:forEach>
                <span class="stat-mini-val text-amber">${cityCount}</span>
            </div>
        </div>
    </div>

    <!-- Table Card Container -->
    <div class="table-card">
        <div class="table-header-toolbar">
            <div class="table-title-group">
                <h2 class="table-title">User Directory</h2>
                <span class="table-subtitle">Search, view, and inspect all registered FoodMart app accounts.</span>
            </div>

            <!-- Instant Search Bar right on top of Users -->
            <div class="table-actions-bar">
                <div class="table-search-box">
                    <span class="material-icons table-search-icon">search</span>
                          <input type="text"
                              id="tableSearchInput"
                              placeholder="Search users by user ID..."
                              value="<c:out value='${searchQuery}'/>"
                              autocomplete="off" />
                    <button type="button" id="tableSearchClear" class="search-clear-btn" style="display:none;" title="Clear">✕</button>
                </div>

                <div class="table-count-badge">
                    Showing <strong id="filterCount">${users.size()}</strong> of <span id="totalCountBadge">${totalCount != null ? totalCount : users.size()}</span>
                </div>
            </div>
        </div>

        <div class="table-responsive">
            <table class="data-table">
                <thead>
                <tr>
                    <th>User Profile</th>
                    <th>Email Address</th>
                    <th>Phone Number</th>
                    <th>City / Location</th>
                    <th>Address</th>
                    <th>User ID</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="u" items="${users}">
                    <tr data-status="${not empty u.phone ? 'verified' : 'unverified'}" data-search-id="${u.uid}">
                        <td>
                            <div class="user-row-profile">
                                <div class="user-row-avatar">
                                    <c:choose>
                                        <c:when test="${not empty u.profilePicUrl}">
                                            <img src="${u.profilePicUrl}" alt="${u.name}" class="avatar-img" onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';" />
                                            <span class="avatar-initials" style="display:none;">${not empty u.name ? u.name.substring(0, 1).toUpperCase() : 'U'}</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="avatar-initials">${not empty u.name ? u.name.substring(0, 1).toUpperCase() : 'U'}</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="user-row-info">
                                    <span class="user-row-name">${not empty u.name ? u.name : 'Unknown User'}</span>
                                    <span class="badge badge-customer">Customer</span>
                                </div>
                            </div>
                        </td>
                        <td>
                            <div class="cell-email">
                                <span class="material-icons" style="font-size:14px; opacity:0.6;">email</span>
                                <a href="mailto:${u.email}">${not empty u.email ? u.email : 'No email'}</a>
                            </div>
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${not empty u.phone}">
                                    <span class="cell-phone">
                                        <span class="material-icons" style="font-size:14px; opacity:0.6;">phone</span>
                                        ${u.phone}
                                    </span>
                                </c:when>
                                <c:otherwise>
                                    <span class="text-muted-dash">-</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${not empty u.city}">
                                    <span class="badge badge-city">
                                        <span class="material-icons" style="font-size:12px;">place</span>
                                        ${u.city}
                                    </span>
                                </c:when>
                                <c:otherwise>
                                    <span class="text-muted-dash">-</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <span class="cell-address" title="${u.address}">
                                ${not empty u.address ? u.address : '-'}
                            </span>
                        </td>
                        <td>
                            <code class="uid-tag" title="User ID: ${u.uid}">${u.uid}</code>
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
