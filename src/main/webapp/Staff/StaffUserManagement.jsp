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
    <style>
      #user-management-table tbody tr[hidden] { display: none !important; }
      .view-only-badge { padding:6px 14px; border-radius:20px; font-size:12px; font-weight:bold; background:#f3f4f6; color:#6b7280; }
    </style>
</head>
<body class="admin-body">

    <jsp:include page="StaffNavbar.jsp" />

    <div class="admin-layout">
      <jsp:include page="StaffSidebar.jsp" />

      <main class="main-content">
        <div class="container">
          
          <div class="page-header" style="text-align: left; margin-bottom: 20px;">
            <h1>Account Settings</h1>
          </div>

          <div class="sub-nav-tabs">
              <a href="${pageContext.request.contextPath}/staff/my-profile">My Profile</a>
              <a href="${pageContext.request.contextPath}/staff/user-management" class="active">User Management</a>
              <a href="${pageContext.request.contextPath}/staff/archived-staff">Archived Staff</a>
              <a href="${pageContext.request.contextPath}/staff/archived-guest">Archived Guest</a>
          </div>

          <!-- FIXED SEARCH BAR CONTAINER (Add New button removed for Staff) -->
          <div style="display: flex; gap: 15px; align-items: center; width: 100%; margin-bottom: 25px;">
            <div class="owner-search-filter" style="flex: 1; margin: 0 !important;">
              <form id="user-search-form" style="display: flex; width: 100%; align-items: center; justify-content: space-between; gap: 15px;">
                <div class="search-input-wrapper">
                  <input type="text" id="user-search-input" placeholder="Search any name, role, email, phone, or status..." class="search-input" />
                </div>
                <button type="submit" class="btn-primary" style="border-radius: 8px !important; padding: 10px 24px !important;">Search</button>
              </form>
            </div>
          </div>

          <!-- Data Table -->
          <div class="table-card">
            <div class="table-header" style="text-align: left; margin-bottom: 15px;">
              <h2>Registered System Users</h2>
            </div>
            
            <div class="table-responsive">
              <table class="data-table" id="user-management-table">
                <thead>
                  <tr>
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
                <tr class="user-data-row" data-user-row>
                    <td><%= staff.getStaffName() %></td>
                    <td><%= staff.getStaffRoles() %></td>
                    <td><%= staff.getStaffEmail() %></td>
                    <td><%= staff.getStaffPhoneNumber() %></td>
                    <td><span style="color: #10b981; font-weight: 600;">Active</span></td>
                    <td class="text-center">
                        <span class="view-only-badge">View Only</span>
                    </td>
                </tr>
                <%
                    }
                } else {
                %>
                <tr data-empty-row>
                    <td colspan="6">No staff found.</td>
                </tr>
                <%
                }
                %>

                <%
                if (guestList != null) {
                    for (Guest guest : guestList) {
                %>
                <tr class="user-data-row" data-user-row>
                    <td><%= guest.getGuestName() %></td>
                    <td>Guest</td>
                    <td><%= guest.getGuestEmail() %></td>
                    <td><%= guest.getGuestPhoneNumber() %></td>
                    <td><span style="color:#10b981;font-weight:bold;">Active</span></td>
                    <td class="text-center">
                        <span class="view-only-badge">View Only</span>
                    </td>
                </tr>
                <%
                    }
                }
                %>
                <tr id="no-search-results" hidden>
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
    document.addEventListener("DOMContentLoaded", function () {
      const form = document.getElementById("user-search-form");
      const input = document.getElementById("user-search-input");
      const rows = Array.from(document.querySelectorAll("#user-management-table tbody tr[data-user-row]"));
      const noResults = document.getElementById("no-search-results");
      const emptyRows = Array.from(document.querySelectorAll("#user-management-table tbody tr[data-empty-row]"));

      function normalize(value) {
        return value.toLocaleLowerCase().normalize("NFKD").replace(/[\u0300-\u036f]/g, "").replace(/\s+/g, " ").trim();
      }

      function filterUsers() {
        const query = normalize(input.value);
        let matches = 0;
        rows.forEach(function (row) {
          const rowText = normalize(Array.from(row.cells).map(function (cell) {
            return cell.textContent;
          }).join(" "));
          const visible = query === "" || rowText.includes(query);
          row.hidden = !visible;
          if (visible) matches++;
        });
        emptyRows.forEach(function (row) { row.hidden = query !== "" || rows.length > 0; });
        noResults.hidden = matches !== 0;
      }

      input.addEventListener("input", filterUsers);
      input.addEventListener("search", filterUsers);
      form.addEventListener("submit", function (event) {
        event.preventDefault();
        filterUsers();
      });
      filterUsers();
    });
    </script>
</body>
</html>