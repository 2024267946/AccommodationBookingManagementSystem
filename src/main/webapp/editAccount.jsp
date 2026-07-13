<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Profile" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Edit Account - Cuti Murah Melaka</title>
    <jsp:include page="guestHeader.jsp" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css">
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/theme.css">

</head>
<body class="auth-body profile-edit-page">
<style>
    body.profile-edit-page { padding-top: 0 !important; }
    body.profile-edit-page .guest-user-nav { position: relative !important; top: auto !important; }
    body.profile-edit-page .auth-container { margin: 42px auto 70px; }
</style>
<jsp:include page="navbar.jsp" />
    <div class="auth-container" style="max-width: 500px;">
        <div class="auth-card">
            <div class="auth-header">
                <h2>Edit Account</h2>
                <p>Update your personal information for Cuti Murah Melaka</p>
            </div>

            <% if (request.getParameter("error") != null) { %>
                <div class="message message-error">Unable to update your profile. Please check the information and try again.</div>
            <% } %>
            
            <!-- Points to your single-servlet path mapping matching Member 3 specs -->
            <form action="${pageContext.request.contextPath}/profile/update-profile" method="POST">
                <div class="form-group">
                    <label>Full Name</label>
                    <input type="text" name="fullName" class="form-control" value="${profile.name != null ? profile.name : ''}" required>
                </div>
                
                <div class="form-group">
                    <label></i>Phone Number</label>
                    <input type="tel" name="phone" class="form-control" value="${profile.phone != null ? profile.phone : ''}" required>
                </div>
                
                <div class="form-group">
                    <label>Email Address</label>
                    <input type="email" class="form-control" value="${profile.email != null ? profile.email : ''}" readonly>
                </div>
                <div class="form-group">
                    <label>New Password (Optional)</label>
                    <input type="password" name="password" class="form-control" placeholder="Leave blank to keep current password">
                </div>
                
                <div style="display: flex; gap: 1rem; margin-top: 2rem;">
                    <a href="${pageContext.request.contextPath}/profile" class="btn-clear text-center" style="flex: 1; text-decoration: none; text-align: center; line-height: 2.2;">Cancel</a>
                    <button type="submit" class="btn-primary" style="flex: 1;">Save</button>
                </div>
            </form>
        </div>
    </div>
</body>
</html>
