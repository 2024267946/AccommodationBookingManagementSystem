<%@ page import="model.Staff" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    Staff staff = (Staff) request.getAttribute("staff");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Update My Profile | Staff</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/theme.css">
</head>
<body class="admin-body">
    <jsp:include page="StaffNavbar.jsp" />

    <div class="admin-layout">
        <jsp:include page="StaffSidebar.jsp" />

        <main class="main-content">
            <div class="container" style="max-width:850px; margin:0;">
                <div class="page-header" style="margin-bottom:30px; text-align:left;">
                    <h1>Update My Profile</h1>
                    <p class="text-muted">You can only update your own staff account details.</p>
                </div>

                <div class="table-card" style="padding:35px;">
                    <% if (staff == null) { %>
                        <p style="color:var(--danger); margin:0;">Staff profile not found.</p>
                    <% } else { %>
                        <form action="${pageContext.request.contextPath}/staff/update" method="POST">
                            <input type="hidden" name="staffID" value="<%= staff.getStaffId() %>">
                            <input type="hidden" name="staffRoles" value="<%= staff.getStaffRoles() %>">

                            <label style="font-weight:600; display:block; margin-bottom:8px;">Staff ID</label>
                            <input type="text" value="<%= staff.getStaffId() %>" readonly
                                   style="width:100%; padding:14px; margin-bottom:20px; border:1px solid #ddd; border-radius:10px; box-sizing:border-box; background:#f7f7f2;">

                            <label style="font-weight:600; display:block; margin-bottom:8px;">Staff Name</label>
                            <input type="text" name="staffName" value="<%= staff.getStaffName() %>" required
                                   style="width:100%; padding:14px; margin-bottom:20px; border:1px solid #ddd; border-radius:10px; box-sizing:border-box;">

                            <label style="font-weight:600; display:block; margin-bottom:8px;">Email</label>
                            <input type="email" name="staffEmail" value="<%= staff.getStaffEmail() %>" required
                                   style="width:100%; padding:14px; margin-bottom:20px; border:1px solid #ddd; border-radius:10px; box-sizing:border-box;">

                            <label style="font-weight:600; display:block; margin-bottom:8px;">Phone Number</label>
                            <input type="text" name="staffPhoneNumber" value="<%= staff.getStaffPhoneNumber() %>" required
                                   style="width:100%; padding:14px; margin-bottom:20px; border:1px solid #ddd; border-radius:10px; box-sizing:border-box;">

                            <label style="font-weight:600; display:block; margin-bottom:8px;">Password</label>
                            <input type="password" name="staffPassword" value="<%= staff.getStaffPassword() %>" required
                                   style="width:100%; padding:14px; margin-bottom:25px; border:1px solid #ddd; border-radius:10px; box-sizing:border-box;">

                            <div style="display:flex; gap:12px;">
                                <button type="submit" class="btn-primary" style="padding:12px 24px; border-radius:8px;">Save Changes</button>
                                <a href="${pageContext.request.contextPath}/staff/view-staff" style="padding:12px 24px; border-radius:8px; text-decoration:none; background:#f3f0e8; color:#555; font-weight:600;">Cancel</a>
                            </div>
                        </form>
                    <% } %>
                </div>
            </div>
        </main>
    </div>
</body>
</html>
