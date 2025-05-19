<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Stack Management</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="/css/style.css">
</head>
<body class="bg-light min-h-screen d-flex align-items-center justify-content-center">
    <div class="container">
        <div class="card shadow-sm mx-auto" style="max-width: 500px;">
            <div class="card-body">
                <div class="text-center mb-4">
                    <img src="/images/logo.png" alt="Logo" class="img-fluid" style="max-height: 60px;">
                    <h1 class="h3 mt-2">Stack Management</h1>
                </div>
                <ul class="nav nav-tabs mb-4" id="authTabs" role="tablist">
                    <li class="nav-item">
                        <a class="nav-link active" id="login-tab" data-bs-toggle="tab" href="#login" role="tab">Login</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" id="signup-tab" data-bs-toggle="tab" href="#signup" role="tab">Sign Up</a>
                    </li>
                </ul>
                <div class="tab-content">
                    <div class="tab-pane fade show active" id="login" role="tabpanel">
                        <form:form modelAttribute="newLogin" action="/login" method="post">
                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                            <div class="mb-3">
                                <form:label path="email" class="form-label">Email Address</form:label>
                                <form:input path="email" class="form-control" placeholder="Email"/>
                                <form:errors path="email" cssClass="text-danger small"/>
                            </div>
                            <div class="mb-3">
                                <form:label path="password" class="form-label">Password</form:label>
                                <form:input type="password" path="password" class="form-control" placeholder="Password"/>
                                <form:errors path="password" cssClass="text-danger small"/>
                            </div>
                            <button type="submit" class="btn btn-primary w-100">Get Started</button>
                        </form:form>
                    </div>
                    <div class="tab-pane fade" id="signup" role="tabpanel">
                        <c:if test="${not empty error}">
                            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                ${error}
                                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                            </div>
                        </c:if>
                        <form:form modelAttribute="newUser" action="/register" method="post">
                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                            <div class="mb-3">
                                <form:label path="firstName" class="form-label">First Name</form:label>
                                <form:input path="firstName" class="form-control" placeholder="First Name"/>
                                <form:errors path="firstName" cssClass="text-danger small"/>
                            </div>
                            <div class="mb-3">
                                <form:label path="lastName" class="form-label">Last Name</form:label>
                                <form:input path="lastName" class="form-control" placeholder="Last Name"/>
                                <form:errors path="lastName" cssClass="text-danger small"/>
                            </div>
                            <div class="mb-3">
                                <form:label path="email" class="form-label">Email Address</form:label>
                                <form:input path="email" class="form-control" placeholder="Email"/>
                                <form:errors path="email" cssClass="text-danger small"/>
                            </div>
                            <div class="mb-3">
                                <form:label path="password" class="form-label">Password</form:label>
                                <form:input type="password" path="password" class="form-control" placeholder="Password"/>
                                <form:errors path="password" cssClass="text-danger small"/>
                            </div>
                            <div class="mb-3">
                                <form:label path="confirm" class="form-label">Confirm Password</form:label>
                                <form:input type="password" path="confirm" class="form-control" placeholder="Confirm Password"/>
                                <form:errors path="confirm" cssClass="text-danger small"/>
                            </div>
                            <button type="submit" class="btn btn-primary w-100">Create Account</button>
                        </form:form>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="/js/script.js"></script>