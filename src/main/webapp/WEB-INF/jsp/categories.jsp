<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Categories - FoodMart Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=20261003">
</head>
<body>
<jsp:include page="sidebar.jsp" />

<div class="content">
    <jsp:include page="topbar.jsp" />

    <c:if test="${not empty statusMessage}">
        <div class="alert-banner alert-info">
            <span class="material-icons alert-icon">info</span>
            <span class="alert-text">${statusMessage}</span>
            <button type="button" class="alert-close" onclick="this.parentElement.remove()">✕</button>
        </div>
    </c:if>

    <!-- Create Category Form Card -->
    <div class="form-card">
        <div class="form-card-header">
            <div class="form-header-icon bg-purple-light">
                <span class="material-icons text-purple">add_photo_alternate</span>
            </div>
            <div>
                <h2 class="form-card-title">Add New Food Category</h2>
                <span class="form-card-subtitle">Upload category thumbnail and activate display in mobile app catalog.</span>
            </div>
        </div>

        <form method="post" action="${pageContext.request.contextPath}/categories" enctype="multipart/form-data" class="category-form">
            <div class="form-grid-3">
                <div class="form-field">
                    <label class="form-label" for="categoryName">Category Name <span class="required-star">*</span></label>
                    <div class="input-with-icon">
                        <span class="material-icons input-icon">label</span>
                        <input type="text" id="categoryName" name="name" placeholder="e.g. Burgers, Pizza, Desserts" required />
                    </div>
                </div>

                <div class="form-field">
                    <label class="form-label" for="categoryImage">Category Image <span class="required-star">*</span></label>
                    <div class="file-input-wrapper">
                        <input type="file" id="categoryImage" name="imageFile" accept="image/*" required />
                    </div>
                </div>

                <div class="form-field form-field-switch">
                    <label class="form-label">Category Status</label>
                    <label class="modern-switch-label">
                        <input type="checkbox" name="active" checked />
                        <span class="switch-slider"></span>
                        <span class="switch-text">Visible in App</span>
                    </label>
                </div>
            </div>

            <div class="form-actions-bar">
                <button type="submit" class="btn-primary">
                    <span class="material-icons">add_circle</span>
                    <span>Create Category</span>
                </button>
            </div>
        </form>
    </div>

    <!-- Existing Categories Table Card -->
    <div class="table-card">
        <div class="table-header-toolbar">
            <div class="table-title-group">
                <h2 class="table-title">Existing Food Categories</h2>
                <span class="table-subtitle">Catalog categories currently organized in the database.</span>
            </div>

            <!-- Instant Search Bar for Categories -->
            <div class="table-actions-bar">
                <div class="table-search-box">
                    <span class="material-icons table-search-icon">search</span>
                          <input type="text"
                              id="tableSearchInput"
                              placeholder="Search categories by category ID..."
                              autocomplete="off" />
                    <button type="button" id="tableSearchClear" class="search-clear-btn" style="display:none;" title="Clear">✕</button>
                </div>

                <div class="table-count-badge">
                    Showing <strong id="filterCount">${categories.size()}</strong> of <span id="totalCountBadge">${categories.size()}</span>
                </div>
            </div>
        </div>

        <div class="table-responsive">
            <table class="data-table">
                <thead>
                <tr>
                    <th>Category Preview</th>
                    <th>Category Name</th>
                    <th>Category ID</th>
                    <th>App Status</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="categ" items="${categories}">
                    <tr data-status="${categ.active ? 'active' : 'inactive'}" data-search-id="${categ.id}">
                        <td>
                            <div class="category-thumb-wrapper">
                                <c:choose>
                                    <c:when test="${not empty categ.imageUrl}">
                                        <img src="${categ.imageUrl}" alt="${categ.name}" class="category-thumb-img" onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';" />
                                        <div class="category-thumb-fallback" style="display:none;">
                                            <span class="material-icons">category</span>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="category-thumb-fallback">
                                            <span class="material-icons">category</span>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </td>
                        <td>
                            <div class="category-name-cell">
                                <span class="category-name-bold">${categ.name}</span>
                            </div>
                        </td>
                        <td>
                            <code class="uid-tag">${categ.id}</code>
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${categ.active}">
                                    <span class="badge badge-success">
                                        <span class="badge-dot"></span> Active
                                    </span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge badge-danger">
                                        <span class="badge-dot"></span> Inactive
                                    </span>
                                </c:otherwise>
                            </c:choose>
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
