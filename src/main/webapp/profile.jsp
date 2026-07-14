<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Profile" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>My Profile - Cuti Murah Melaka</title>
    <jsp:include page="header.jsp" />
</head>
<body>
    <jsp:include page="navbar.jsp" />

    <main class="container" style="max-width:760px;padding:3rem 5%;min-height:75vh;">
        <div class="page-header" style="text-align:left;margin-bottom:24px;">
            <h1>My Profile</h1>
            <p class="text-muted">Manage your personal information and account security.</p>
        </div>

        <% if (request.getParameter("passwordError") != null) { %>
            <div class="message message-error">Unable to reset password. Make sure both new password fields match and try again.</div>
        <% } %>

        <section class="profile-card" style="padding:0;overflow:hidden;text-align:left;box-shadow:0 10px 30px rgba(15,45,36,.08);">
            <div style="padding:28px 32px;background:#f7faf8;border-bottom:1px solid var(--border-color);display:flex;align-items:center;justify-content:space-between;gap:20px;flex-wrap:wrap;">
                <div class="profile-header">
                    <h2 style="margin:0 0 7px;">${profile.name != null ? profile.name : "Guest User"}</h2>
                    <p class="text-muted" style="margin:0;">Your personal account information</p>
                </div>
                <span class="badge badge-guest">${profile.role != null ? profile.role : "GUEST"} Account</span>
            </div>
                
            <div style="padding:32px;">
                <div class="profile-details" style="margin:0;padding:0;border:0;display:grid;gap:16px;">
                    <div style="padding:17px 18px;background:#faf9f6;border:1px solid #e8e1d8;border-radius:10px;">
                        <small class="text-muted" style="display:block;margin-bottom:6px;font-weight:700;text-transform:uppercase;letter-spacing:.06em;">Email Address</small>
                        <strong><i class="fas fa-envelope text-muted" style="margin-right:8px;"></i>${profile.email != null ? profile.email : "Not Specified"}</strong>
                    </div>
                    <div style="padding:17px 18px;background:#faf9f6;border:1px solid #e8e1d8;border-radius:10px;">
                        <small class="text-muted" style="display:block;margin-bottom:6px;font-weight:700;text-transform:uppercase;letter-spacing:.06em;">Phone Number</small>
                        <strong><i class="fas fa-phone text-muted" style="margin-right:8px;"></i>${profile.phone != null ? profile.phone : "Not Specified"}</strong>
                    </div>
                </div>
                
                <div class="profile-actions" style="display:flex;gap:12px;flex-wrap:wrap;margin-top:26px;">
                    <a href="${pageContext.request.contextPath}/profile/edit" class="btn-primary" style="text-decoration:none;">Edit Account</a>
                </div>
            </div>
        </section>
    </main>

    <footer class="site-footer">
        <p>&copy; 2026 Cuti Murah Melaka Management. All rights reserved.</p>
    </footer>
    <% if ("true".equals(request.getParameter("updateSuccess"))) { %><script>showAppNotification("Account Updated Successfully","Your latest profile information has been saved.","success",3500);</script><% } %>
    <% if ("true".equals(request.getParameter("passwordUpdated"))) { %><script>showAppNotification("Password Updated Successfully","Your new password has been securely saved.","success",3500);</script><% } %>
</body>
</html>
