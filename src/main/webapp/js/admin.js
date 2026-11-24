/**
 * FoodMart Admin Panel - Client-side Interactive Engine
 * Provides instant table search, status filtering, keyboard shortcuts, and UI interactions.
 */

document.addEventListener('DOMContentLoaded', function () {
    initSearchAndFilter();
    initSidebarToggle();
    initShortcuts();
});

/**
 * Real-time instant search across table rows
 */
function initSearchAndFilter() {
    if (window.FoodMartTableSearchSource === 'inline') {
        return;
    }

    const tableInputs = document.querySelectorAll('.table-search-box input[id="tableSearchInput"]');

    tableInputs.forEach(tableInput => {
        const card = tableInput.closest('.table-card');
        if (!card) return;

        const clearBtn = card.querySelector('#tableSearchClear');

        const runFilter = function () {
            const query = tableInput.value;
            updateClearButton(clearBtn, query);
            applyTableFilter(card, query);
        };

        tableInput.addEventListener('input', runFilter);
        tableInput.addEventListener('keyup', runFilter);
        tableInput.addEventListener('change', runFilter);

        tableInput.addEventListener('keydown', function (e) {
            if (e.key === 'Escape') {
                tableInput.value = '';
                runFilter();
            }
        });

        if (tableInput.value && tableInput.value.trim() !== '') {
            runFilter();
        }

        if (clearBtn) {
            clearBtn.addEventListener('click', function () {
                tableInput.value = '';
                runFilter();
                tableInput.focus();
            });
        }

        chips.forEach(chip => {
            chip.addEventListener('click', function () {
                chips.forEach(c => c.classList.remove('active'));
                this.classList.add('active');
                applyTableFilter(card, tableInput.value);
            });
        });
    });
}

function updateClearButton(clearBtn, query) {
    const hasText = query && query.trim().length > 0;

    if (clearBtn) clearBtn.style.display = hasText ? 'flex' : 'none';
}

function clearAllSearch() {
    document.querySelectorAll('.table-card').forEach(card => {
        const tableInput = card.querySelector('#tableSearchInput');
        const clearBtn = card.querySelector('#tableSearchClear');
        if (tableInput) tableInput.value = '';
        updateClearButton(clearBtn, '');
        applyTableFilter(card, '');
    });
}

/**
 * Core table filtering logic: matches search keyword AND active chip filter
 */
function applyTableFilter(card, keyword) {
    const table = card.querySelector('.data-table, .table-card table');
    if (!table) return;

    const tbody = table.querySelector('tbody');
    if (!tbody) return;

    const rows = Array.from(tbody.querySelectorAll('tr:not(.empty-state-row)'));
    const term = (keyword || '').toLowerCase().trim();

    // Get active filter chip (e.g. "All", "Available", "Paid", etc.)
    let visibleCount = 0;

    rows.forEach(row => {
        const rowText = (row.textContent || row.innerText || '').toLowerCase();
        const rowId = (row.getAttribute('data-search-id') || '').toLowerCase();
        const rowStatus = (row.getAttribute('data-status') || '').toLowerCase();

        // 1. Check keyword match against the row ID first, then fall back to row text.
        const matchesKeyword = !term || rowId.includes(term) || rowText.includes(term);

        if (matchesKeyword) {
            row.style.display = '';
            visibleCount++;
        } else {
            row.style.display = 'none';
        }
    });

    // Update count labels
    updateCountBadge(card, visibleCount, rows.length);

    // Show/hide empty state
    toggleEmptyState(tbody, visibleCount, rows.length, term);
}

function updateCountBadge(card, visible, total) {
    const countEl = card.querySelector('#filterCount');
    const totalEl = card.querySelector('#totalCountBadge');
    const topBadge = card.querySelector('#searchResultBadge');

    if (countEl) countEl.textContent = visible;
    if (totalEl) totalEl.textContent = total;

    if (topBadge) {
        if (visible === total) {
            topBadge.textContent = total + ' items';
        } else {
            topBadge.textContent = visible + ' of ' + total + ' items';
        }
    }
}

function toggleEmptyState(tbody, visibleCount, totalRows, query) {
    let emptyRow = tbody.querySelector('.empty-state-row');

    if (visibleCount === 0 && totalRows > 0) {
        if (!emptyRow) {
            emptyRow = document.createElement('tr');
            emptyRow.className = 'empty-state-row';
            const colSpan = tbody.closest('table').querySelectorAll('thead th').length || 8;
            emptyRow.innerHTML = `
                <td colspan="${colSpan}">
                    <div class="empty-search-box">
                        <div class="empty-icon-wrap">
                            <span class="material-icons">search_off</span>
                        </div>
                        <h3>No matching results found</h3>
                        <p>No records match your search <strong class="empty-term">"${escapeHtml(query)}"</strong></p>
                        <button type="button" class="btn-secondary btn-sm" onclick="clearAllSearch()">
                            <span class="material-icons" style="font-size:16px;">refresh</span> Reset Filters
                        </button>
                    </div>
                </td>
            `;
            tbody.appendChild(emptyRow);
        } else {
            emptyRow.style.display = '';
            const termEl = emptyRow.querySelector('.empty-term');
            if (termEl) termEl.textContent = `"${query}"`;
        }
    } else if (emptyRow) {
        emptyRow.style.display = 'none';
    }
}

function escapeHtml(text) {
    const div = document.createElement('div');
    div.textContent = text;
    return div.innerHTML;
}

/**
 * Filter Chips (All, Available, Unavailable / Paid, Processing, Delivered, Cancelled)
 */
/**
 * Sidebar Toggle (for desktop collapse and mobile drawer)
 */
function initSidebarToggle() {
    const toggles = document.querySelectorAll('.sidebar-toggle, .sidebar-mobile-toggle');
    const overlay = document.querySelector('.sidebar-overlay');

    toggles.forEach(toggle => {
        toggle.addEventListener('click', function () {
            if (window.innerWidth <= 868) {
                document.body.classList.toggle('sidebar-mobile-open');
            } else {
                document.body.classList.toggle('sidebar-collapsed');
            }
        });
    });

    if (overlay) {
        overlay.addEventListener('click', function () {
            document.body.classList.remove('sidebar-mobile-open');
        });
    }
}

/**
 * Keyboard shortcuts:
 * - "/" or "Ctrl+K" or "Cmd+K": focus search input
 * - "Esc": clear search
 */
function initShortcuts() {
    document.addEventListener('keydown', function (e) {
        // Ignore if user is already typing in an input or textarea
        const activeTag = document.activeElement ? document.activeElement.tagName.toLowerCase() : '';
        const isEditing = activeTag === 'input' || activeTag === 'textarea' || activeTag === 'select';

        if ((e.key === '/' && !isEditing) || ((e.ctrlKey || e.metaKey) && e.key.toLowerCase() === 'k')) {
            e.preventDefault();
            const searchInput = document.querySelector('.table-card #tableSearchInput');
            if (searchInput) {
                searchInput.focus();
                searchInput.select();
            }
        }
    });
}

