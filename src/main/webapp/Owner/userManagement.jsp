<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page import="java.util.List" %>
<%@ page import="model.Staff" %>
<%@ page import="model.Guest" %>

<%
    List<Staff> staffList = (List<Staff>) request.getAttribute("staffList");
    List<Guest> guestList = (List<Guest>) request.getAttribute("guestList");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>User Management - Cuti Murah Melaka</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/theme.css">
</head>
<body class="admin-body">

    <jsp:include page="ownerNavbar.jsp" />

    <div class="admin-layout">
      <!-- Include Sidebar -->
      <jsp:include page="sidebar.jsp" />

      <!-- Main Content Container -->
      <main class="main-content">
        <div class="container">
          
          <div class="page-header" style="text-align: left; margin-bottom: 20px;">
            <h1>Account Settings</h1>
          </div>

          <!-- Sub-navigation tabs inside Account -->
          <div class="sub-nav-tabs">
              <a href="${pageContext.request.contextPath}/Owner/myProfile">My Profile</a>
              <a href="${pageContext.request.contextPath}/owner/view-staff" class="active">User Management</a>
              <a href="${pageContext.request.contextPath}/owner/view-archived-staff">Archived Staff</a>
              <a href="${pageContext.request.contextPath}/owner/view-archived-guest">Archived Guest</a>
          </div>

          <!-- FIXED SEARCH BAR CONTAINER CLASS WITH ADD STAFF ALIGNMENT -->
          <div style="display: flex; gap: 15px; align-items: center; width: 100%; margin-bottom: 25px;">
            
            <!-- Your search filter box takes up the left space -->
            <div class="owner-search-filter" style="flex: 1; margin: 0 !important;">
              <form id="user-search-form" style="display: flex; width: 100%; align-items: center; justify-content: space-between; gap: 15px;">
                <div class="search-input-wrapper">
                  <input
                    type="text"
                    id="user-search-input"
                    placeholder="Search Guest, Staff, or Owner Name..."
                    class="search-input"
                  />
                </div>
                <button type="submit" class="btn-primary" style="border-radius: 8px !important; padding: 10px 24px !important;">Search</button>
              </form>
            </div>

            <!-- "Add New" button neatly aligned to the right side -->
            <a href="${pageContext.request.contextPath}/owner/create-staff" class="btn-primary" style="text-decoration: none; border-radius: 8px !important; padding: 12px 24px !important; white-space: nowrap; height: fit-content;">
                Add New 
            </a>

          </div>

          <!-- Data Table -->
          <div class="table-card">
            <div class="table-header" style="text-align: left; margin-bottom: 15px;">
              <h2>Registered System Users</h2>
            </div>
            
            <div class="table-responsive">
              <table class="data-table" id="user-management-table">
                <thead>
    <tr class="user-data-row">
                    <th>Name</th>
                    <th>Role</th>
                    <th>Email</th>
                    <th>Phone</th>
                    <th>Status</th>
                    <th class="text-center">Actions</th>
                  </tr>
                </thead>
               <tbody>
				<%
			if (staffList != null && !staffList.isEmpty()) {
    		for (Staff staff : staffList) {
			%>
   			 <tr>
        	<td><%= staff.getStaffName() %></td>
       	 <td><%= staff.getStaffRoles() %></td>
        	<td><%= staff.getStaffEmail() %></td>
        <td><%= staff.getStaffPhoneNumber() %></td>
        <td><span style="color: #10b981; font-weight: 600;">Active</span></td>
        <td class="text-center">
<!--<a href="${pageContext.request.contextPath}/staff/update?staffID=<%= staff.getStaffId() %>"
         class="btn-primary"
           style="text-decoration:none; padding:8px 14px; border-radius:8px;">
           Update
        </a>-->

        <form action="${pageContext.request.contextPath}/owner/archive-staff" method="get" style="display:inline; margin:0;">
            <input type="hidden" name="staffID" value="<%= staff.getStaffId() %>">
            <button type="submit" class="btn-danger">Archive</button>
        </form>
    </td>
</tr>

<%
    }
} else {
%>
    <tr>
        <td colspan="6">No staff found.</td>
    </tr>
<%
}
%>

<%
if (guestList != null) {
    for (Guest guest : guestList) {
%>

<tr class="user-data-row">

    <td><%= guest.getGuestName() %></td>

    <td>Guest</td>

    <td><%= guest.getGuestEmail() %></td>

    <td><%= guest.getGuestPhoneNumber() %></td>

    <td>
        <span style="color:#10b981;font-weight:bold;">
            Active
        </span>
    </td>

    <td class="text-center">

 <form action="${pageContext.request.contextPath}/owner/archive-guest" method="get" style="display:inline; margin:0;">
            <input type="hidden" name="guestID" value="<%= guest.getGuestId() %>">
            <button type="submit" class="btn-danger">Archive</button>
        </form>
    </td>

</tr>

<%
    }
}
%>
<tr id="no-search-results" style="display:none;">
    <td colspan="6" class="text-center text-muted">No matching users found.</td>
</tr>
</tbody>
              </table>
            </div>
          </div>

        </div>
      </main>
    </div>
    <script>
      const userSearchForm = document.getElementById("user-search-form");
      const userSearchInput = document.getElementById("user-search-input");
      const userRows = document.querySelectorAll("#user-management-table .user-data-row");
      const noSearchResults = document.getElementById("no-search-results");

      function filterUsers() {
        const query = userSearchInput.value.trim().toLowerCase();
        let visibleRows = 0;

        userRows.forEach(function (row) {
          const matches = row.textContent.toLowerCase().includes(query);
          row.style.display = matches ? "" : "none";
          if (matches) visibleRows++;
        });

        noSearchResults.style.display = visibleRows === 0 ? "" : "none";
      }

      userSearchInput.addEventListener("input", filterUsers);
      userSearchForm.addEventListener("submit", function (event) {
        event.preventDefault();
        filterUsers();
      });
    </script>
</body>
</html>
