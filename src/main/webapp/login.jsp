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
    <% if ("incorrect".equals(request.getParameter("error"))) { %><script>showAppNotification("Login Failed","Incorrect email or password. Please check your credentials and try again.","error",3500);</script>
    <% } else if ("notFound".equals(request.getParameter("error"))) { %><script>showAppNotification("Account Not Found","No account exists with that email address.","error",3500);</script><% } %>
</body>
</html>
