<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>404 - Page Not Found | FoodMart Admin</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=20261003">
</head>
<body class="login-body">
<div class="login-wrapper">
    <div class="login-card-modern text-center">
        <div class="empty-icon-wrap mb-16">
            <span class="material-icons" style="font-size: 48px; color: #f59e0b;">wrong_location</span>
        </div>
        <h1 class="login-title">Page Not Found</h1>
        <p class="login-subtitle">
            The page you are looking for does not exist or has been moved.
        </p>
        <div class="mt-24">
            <a href="${pageContext.request.contextPath}/dashboard" class="btn-primary">
                <span class="material-icons">arrow_back</span>
                <span>Return to Dashboard</span>
            </a>
        </div>
    </div>
</div>
</body>
</html>
