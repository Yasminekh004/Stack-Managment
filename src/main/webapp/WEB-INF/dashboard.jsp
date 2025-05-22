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
    <title>Stock Management Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="/css/styles.css">
</head>
<!-- ✅ Chatbot Styles -->
<style>
    #chatbot-toggle {
        position: fixed;
        bottom: 20px;
        right: 20px;
        background: #0d6efd;
        color: white;
        border-radius: 50%;
        width: 60px;
        height: 60px;
        font-size: 30px;
        border: none;
        z-index: 1000;
    }

    #chatbot-window {
        position: fixed;
        bottom: 90px;
        right: 20px;
        width: 300px;
        height: 400px;
        background: white;
        border: 1px solid #ccc;
        display: none;
        flex-direction: column;
        box-shadow: 0 0 10px rgba(0,0,0,0.2);
        z-index: 1000;
    }

    #chatbot-messages {
        flex: 1;
        padding: 10px;
        overflow-y: auto;
        font-size: 14px;
    }

    #chatbot-input {
        display: flex;
        border-top: 1px solid #ccc;
    }

    #chatbot-input input {
        flex: 1;
        padding: 10px;
        border: none;
        outline: none;
    }

    #chatbot-input button {
        padding: 10px;
        border: none;
        background: #0d6efd;
        color: white;
    }
</style>

<!-- ✅ Chatbot HTML -->
<button id="chatbot-toggle" title="Chatbot">💬</button>

<div id="chatbot-window">
    <div id="chatbot-messages"></div>
    <div id="chatbot-input">
        <input type="text" id="user-input" placeholder="Ask something..." 
            onkeydown="if(event.key === 'Enter') { event.preventDefault(); sendMessage(); }">
        <button type="button" onclick="sendMessage()">Send</button>
    </div>
</div>

<!-- ✅ Chatbot Script -->
<script>
    const chatbotToggle = document.getElementById('chatbot-toggle');
    const chatbotWindow = document.getElementById('chatbot-window');
    const chatbotMessages = document.getElementById('chatbot-messages');

    chatbotToggle.addEventListener('click', () => {
        chatbotWindow.style.display = chatbotWindow.style.display === 'none' ? 'flex' : 'none';
    });

    function sendMessage() {
        const input = document.getElementById('user-input');
        const message = input.value.trim();
        if (message === '') return;

        chatbotMessages.innerHTML += `<div><strong>You:</strong> ${message}</div>`;

        fetch('/chat', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ message: message })
        })
        .then(response => response.text())
        .then(reply => {
            chatbotMessages.innerHTML += `<div><strong>Bot:</strong> ${reply}</div>`;
            chatbotMessages.scrollTop = chatbotMessages.scrollHeight;
        })
        .catch(err => {
            chatbotMessages.innerHTML += `<div class="text-danger"><strong>Bot:</strong> Error responding.</div>`;
        });

        input.value = '';
    }
</script>
<body class="bg-light min-h-screen">
    <jsp:include page="components/nvbar.jsp" />
    <div class="container mt-5">
        <h1 class="text-center mb-4">Welcome, ${user.firstName} ${user.lastName}</h1>
        <c:if test="${not empty alert}">
            <div class="alert alert-info alert-dismissible fade show" role="alert">
                ${alert}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>
        <div class="card shadow-sm mb-4">
            <div class="card-body">
                <h5>Total Budget: <fmt:formatNumber value="${user.budget}" type="currency"/></h5>
                <form action="/update-budget" method="post" class="d-flex gap-2">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                    <input type="number" step="0.01" name="budget" class="form-control w-25" placeholder="Update Budget" value="${user.budget}"/>
                    <button type="submit" class="btn btn-primary">Update</button>
                </form>
            </div>
        </div>
        <div class="card shadow-sm mb-4">
            <div class="card-body">
                <form method="get" action="/items" class="d-flex gap-2">
                    <input type="text" name="keyword" class="form-control" placeholder="Search items..." value="${keyword}"/>
                    <select name="category" class="form-select">
                        <option value="">All Categories</option>
                        <c:forEach items="${categories}" var="cat">
                            <option value="${cat}" ${selectedCategory == cat ? 'selected' : ''}>${cat}</option>
                        </c:forEach>
                    </select>
                    <button type="submit" class="btn btn-primary">Search</button>
                </form>
            </div>
        </div>
        <div class="card shadow-sm mb-4">
            <div class="card-body">
                <table class="table table-hover">
                    <thead>
                        <tr>
                            <th>Items</th>
                            <th>Category</th>
                            <th>Stock</th>
                            <th>Price</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${items}" var="item">
                            <tr>
                                <td><a href="/items/${item.id}">${item.name}</a></td>
                                <td>${item.category}</td>
                                <td>${item.stock}</td>
                                <td><fmt:formatNumber value="${item.price}" type="currency"/></td>
                                <td>
                                    <a href="/items/${item.id}" class="btn btn-sm btn-outline-primary">View</a>
                                    <form action="/item/${item.id}" method="post" class="d-inline">
                                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                        <input type="hidden" name="_method" value="delete">
                                        <button type="submit" class="btn btn-sm btn-outline-danger" onclick="return confirm('Are you sure you want to delete ${item.name}?')">Delete</button>
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
                <nav>
                    <ul class="pagination">
                        <c:if test="${currentPage > 0}">
                            <li class="page-item">
                                <a class="page-link" href="/items?page=${currentPage - 1}&size=${size}&keyword=${keyword}&category=${selectedCategory}">Previous</a>
                            </li>
                        </c:if>
                        <c:if test="${totalPages > 0}">
	                        <c:forEach begin="0" end="${totalPages - 1}" var="i">
	                            <li class="page-item ${i == currentPage ? 'active' : ''}">
	                                <a class="page-link" href="/items?page=${i}&size=${size}&keyword=${keyword}&category=${selectedCategory}">${i + 1}</a>
	                            </li>
	                        </c:forEach>
                        </c:if>
                        <c:if test="${currentPage < totalPages - 1}">
                            <li class="page-item">
                                <a class="page-link" href="/items?page=${currentPage + 1}&size=${size}&keyword=${keyword}&category=${selectedCategory}">Next</a>
                            </li>
                        </c:if>
                    </ul>
                </nav>
            </div>
        </div>
        <div class="card shadow-sm mb-4">
            <div class="card-body">
                <button class="btn btn-success mb-3" onclick="toggleAddForm()">+ Add Item</button>
                <div id="addForm" style="display: none;">
                    <form:form modelAttribute="item" method="post" action="/item/new">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                        <div class="mb-3">
                            <form:label path="name" class="form-label">Name:</form:label>
                            <form:input path="name" class="form-control" />
                            <form:errors path="name" cssClass="text-danger small"/>
                        </div>
                        <div class="mb-3">
						    <form:label path="category" class="form-label">Category:</form:label>
						    
						    <!-- Dropdown select -->
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
                            <button type="submit" class="btn btn-primary">Submit</button>
                            <button type="button" class="btn btn-secondary" onclick="toggleAddForm()">Cancel</button>
                        </div>
                    </form:form>
                </div>
            </div>
        </div>
        <div class="card shadow-sm">
            <div class="card-body">
                <h3>History</h3>
                <c:forEach items="${logs}" var="log">
                    <p>${log}</p>
                </c:forEach>
            </div>
        </div>
    </div>
    <jsp:include page="components/footer.jsp" />
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="/js/script.js"></script>
