<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ page isErrorPage="true" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"  %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Stock Management Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="/css/styles.css">
</head>
<body>
    <div class="navbar">
    <a href="/">Stack Management</a>
    <a href="/items">Home</a>
    <a href="/dashboard">Dashboard</a>
    <div class="navbar-right">
        <button onclick="window.history.back()">Back</button>
        <button onclick="location.href='/logout'">Logout</button>
    </div>
</div>

</body>
</html>