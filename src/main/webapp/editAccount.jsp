<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Profile" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Edit Account - Cuti Murah Melaka</title>
    <!-- Appended ?v=3 to match your updated style rules -->
    <link rel="stylesheet" type="text/css" href="css/style.css?v=3">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css">
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/theme.css">

</head>
<body class="auth-body">
<jsp:include page="navbar.jsp" />
    <div class="auth-container" style="max-width: 500px;">
        <div class="auth-card">
            <div class="auth-header">
                <h2>Edit Account</h2>
                <p>Update your personal information for Cuti Murah Melaka</p>
            </div>
            
            <!-- Points to your single-servlet path mapping matching Member 3 specs -->
            <form action="${pageContext.request.contextPath}/profile/update-profile" method="POST">
                <input type="hidden" name="userId" value="${profile.id}">
                
                <!-- Hidden email identifier for the ProfileDAO database update query -->
                <input type="hidden" name="email" value="${profile.email}">
                
                <div class="form-group">
                    <label><i class="fas fa-id-card text-muted" style="margin-right: 5px;"></i> Full Name</label>
                    <input type="text" name="fullName" class="form-control" value="${profile.name != null ? profile.name : ''}" required>
                </div>
                
                <div class="form-group">
                    <label><i class="fas fa-phone text-muted" style="margin-right: 5px;"></i> Phone Number</label>
                    <input type="tel" name="phone" class="form-control" value="${profile.phone != null ? profile.phone : ''}" required>
                </div>
                
                <div class="form-group">
                    <label><i class="fas fa-envelope text-muted" style="margin-right: 5px;"></i> Email Address</label>
                    <!-- Disabled email input to preserve it as the primary database key block -->
                    <input type="email" class="form-control" value="${profile.email != null ? profile.email : ''}" required>
                </div>
                <div class="form-group">
                    <label><i class="fas fa-lock text-muted" style="margin-right: 5px;"></i> New Password (Optional)</label>
                    <input type="password" name="password" class="form-control" placeholder="Leave blank to keep current password">
                </div>
                
                <div style="display: flex; gap: 1rem; margin-top: 2rem;">
                    <a href="${pageContext.request.contextPath}/profile" class="btn-clear text-center" style="flex: 1; text-decoration: none; text-align: center; line-height: 2.2;">Cancel</a>
                    <button type="submit" class="btn-primary" style="flex: 1;">Save Changes</button>
                </div>
            </form>
        </div>
    </div>
</body>
</html>
