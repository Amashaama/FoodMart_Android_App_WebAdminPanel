<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FoodMart Admin - Secure Login</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=20261003">
</head>
<body class="login-body">
<div class="login-wrapper">
    <div class="login-card-modern">
        <div class="login-header">
            <div class="login-brand-icon">
                <span class="material-icons">storefront</span>
            </div>
            <h1 class="login-title">FoodMart Admin</h1>
            <p class="login-subtitle">Sign in to access your store operations, orders, and user database.</p>
        </div>

        <c:if test="${not empty error}">
            <div class="alert-banner alert-danger mb-16">
                <span class="material-icons alert-icon">error_outline</span>
                <span class="alert-text">${error}</span>
            </div>
        </c:if>

        <form method="post" action="${pageContext.request.contextPath}/login" class="login-form">
            <div class="form-field">
                <label class="form-label" for="loginEmail">Email Address</label>
                <div class="input-with-icon">
                    <span class="material-icons input-icon">email</span>
                    <input type="email" id="loginEmail" name="email" placeholder="admin@foodmart.com" required autofocus />
                </div>
            </div>

            <div class="form-field">
                <label class="form-label" for="loginPassword">Password</label>
                <div class="input-with-icon">
                    <span class="material-icons input-icon">lock</span>
                    <input type="password" id="loginPassword" name="password" placeholder="••••••••" required />
                </div>
            </div>

            <button type="submit" class="btn-login-submit">
                <span>Sign In to Dashboard</span>
                <span class="material-icons">arrow_forward</span>
            </button>
        </form>

        <div class="login-footer-info">
            <div class="login-badge-secure">
                <span class="material-icons" style="font-size:14px; color:#10b981;">verified_user</span>
                <span>Protected by Firestore Session Auth</span>
            </div>
        </div>
    </div>
</div>
</body>
</html>
