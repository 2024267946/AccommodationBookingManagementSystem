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
    List<?> guestList = (List<?>) request.getAttribute("guestList");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>View Guest | Staff</title>
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
                    <h1>Guest List</h1>
                    <p class="text-muted">Staff can only view guest records. Archive and delete actions are disabled.</p>
                </div>

                <div class="table-card" style="padding:30px;">
                    <div style="display:flex; align-items:center; justify-content:space-between; margin-bottom:25px;">
                        <h3 style="margin:0;">Registered Guests</h3>
                        <span style="font-size:0.85rem; color:var(--text-muted); font-weight:600;">
                            Total: <%= guestList == null ? 0 : guestList.size() %>
                        </span>
                    </div>

                    <table style="width:100%; border-collapse:collapse;">
                        <thead>
                            <tr style="background:#f3f0e8; color:#555;">
                                <th style="text-align:left; padding:16px; font-size:14px;">Guest ID</th>
                                <th style="text-align:left; padding:16px; font-size:14px;">Name</th>
                                <th style="text-align:left; padding:16px; font-size:14px;">Email</th>
                                <th style="text-align:left; padding:16px; font-size:14px;">Phone Number</th>
                                <th style="text-align:left; padding:16px; font-size:14px;">Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (guestList == null || guestList.isEmpty()) { %>
                                <tr>
                                    <td colspan="5" style="padding:20px; text-align:center; color:var(--text-muted);">No guest records found.</td>
                                </tr>
                            <% } else { 
                                for (Object guest : guestList) { %>
                                    <tr>
                                        <td style="padding:16px; border-bottom:1px solid #eee;"><%= value(guest, "getGuestID", "getGuestId") %></td>
                                        <td style="padding:16px; border-bottom:1px solid #eee;"><%= value(guest, "getGuestName") %></td>
                                        <td style="padding:16px; border-bottom:1px solid #eee;"><%= value(guest, "getGuestEmail") %></td>
                                        <td style="padding:16px; border-bottom:1px solid #eee;"><%= value(guest, "getGuestPhoneNumber", "getGuestPhoneNo", "getGuestPhone") %></td>
                                        <td style="padding:16px; border-bottom:1px solid #eee;">
                                            <span style="padding:6px 14px; border-radius:20px; font-size:13px; font-weight:bold; background:#e8f3ea; color:#4f7d52;">View Only</span>
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
