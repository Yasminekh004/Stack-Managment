<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/components/nvbar.jsp"%>
<%@ page isErrorPage="true"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<title>Stack Management Dashboard</title>
<link rel="stylesheet" href="/styles.css">
</head>
<body>
	<jsp:include page="components/nvbar.jsp" />
	<h1>Welcome ${user.name}</h1>
	<c:if test="${not empty alert}">
		<div class="alert">${alert}</div>
	</c:if>
	<div class="budget">Total budget: $${budget}</div>
	<div class="search-bar">
		<form method="get" action="/">
			<input type="text" name="search" placeholder="search"
				value="${param.search}" /> <select name="category">
				<option value="">All Categories</option>
				<c:forEach items="${categories}" var="cat">
					<option value="${cat}" ${param.category == cat ? 'selected' : ''}>${cat}</option>
				</c:forEach>
			</select>
			<button type="submit">Search</button>
		</form>
	</div>
	<table>
		<thead>
			<tr>
				<th>Items</th>
				<th>Category</th>
				<th>Stock</th>
				<th>Action</th>
			</tr>
		</thead>
		<tbody>
			<c:forEach items="${items}" var="item">
				<tr>
					<td>${item.name}</td>
					<td>${item.category}</td>
					<td>${item.stock}</td>
					<td><a href="/edit/${item.id}">Edit</a> - <a
						href="/delete/${item.id}"
						onclick="return confirm('Are you sure?')">Delete</a></td>
				</tr>
			</c:forEach>
		</tbody>
	</table>
	<div class="add-item">
		<button
			onclick="document.getElementById('addForm').style.display='block'">+</button>
		<div id="addForm" style="display: none;">
			<form:form modelAttribute="newItem" method="post" action="/addItem">
				<p>
					<form:label path="name">Name:</form:label>
					<form:input path="name" />
				</p>
				<p>
					<form:label path="category">Category:</form:label>
					<form:select path="category">
						<c:forEach items="${categories}" var="cat">
							<option value="${cat}">${cat}</option>
						</c:forEach>
					</form:select>
				</p>
				<p>
					<form:label path="stock">Stock:</form:label>
					<form:input path="stock" type="number" />
				</p>
				<button type="submit">Submit</button>
			</form:form>
		</div>
	</div>
	<div class="history">
		<h2>History</h2>
		<c:forEach items="${history}" var="entry">
			<p>${entry}</p>
		</c:forEach>
	</div>
	<jsp:include page="components/footer.jsp" />
</body>
</html>