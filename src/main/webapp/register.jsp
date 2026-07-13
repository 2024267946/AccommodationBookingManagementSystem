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
<style>
.result-modal{position:fixed;z-index:3000;inset:0;display:flex;align-items:center;justify-content:center;padding:24px;background:rgba(8,28,22,.62)}.result-modal-card{width:min(430px,100%);padding:34px;background:#fff;border-radius:18px;text-align:center;box-shadow:0 24px 70px rgba(0,0,0,.22)}.result-modal-icon{width:62px;height:62px;margin:0 auto 18px;border-radius:50%;display:flex;align-items:center;justify-content:center;background:#eaf7ef;color:#17633a;font-size:28px;font-weight:bold}.result-modal.error .result-modal-icon{background:#fff0f0;color:#a61b1b}.result-modal h2{margin:0 0 10px;color:#123a30}.result-modal p{margin:0 0 24px;color:#746f69}.result-modal .btn-primary{display:inline-flex;text-decoration:none;padding:12px 28px}
</style>
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
    <% if ("emailExists".equals(request.getParameter("error"))) { %>
    <div class="result-modal error"><div class="result-modal-card"><div class="result-modal-icon">!</div><h2>Email Already Exists</h2><p>An account is already registered with this email address.</p><a class="btn-primary" href="${pageContext.request.contextPath}/register.jsp<%= registerSuffix %>">Try Another Email</a></div></div>
    <% } else if ("success".equals(request.getParameter("register"))) { %>
    <div class="result-modal"><div class="result-modal-card"><div class="result-modal-icon">✓</div><h2>Account Created Successfully</h2><p>Your guest account is ready. Log in to continue.</p><a class="btn-primary" href="${pageContext.request.contextPath}/login.jsp<%= registerSuffix %>">Continue to Login</a></div></div>
    <% } %>
    <script>
    const registerPassword=document.getElementById('registerPassword'),registerConfirmation=document.getElementById('registerConfirmPassword');
    function validateRegistrationPassword(){const mismatch=registerConfirmation.value!==''&&registerPassword.value!==registerConfirmation.value;registerConfirmation.setCustomValidity(mismatch?'Passwords do not match.':'');document.getElementById('registerPasswordMismatch').style.display=mismatch?'block':'none';}
    registerPassword.addEventListener('input',validateRegistrationPassword);registerConfirmation.addEventListener('input',validateRegistrationPassword);
    <% if ("success".equals(request.getParameter("register"))) { %>
    window.setTimeout(function(){window.location.href='${pageContext.request.contextPath}/login.jsp<%= registerSuffix %>';},3000);
    <% } %>
    </script>
</body>
</html>
