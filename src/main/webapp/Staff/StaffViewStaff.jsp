<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%!
    private String value(Object obj, String... methods) {
        if (obj == null) return "-";
        for (String method : methods) {
            try {
                Object result = obj.getClass().getMethod(method).invoke(obj);
                return result == null ? "-" : result.toString();
            } catch (Exception ignored) {}
        }
        return "-";
    }
%>
<%
    List<?> staffList = (List<?>) request.getAttribute("staffList");
    Object loggedStaff = session.getAttribute("loggedStaff");
    String loggedStaffID = value(loggedStaff, "getStaffId", "getStaffID");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>View Staff | Staff</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/theme.css">
</head>
<body class="admin-body">
    <jsp:include page="StaffNavbar.jsp" />

    <div class="admin-layout">
        <jsp:include page="StaffSidebar.jsp" />

        <main class="main-content">
            <div class="container" style="max-width:1100px; margin:0;">
                <div class="page-header" style="margin-bottom:30px; text-align:left;">
                    <h1>Staff List</h1>
                    <p class="text-muted">Staff can view all staff records but can only update their own profile.</p>
                </div>

                <div class="table-card" style="padding:30px;">
                    <div style="display:flex; align-items:center; justify-content:space-between; margin-bottom:25px;">
                        <h3 style="margin:0;">Staff Records</h3>
                        <span style="font-size:0.85rem; color:var(--text-muted); font-weight:600;">
                            Total: <%= staffList == null ? 0 : staffList.size() %>
                        </span>
                    </div>

                    <table style="width:100%; border-collapse:collapse;">
                        <thead>
                            <tr style="background:#f3f0e8; color:#555;">
                                <th style="text-align:left; padding:16px; font-size:14px;">Staff ID</th>
                                <th style="text-align:left; padding:16px; font-size:14px;">Name</th>
                                <th style="text-align:left; padding:16px; font-size:14px;">Email</th>
                                <th style="text-align:left; padding:16px; font-size:14px;">Phone Number</th>
                                <th style="text-align:left; padding:16px; font-size:14px;">Role</th>
                                <th style="text-align:left; padding:16px; font-size:14px;">Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (staffList == null || staffList.isEmpty()) { %>
                                <tr>
                                    <td colspan="6" style="padding:20px; text-align:center; color:var(--text-muted);">No staff records found.</td>
                                </tr>
                            <% } else {
                                for (Object staff : staffList) {
                                    String rowStaffID = value(staff, "getStaffId", "getStaffID");
                                    boolean isOwnProfile = rowStaffID.equals(loggedStaffID);
                            %>
                                <tr>
                                    <td style="padding:16px; border-bottom:1px solid #eee;"><%= rowStaffID %></td>
                                    <td style="padding:16px; border-bottom:1px solid #eee;"><%= value(staff, "getStaffName") %></td>
                                    <td style="padding:16px; border-bottom:1px solid #eee;"><%= value(staff, "getStaffEmail") %></td>
                                    <td style="padding:16px; border-bottom:1px solid #eee;"><%= value(staff, "getStaffPhoneNumber", "getStaffPhoneNo") %></td>
                                    <td style="padding:16px; border-bottom:1px solid #eee;"><%= value(staff, "getStaffRoles", "getStaffRole") %></td>
                                    <td style="padding:16px; border-bottom:1px solid #eee;">
                                        <% if (isOwnProfile) { %>
                                            <a href="${pageContext.request.contextPath}/staff/update" class="btn-primary" style="padding:8px 16px; font-size:0.8rem; text-decoration:none;">Update Me</a>
                                        <% } else { %>
                                            <span style="color:var(--text-muted); font-size:0.85rem;">View Only</span>
                                        <% } %>
                                    </td>
                                </tr>
                            <%  }
                            } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </main>
    </div>
</body>
</html>
