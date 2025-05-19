<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page isErrorPage="true"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Item Details - Stock Management</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="/css/styles.css">
</head>
<body class="bg-light min-h-screen">
    <jsp:include page="components/nvbar.jsp" />
    <div class="container mt-5">
        <h1 class="text-center mb-4">Item Details</h1>
        <div class="card shadow-sm mb-4">
            <div class="card-body">
                <h3 class="card-title">${item.name}</h3>
                <p><strong>Category:</strong> ${item.category}</p>
                <p><strong>Stock:</strong> ${item.stock}</p>
                <p><strong>Price:</strong> <fmt:formatNumber value="${item.price}" type="currency"/></p>
                <p><strong>Purchase Date:</strong> <fmt:formatDate value="${item.purchaseDate}" pattern="yyyy-MM-dd"/></p>
                <p><strong>Expiry Date:</strong> <fmt:formatDate value="${item.expiryDate}" pattern="yyyy-MM-dd"/></p>
            </div>
        </div>
        <div class="card shadow-sm mb-4">
            <div class="card-body">
                <h3 class="card-title">Edit Your Item</h3>
                <form:form modelAttribute="item" action="/item/${item.id}/edit" method="post">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                    <input type="hidden" name="_method" value="put">
                    <div class="mb-3">
                        <form:label path="name" class="form-label">Name:</form:label>
                        <form:input path="name" class="form-control" />
                        <form:errors path="name" cssClass="text-danger small"/>
                    </div>
                    <div class="mb-3">
                        <form:label path="category" class="form-label">Category:</form:label>
                        <select id="categorySelect" class="form-select" onchange="toggleCustomCategory(this.value)">
						        <option value="">Select a category</option>
						        <c:forEach var="cat" items="${categories}">
						            <option value="${cat}" ${cat == item.category ? 'selected' : ''}>${cat}</option>
						        </c:forEach>
						        <option value="Other" ${!categories.contains(item.category) ? 'selected' : ''}>Other</option>
						    </select>
						
						    <!-- Custom category input -->
						    <input type="text" id="customCategory" class="form-control mt-2"
						           style="display: none;" placeholder="Enter new category"
						           value="${!categories.contains(item.category) ? item.category : ''}" />
						
						    <!-- Real form binding -->
						    <form:input path="category" id="finalCategory" type="hidden"/>
						
						    <form:errors path="category" cssClass="text-danger small"/>
                        <form:errors path="category" cssClass="text-danger small"/>
                    </div>
                    <div class="mb-3">
                        <form:label path="stock" class="form-label">Stock:</form:label>
                        <form:input path="stock" type="number" class="form-control" />
                        <form:errors path="stock" cssClass="text-danger small"/>
                    </div>
                    <div class="mb-3">
                        <form:label path="price" class="form-label">Price:</form:label>
                        <form:input path="price" type="number" step="0.01" class="form-control" />
                        <form:errors path="price" cssClass="text-danger small"/>
                    </div>
                    <div class="mb-3">
                        <form:label path="purchaseDate" class="form-label">Purchase Date:</form:label>
                        <form:input path="purchaseDate" type="date" class="form-control" />
                        <form:errors path="purchaseDate" cssClass="text-danger small"/>
                    </div>
                    <div class="mb-3">
                        <form:label path="expiryDate" class="form-label">Expiry Date:</form:label>
                        <form:input path="expiryDate" type="date" class="form-control" />
                        <form:errors path="expiryDate" cssClass="text-danger small"/>
                    </div>
                    <div class="d-flex gap-2">
                        <button type="submit" class="btn btn-success">Submit</button>
                        <form action="/item/${item.id}" method="post" class="d-inline">
                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                            <input type="hidden" name="_method" value="delete">
                            <button type="submit" class="btn btn-danger" onclick="return confirm('Are you sure you want to delete ${item.name}?')">Delete</button>
                        </form>
                    </div>
                </form:form>
            </div>
        </div>
    </div>
    <jsp:include page="components/footer.jsp" />
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="/js/script.js"></script>