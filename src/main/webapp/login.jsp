<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.net.URLEncoder,java.nio.charset.StandardCharsets" %>
<%
String loginReturnTo=request.getParameter("returnTo");
String encodedLoginReturn=loginReturnTo==null?null:URLEncoder.encode(loginReturnTo,StandardCharsets.UTF_8);
String loginSuffix=encodedLoginReturn==null?"":"?returnTo="+encodedLoginReturn;
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Login - Cuti Murah Melaka</title>
    <jsp:include page="header.jsp" />
   
</head>
<body class="auth-body">
<style>.login-modal{position:fixed;z-index:3000;inset:0;display:flex;align-items:center;justify-content:center;padding:24px;background:rgba(8,28,22,.62)}.login-modal-card{width:min(420px,100%);padding:34px;border-radius:18px;background:#fff;text-align:center;box-shadow:0 24px 70px rgba(0,0,0,.22)}.login-modal-icon{display:flex;align-items:center;justify-content:center;width:62px;height:62px;margin:0 auto 18px;border-radius:50%;background:#fff0f0;color:#a61b1b;font-size:28px;font-weight:bold}.login-modal h2{margin:0 0 9px;color:#123a30}.login-modal p{margin:0 0 22px;color:#746f69}.login-modal .btn-primary{display:inline-flex;text-decoration:none;padding:12px 28px}</style>
  
        <jsp:include page="navbar.jsp" />
        
    <div class="auth-container">
        <div class="auth-card">
            <div class="auth-header">
                <h2>Welcome Back</h2>
                <p>Login to manage your bookings</p>
            </div>
            <% if ("required".equals(request.getParameter("bookingLogin"))) { %><div class="message message-success">Log in or create an account to continue your booking.</div><% } %>
            
            <% if(request.getAttribute("error") != null){ %>
    		<div class="error-message">
        		<%= request.getAttribute("error") %>
   		 	</div>
			<% } %>
            
            <!-- Login Form -->

            <form action="${pageContext.request.contextPath}/auth/login<%= loginSuffix %>" method="POST">

                <div class="form-group">
                    <label>Email Address</label>
                    <input type="email" name="email" class="form-control" placeholder="Enter your email" required>
                </div>
                
                <div class="form-group">
                    <label>Password</label>
                    <input type="password" name="password" class="form-control" placeholder="Enter your password" required>
                </div>
                
                <button type="submit" class="btn-primary btn-block">
                Login
                </button>
   
            </form>
            
            <div class="auth-footer">
                <p>Don't have an account? <a href="register.jsp<%= loginSuffix %>">Sign up here</a></p>
            </div>
        </div>
    </div>
    <% if ("incorrect".equals(request.getParameter("error"))) { %>
    <div class="login-modal"><div class="login-modal-card"><div class="login-modal-icon">!</div><h2>Login Failed</h2><p>Incorrect email or password. Please check your credentials and try again.</p><a class="btn-primary" href="${pageContext.request.contextPath}/login.jsp<%= loginSuffix %>">Try Again</a></div></div>
    <% } else if ("notFound".equals(request.getParameter("error"))) { %>
    <div class="login-modal"><div class="login-modal-card"><div class="login-modal-icon">!</div><h2>Account Not Found</h2><p>No account exists with that email address.</p><a class="btn-primary" href="${pageContext.request.contextPath}/register.jsp<%= loginSuffix %>">Create Account</a></div></div>
    <% } %>
</body>
</html>
