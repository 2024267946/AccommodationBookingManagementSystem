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
    body.profile-edit-page { padding-top: 82px !important; }
    body.profile-edit-page .guest-user-nav { position: fixed !important; top: 0 !important; }
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
                <div class="message message-error"><%= "passwordMismatch".equals(request.getParameter("error"))
                        ? "New passwords must match and contain at least 6 characters."
                        : "Unable to update your profile. Please check the information and try again." %></div>
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
                    <input type="email" name="email" class="form-control" value="${profile.email != null ? profile.email : ''}" readonly>
                </div>

                <div class="form-group" style="margin-top:24px;">
                    <label>New Password <span class="text-muted" style="font-weight:400;">(Optional)</span></label>
                    <input id="editNewPassword" type="password" name="newPassword" class="form-control" minlength="6" autocomplete="new-password" placeholder="Leave blank to keep current password">
                </div>

                <div class="form-group">
                    <label>Confirm New Password <span class="text-muted" style="font-weight:400;">(Optional)</span></label>
                    <input id="editConfirmPassword" type="password" name="confirmPassword" class="form-control" minlength="6" autocomplete="new-password" placeholder="Re-enter the new password">
                    <small id="editPasswordMismatch" style="display:none;color:#a61b1b;margin-top:6px;">New passwords do not match.</small>
                </div>
                <div style="display: flex; gap: 1rem; margin-top: 2rem;">
                    <a href="${pageContext.request.contextPath}/profile" class="btn-clear text-center" style="flex: 1; text-decoration: none; text-align: center; line-height: 2.2;">Cancel</a>
                    <button type="submit" class="btn-primary" style="flex: 1;">Save</button>
                </div>
            </form>
        </div>
    </div>
    <script>
    const editPassword = document.getElementById('editNewPassword');
    const editConfirmation = document.getElementById('editConfirmPassword');
    function validateOptionalPassword() {
        const oneEntered = editPassword.value !== '' || editConfirmation.value !== '';
        const mismatch = oneEntered && editPassword.value !== editConfirmation.value;
        editConfirmation.required = oneEntered;
        editPassword.required = editConfirmation.value !== '';
        editConfirmation.setCustomValidity(mismatch ? 'New passwords do not match.' : '');
        document.getElementById('editPasswordMismatch').style.display = mismatch ? 'block' : 'none';
    }
    editPassword.addEventListener('input', validateOptionalPassword);
    editConfirmation.addEventListener('input', validateOptionalPassword);
    </script>
</body>
</html>
