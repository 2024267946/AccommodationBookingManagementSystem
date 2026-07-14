<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Profile" %>
<%
    Profile profile = (Profile) request.getAttribute("profile");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>My Profile - Cuti Murah Melaka</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/theme.css">
</head>
<body class="admin-body">

    <!-- Top Navigation Bar Header -->
    <jsp:include page="ownerNavbar.jsp" />

    <div class="admin-layout">
        <!-- Pinned Left Sidebar Component -->
        <jsp:include page="sidebar.jsp" />

        <!-- Main Content Area -->
        <main class="main-content">
            <div class="container" style="max-width: 1000px; margin: 0;">
                
                <div class="page-header" style="text-align: left; margin-bottom: 20px;">
                    <h1>Account Settings</h1>
                </div>

                <% if (request.getParameter("error") != null) { %>
                    <div class="message message-error">Unable to update your profile. Please check the information and try again.</div>
                <% } else if (request.getParameter("passwordError") != null) { %>
                    <div class="message message-error">Unable to reset password. Make sure both new password fields match and try again.</div>
                <% } %>

                <!-- Sub-navigation tabs inside Account -->
                <div class="sub-nav-tabs">
                    <a href="${pageContext.request.contextPath}/Owner/myProfile" class="active">My Profile</a>
                    <a href="${pageContext.request.contextPath}/owner/view-staff">User Management</a>
                    <a href="${pageContext.request.contextPath}/owner/view-archived-staff">Archived Staff</a>
                    <a href="${pageContext.request.contextPath}/owner/view-archived-guest">Archived Guest</a>
                </div>

                <!-- Personal Information Profile Card -->
                <div class="table-card" style="padding: 0; overflow: hidden; background: #ffffff;">
                    
                    <!-- Card Subheader Section -->
                    <div style="padding: 20px 32px; border-bottom: 1px solid var(--border-color); background-color: #fafafa; text-align: left;">
                        <h3 style="margin: 0; font-size: 1.05rem; color: var(--text-main); font-weight: 600;">Personal Information</h3>
                    </div>

                    <!-- Profile Form Section -->
                    <div style="padding: 32px;">
                        <form id="profileForm" action="${pageContext.request.contextPath}/profile/update-profile" method="POST" style="display: flex; flex-direction: column; gap: 24px;">
                            <input type="hidden" name="userId" value="<%= profile.getId() %>">
                            
                            <!-- 1. Full Name Field -->
                            <div style="display: flex; flex-direction: column; gap: 8px; text-align: left;">
                                <label style="font-weight: 600; font-size: 0.9rem; color: var(--text-main);">Full Name</label>
                                <div style="display: flex; align-items: center; background: #f9f9f9; border: 1px solid var(--border-color); border-radius: 12px; padding: 4px 16px; transition: background 0.3s;" class="input-container">
                                    
                                    <input type="text" id="ownerName" name="fullName" value="<%= profile.getName() %>" required disabled style="border: none !important; width: 100%; padding: 12px 0 !important; background: transparent; font-size: 0.95rem; color: var(--text-main); outline: none;">
                                </div>
                            </div>

                            <!-- 2. Email Field -->
                            <div style="display: flex; flex-direction: column; gap: 8px; text-align: left;">
                                <label style="font-weight: 600; font-size: 0.9rem; color: var(--text-main);">Email</label>
                                <div style="display: flex; align-items: center; background: #f9f9f9; border: 1px solid var(--border-color); border-radius: 12px; padding: 4px 16px; transition: background 0.3s;" class="input-container">
                                    
                                    <input type="email" id="ownerEmail" name="email" value="<%= profile.getEmail() %>" disabled style="border: none !important; width: 100%; padding: 12px 0 !important; background: transparent; font-size: 0.95rem; color: var(--text-main); outline: none;">
                                </div>
                            </div>

                            <!-- 3. Phone Number Field -->
                            <div style="display: flex; flex-direction: column; gap: 8px; text-align: left;">
                                <label style="font-weight: 600; font-size: 0.9rem; color: var(--text-main);">Phone Number</label>
                                <div style="display: flex; align-items: center; background: #f9f9f9; border: 1px solid var(--border-color); border-radius: 12px; padding: 4px 16px; transition: background 0.3s;" class="input-container">
                                    
                                    <input type="text" id="ownerPhone" name="phone" value="<%= profile.getPhone() %>" required disabled style="border: none !important; width: 100%; padding: 12px 0 !important; background: transparent; font-size: 0.95rem; color: var(--text-main); outline: none;">
                                </div>
                            </div>

                            <div id="ownerPasswordFields" style="display:none;flex-direction:column;gap:16px;text-align:left;">
                                <div><label style="font-weight:600;font-size:.9rem;">New Password <span class="text-muted" style="font-weight:400;">(Optional)</span></label><input type="password" id="ownerNewPassword" name="newPassword" minlength="6" autocomplete="new-password" disabled placeholder="Leave blank to keep current password" style="box-sizing:border-box;width:100%;margin-top:8px;padding:12px 14px;border:1px solid var(--border-color);border-radius:10px;"></div>
                                <div><label style="font-weight:600;font-size:.9rem;">Confirm New Password <span class="text-muted" style="font-weight:400;">(Optional)</span></label><input type="password" id="ownerConfirmPassword" name="confirmPassword" minlength="6" autocomplete="new-password" disabled placeholder="Re-enter the new password" style="box-sizing:border-box;width:100%;margin-top:8px;padding:12px 14px;border:1px solid var(--border-color);border-radius:10px;"><small id="ownerPasswordMismatch" style="display:none;color:#a61b1b;margin-top:6px;">New passwords do not match.</small></div>
                            </div>

                            <!-- Interactive Button Action Trigger -->
                            <div style="text-align: left; margin-top: 8px;">
                                <button type="button" id="actionBtn" onclick="toggleEditMode()" class="btn-primary" style="border-radius: 12px !important; padding: 12px 28px !important; font-size: 0.9rem !important; display: inline-flex; align-items: center; gap: 8px;">
                                    <span id="btnText">Edit Account</span>
                                </button>
                            </div>

                        </form>
                    </div>
                </div>

            </div>
        </main>
    </div>

    <% if ("true".equals(request.getParameter("updateSuccess"))) { %><script>showAppNotification("Account Updated Successfully","Your latest profile information has been saved.","success",3500);</script><% } %>
    <% if ("true".equals(request.getParameter("passwordUpdated"))) { %><script>showAppNotification("Password Updated Successfully","Your new password has been securely saved.","success",3500);</script><% } %>

    <script>
        let isEditMode = false;

        function toggleEditMode() {
            const form = document.getElementById('profileForm');
            // Cleaned up the selector text string perfectly
            const inputs = form.querySelectorAll('#ownerName, #ownerEmail, #ownerPhone, #ownerNewPassword, #ownerConfirmPassword');
            const actionBtn = document.getElementById('actionBtn');
            const btnText = document.getElementById('btnText');
            const containers = form.querySelectorAll('.input-container');

            if (!isEditMode) {
                // Switch to Edit Mode
                inputs.forEach(input => input.removeAttribute('disabled'));
                document.getElementById('ownerPasswordFields').style.display = 'flex';
                setupOptionalPassword('ownerNewPassword', 'ownerConfirmPassword', 'ownerPasswordMismatch');
                containers.forEach(container => container.style.background = '#ffffff');
                document.getElementById('ownerName').focus();
                
                btnText.innerText = 'Save Changes';
                isEditMode = true;
            } else {
                // Validate form first, then submit programmatically 
                if (form.checkValidity()) {
                    form.submit();
                } else {
                    form.reportValidity();
                }
            }
        }
        function setupOptionalPassword(passwordId, confirmationId, errorId) {
            const password = document.getElementById(passwordId), confirmation = document.getElementById(confirmationId), error = document.getElementById(errorId);
            function validate(){const entered=password.value!==''||confirmation.value!=='';const mismatch=entered&&password.value!==confirmation.value;password.required=confirmation.value!=='';confirmation.required=entered;confirmation.setCustomValidity(mismatch?'New passwords do not match.':'');error.style.display=mismatch?'block':'none';}
            password.addEventListener('input',validate);confirmation.addEventListener('input',validate);
        }
    </script>
</body>
</html>
