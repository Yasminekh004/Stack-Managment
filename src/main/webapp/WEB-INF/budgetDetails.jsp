<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Budget Details - Stack Management</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="/css/style.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body class="bg-light min-h-screen">
    <jsp:include page="components/nvbar.jsp" />
    <div class="container mt-5">
        <h1 class="text-center mb-4">Budget Details</h1>
        <div class="card shadow-sm mb-4">
            <div class="card-body">
                <h5 class="mb-2">Total Budget: <fmt:formatNumber value="${userBudget}" type="currency"/></h5>
                <h5 class="mb-2">Total Spent: <fmt:formatNumber value="${totalSpent}" type="currency"/></h5>
                <h5>Remaining Budget: <fmt:formatNumber value="${userBudget - totalSpent}" type="currency"/></h5>
            </div>
        </div>
        <div class="card shadow-sm mb-4">
            <div class="card-body">
                <h3 class="card-title mb-3">Budget by Category</h3>
                <canvas id="budgetPieChart" height="100"
                    data-categories='[<c:forEach items="${budgetPerCategory}" var="entry" varStatus="loop">"${entry.key}"<c:if test="${!loop.last}">,</c:if></c:forEach>]'
                    data-amounts='[<c:forEach items="${budgetPerCategory}" var="entry" varStatus="loop">${entry.value}<c:if test="${!loop.last}">,</c:if></c:forEach>]'
                    data-total-spent="${totalSpent}"></canvas>
            </div>
        </div>
        <div class="card shadow-sm mb-4">
            <div class="card-body">
                <h3 class="card-title mb-3">Expenses by Category</h3>
                <canvas id="expensesBarChart" height="100"></canvas>
            </div>
        </div>
        <div class="card shadow-sm mb-4">
            <div class="card-body">
                <h3 class="card-title mb-3">Category Breakdown</h3>
                <table class="table table-hover">
                    <thead>
                        <tr>
                            <th>Category</th>
                            <th>Amount Spent</th>
                            <th>Percentage</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${budgetPerCategory}" var="entry">
                            <tr>
                                <td>${entry.key}</td>
                                <td><fmt:formatNumber value="${entry.value}" type="currency"/></td>
                                <td><fmt:formatNumber value="${(entry.value / totalSpent) * 100}" type="number" maxFractionDigits="2"/>%</td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    <jsp:include page="components/footer.jsp" />
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="/js/script.js"></script>