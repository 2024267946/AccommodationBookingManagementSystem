<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Register</title>
    <jsp:include page="header.jsp" />
    
</head>
<body class="auth-body">
<jsp:include page="navbar.jsp" />
    <div class="auth-container">
        <div class="auth-card">
            <div class="auth-header">
                <h2>Create an Account</h2>
                <p>Sign up to book your stay</p>
            </div>
            
            <!-- Registration Form -->
           <form action="${pageContext.request.contextPath}/auth/register" method="POST">

    <!-- Error Message -->
    <% if(request.getAttribute("error") != null){ %>
        <div class="error-message">
            <%= request.getAttribute("error") %>
        </div>
    <% } %>

    <div class="form-group">
        <label>Full Name</label>
        <input type="text" name="name" class="form-control" placeholder="Enter your full name" required>
    </div>
    <div class="form-group">
        <label>Phone Number</label>
        <input type="tel" name="phone" class="form-control" placeholder="Enter your phone number" required>
    </div>
    <div class="form-group">
        <label>Email Address</label>
        <input type="email" name="email" class="form-control" placeholder="Enter your email" required>
    </div>
    <div class="form-group">
        <label>Password</label>
        <input type="password" name="password" class="form-control" minlength="6" placeholder="Enter your password" required>
    </div>
    <div class="form-group">
        <label>Confirm Password</label>
        <input type="password" name="confirmPassword" class="form-control" minlength="6" placeholder="Re-enter your password" required>
    </div>

    <button type="submit" class="btn-primary btn-block">
        Register
    </button>

</form>
            
            <div class="auth-footer">
                <p>Already have an account? <a href="login.jsp">Login here</a></p>
            </div>
        </div>
    </div>
</body>
</html>