<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.net.URLEncoder,java.nio.charset.StandardCharsets" %>
<%
String registerReturnTo=request.getParameter("returnTo");
String encodedRegisterReturn=registerReturnTo==null?null:URLEncoder.encode(registerReturnTo,StandardCharsets.UTF_8);
String registerSuffix=encodedRegisterReturn==null?"":"?returnTo="+encodedRegisterReturn;
%>
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
           <form id="registerForm" action="${pageContext.request.contextPath}/auth/register<%= registerSuffix %>" method="POST">

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
        <input id="registerPassword" type="password" name="password" class="form-control" minlength="6" placeholder="Enter your password" required>
    </div>
    <div class="form-group">
        <label>Confirm Password</label>
        <input id="registerConfirmPassword" type="password" name="confirmPassword" class="form-control" minlength="6" placeholder="Re-enter your password" required>
        <small id="registerPasswordMismatch" style="display:none;color:#a61b1b;margin-top:5px;">Passwords do not match.</small>
    </div>

    <button type="submit" class="btn-primary btn-block">
        Create Account
    </button>

</form>
            
            <div class="auth-footer">
                <p>Already have an account? <a href="login.jsp<%= registerSuffix %>">Login here</a></p>
            </div>
        </div>
    </div>
    <script>
    const registerPassword=document.getElementById('registerPassword'),registerConfirmation=document.getElementById('registerConfirmPassword');
    function validateRegistrationPassword(){const mismatch=registerConfirmation.value!==''&&registerPassword.value!==registerConfirmation.value;registerConfirmation.setCustomValidity(mismatch?'Passwords do not match.':'');document.getElementById('registerPasswordMismatch').style.display=mismatch?'block':'none';}
    registerPassword.addEventListener('input',validateRegistrationPassword);registerConfirmation.addEventListener('input',validateRegistrationPassword);
    <% if ("emailExists".equals(request.getParameter("error"))) { %>showAppNotification("Email Already Exists","An account is already registered with this email address.","error");
    <% } else if ("mismatch".equals(request.getParameter("error"))) { %>showAppNotification("Passwords Do Not Match","Enter the same password in both password fields.","error");
    <% } else if ("short".equals(request.getParameter("error"))) { %>showAppNotification("Password Too Short","Password must contain at least 6 characters.","error");
    <% } else if ("missing".equals(request.getParameter("error"))) { %>showAppNotification("Missing Information","Please complete every registration field.","error");
    <% } else if ("failed".equals(request.getParameter("error"))) { %>showAppNotification("Registration Failed","The account could not be created. Please try again.","error");<% } %>
    <% if ("success".equals(request.getParameter("register"))) { %>
    showAppNotification("Account Created Successfully","Your guest account is ready. Redirecting you to login.","success",3000);
    window.setTimeout(function(){window.location.href='${pageContext.request.contextPath}/login.jsp<%= registerSuffix %>';},1500);
    <% } %>
    </script>
</body>
</html>
