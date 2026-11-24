<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<header class="top-header">
    <div class="top-header-left">
        <!-- Mobile hamburger toggle -->
        <button type="button" class="sidebar-mobile-toggle" aria-label="Toggle Sidebar">
            <span class="material-icons">menu</span>
        </button>

        <div class="page-header-info">
            <div class="breadcrumb-trail">
                <span class="breadcrumb-item">FoodMart</span>
                <span class="breadcrumb-separator">/</span>
                <span class="breadcrumb-current">
                    <c:choose>
                        <c:when test="${activePage == 'dashboard'}">Dashboard</c:when>
                        <c:when test="${activePage == 'food-items'}">Food Items</c:when>
                        <c:when test="${activePage == 'orders'}">Orders</c:when>
                        <c:when test="${activePage == 'users'}">Users</c:when>
                        <c:when test="${activePage == 'categories'}">Categories</c:when>
                        <c:otherwise>Overview</c:otherwise>
                    </c:choose>
                </span>
            </div>
            <h1 class="header-page-title">
                <c:choose>
                    <c:when test="${activePage == 'dashboard'}">Dashboard Overview</c:when>
                    <c:when test="${activePage == 'food-items'}">Food Items Catalog</c:when>
                    <c:when test="${activePage == 'orders'}">Customer Orders</c:when>
                    <c:when test="${activePage == 'users'}">User Directory</c:when>
                    <c:when test="${activePage == 'categories'}">Menu Categories</c:when>
                    <c:otherwise>Admin Console</c:otherwise>
                </c:choose>
            </h1>
        </div>
    </div>

    <!-- Topbar Right Meta & Admin Info -->
    <div class="top-header-right">
        <!-- Live System Status -->
        <div class="system-status-chip" title="Connected to Google Firebase Firestore">
            <span class="pulse-dot"></span>
            <span class="status-label">Online</span>
        </div>

        <!-- Admin Profile Pill -->
        <div class="admin-profile-pill">
            <div class="admin-avatar">
                <span>AD</span>
            </div>
            <div class="admin-details">
                <span class="admin-name">Admin</span>
                <span class="admin-role">Super Admin</span>
            </div>
            <a href="${pageContext.request.contextPath}/logout" class="header-logout-btn" title="Sign out of Admin Panel">
                <span class="material-icons">logout</span>
            </a>
        </div>
    </div>
</header>
<div class="sidebar-overlay"></div>
<script>
    window.FoodMartTableSearchSource = 'inline';

    document.addEventListener('DOMContentLoaded', function () {
        const tableInputs = document.querySelectorAll('.table-search-box input[id="tableSearchInput"]');

        tableInputs.forEach(function (tableInput) {
            const card = tableInput.closest('.table-card');
            if (!card) return;

            const clearBtn = card.querySelector('#tableSearchClear');

            const updateClear = function () {
                const hasText = tableInput.value.trim().length > 0;
                if (clearBtn) {
                    clearBtn.style.display = hasText ? 'flex' : 'none';
                }
            };

            const applyFilter = function () {
                const term = tableInput.value.toLowerCase().trim();
                const table = card.querySelector('.data-table, .table-card table');
                if (!table) return;

                const tbody = table.querySelector('tbody');
                if (!tbody) return;

                const rows = Array.from(tbody.querySelectorAll('tr:not(.empty-state-row)'));
                let visibleCount = 0;

                rows.forEach(function (row) {
                    const rowText = (row.textContent || row.innerText || '').toLowerCase();
                    const rowId = (row.getAttribute('data-search-id') || '').toLowerCase();
                    const matchesKeyword = !term || rowId.includes(term) || rowText.includes(term);

                    if (matchesKeyword) {
                        row.style.display = '';
                        visibleCount++;
                    } else {
                        row.style.display = 'none';
                    }
                });

                const countEl = card.querySelector('#filterCount');
                const totalEl = card.querySelector('#totalCountBadge');
                if (countEl) countEl.textContent = visibleCount;
                if (totalEl) totalEl.textContent = rows.length;
            };

            tableInput.addEventListener('input', function () {
                updateClear();
                applyFilter();
            });

            tableInput.addEventListener('keydown', function (e) {
                if (e.key === 'Escape') {
                    tableInput.value = '';
                    updateClear();
                    applyFilter();
                }
            });

            if (clearBtn) {
                clearBtn.addEventListener('click', function () {
                    tableInput.value = '';
                    updateClear();
                    applyFilter();
                    tableInput.focus();
                });
            }

            if (tableInput.value.trim()) {
                updateClear();
                applyFilter();
            } else {
                updateClear();
            }
        });
    });
</script>
