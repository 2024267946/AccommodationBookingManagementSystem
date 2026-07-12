<%@ page import="java.util.List" %>
<%@ page import="model.Guest" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    List<Guest> guestList = (List<Guest>) request.getAttribute("guestList");
    String errorMessage = (String) session.getAttribute("errorMessage");
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Guest Management</title>

<style>
body { margin:0; font-family:Arial,sans-serif; background:#fafafa; color:#333; }
.header { height:70px; display:flex; align-items:center; justify-content:space-between; padding:0 35px; background:white; border-bottom:1px solid #eee; }
.logo { font-size:24px; font-weight:bold; color:#8aa07d; }
.topnav a { margin-left:25px; text-decoration:none; color:#555; font-weight:600; }

.sidebar { position:fixed; top:71px; left:0; width:230px; height:100%; background:white; border-right:1px solid #eee; padding:25px 15px; }
.sidebar a { display:block; padding:15px 20px; margin-bottom:8px; text-decoration:none; color:#333; border-radius:10px; }
.sidebar a.active { background:#8fa482; color:white; }

.content { margin-left:270px; padding:40px; }
h1 { font-size:38px; margin-bottom:35px; }

.tabs { display:flex; gap:40px; border-bottom:1px solid #ddd; margin-bottom:25px; }
.tabs a { text-decoration:none; color:#777; padding-bottom:15px; font-weight:bold; }
.tabs a.active { color:#8fa482; border-bottom:2px solid #8fa482; }

.card { background:white; border:1px solid #eee; border-radius:15px; box-shadow:0 3px 12px rgba(0,0,0,0.05); overflow:hidden; }
.card-header { padding:25px 30px; font-size:18px; font-weight:bold; border-bottom:1px solid #eee; }
.toolbar { padding:35px 30px; }
.search-box { width:480px; padding:15px; border:1px solid #ddd; border-radius:10px; font-size:15px; }

table { width:calc(100% - 60px); margin:0 30px 30px 30px; border-collapse:collapse; }
th { background:#f7f4ed; text-align:left; padding:18px; }
td { padding:18px; border-bottom:1px solid #eee; }

.badge { padding:6px 12px; border-radius:10px; font-size:13px; font-weight:bold; background:#e8f7ef; color:#168a4a; }
.delete { color:#c43b55; text-decoration:none; font-weight:bold; }
</style>

<script>
function searchGuest() {
    let input = document.getElementById("searchInput").value.toLowerCase();
    let rows = document.querySelectorAll("#guestTable tbody tr");

    rows.forEach(row => {
        row.style.display = row.innerText.toLowerCase().includes(input) ? "" : "none";
    });
}
</script>

</head>

<body>

<% if (errorMessage != null) { %>
<script>alert("<%= errorMessage %>");</script>
<% session.removeAttribute("errorMessage"); } %>

<div class="header">
    <div class="logo">Homestay Murah Melaka</div>
    <div class="topnav">
        <a href="<%=request.getContextPath()%>/owner/dashboard">Dashboard</a>
        <a href="<%=request.getContextPath()%>/auth/LogoutServlet">Logout</a>
    </div>
</div>

<div class="sidebar">
    <a href="<%=request.getContextPath()%>/owner/dashboard">Dashboard</a>

    <a href="<%=request.getContextPath()%>/staff/view-staff" class="active">
        Management
    </a>

    <a href="#">Booking</a>

    <a href="#">Accommodation</a>

    <a href="#">Profile</a>

    <a href="<%=request.getContextPath()%>/auth/LogoutServlet">
        Logout
    </a>
</div>

<div class="content">

    <h1>Guest Management</h1>

    <div class="tabs">
        <a href="<%=request.getContextPath()%>/staff/view-staff">Staff Management</a>
        <a href="<%=request.getContextPath()%>/staff/view-guest" class="active">Guest Management</a>
    </div>

    <div class="card">
        <div class="card-header">Registered Guests</div>

        <div class="toolbar">
            <input type="text" id="searchInput" onkeyup="searchGuest()" class="search-box"
                   placeholder="Search Guest Name, Email or Phone...">
        </div>

        <table id="guestTable">
            <thead>
                <tr>
                    <th>Name</th>
                    <th>Role</th>
                    <th>Email</th>
                    <th>Phone</th>
                    <th>Guest ID</th>
                    <th>Actions</th>
                </tr>
            </thead>

            <tbody>
            <%
                if (guestList != null && !guestList.isEmpty()) {
                    for (Guest guest : guestList) {
            %>
                <tr>
                    <td><b><%= guest.getGuestName() %></b></td>
                    <td><span class="badge">Guest</span></td>
                    <td><%= guest.getGuestEmail() %></td>
                    <td><%= guest.getGuestPhoneNumber() %></td>
                    <td><%= guest.getGuestId() %></td>
                    <td>
                        <a class="delete"
                           href="<%=request.getContextPath()%>/staff/archive-guest?guestID=<%=guest.getGuestId()%>"
                           onclick="return confirm('Are you sure you want to delete this guest?');">
                           Delete
                        </a>
                    </td>
                </tr>
            <%
                    }
                } else {
            %>
                <tr>
                    <td colspan="6">No guest found.</td>
                </tr>
            <%
                }
            %>
            </tbody>
        </table>
    </div>
</div>

</body>
</html>