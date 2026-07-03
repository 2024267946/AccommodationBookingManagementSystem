<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Login - DG Rimbun</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="auth-body">
    <div class="auth-container">
        <div class="auth-card">
            <div class="auth-header">
                <h2>Welcome Back</h2>
                <p>Login to manage your bookings</p>
            </div>
            
            <% if(request.getAttribute("error") != null){ %>
    		<div class="error-message">
        		<%= request.getAttribute("error") %>
   		 	</div>
			<% } %>
            
            <!-- Login Form -->
            <form action="${pageContext.request.contextPath}/auth/login" method="POST">
                <div class="form-group">
                    <label>Email Address</label>
                    <input type="email" name="email" class="form-control" placeholder="Enter your email" required>
                </div>
                <div class="form-group">
                    <label>Password</label>
                    <input type="password" name="password" class="form-control" placeholder="Enter your password" required>
                </div>
                <button type="submit" class="btn-primary btn-block">Login</button>
            </form>
            
            <div class="auth-footer">
                <p>Don't have an account? <a href="register.jsp">Sign up here</a></p>
            </div>
        </div>
    </div>
</body>
</html>