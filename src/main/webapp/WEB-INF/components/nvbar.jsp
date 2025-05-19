<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ page isErrorPage="true" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"  %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core" %>

    <div class="navbar">
    <a href="/">Stack Management</a>
    <a href="/items">Home</a>
    <a href="/dashboard">Dashboard</a>
    <div class="navbar-right">
        <button onclick="window.history.back()">Back</button>
        <button onclick="location.href='/logout'">Logout</button>
    </div>
</div>