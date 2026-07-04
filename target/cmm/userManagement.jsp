<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>User Management - DG Rimbun</title>
    
    <!-- Link to your custom CSS -->
    <link rel="stylesheet" type="text/css" href="css/style.css">
    <!-- FontAwesome for Icons (Usually allowed by lecturers) -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body class="admin-body">
    <div class="admin-layout">
      
      <!-- Sidebar -->
      <aside class="sidebar">
        <div class="sidebar-header">
          <span class="brand-text">DG Rimbun Admin</span>
        </div>
        <nav class="sidebar-nav">
          <a href="dashboard.jsp" class="nav-link">
            <i class="fas fa-home icon"></i> Dashboard
          </a>
          <a href="#" class="nav-link">
            <i class="fas fa-calendar-alt icon"></i> Bookings
          </a>
          <a href="manageHomestays.jsp" class="nav-link">
            <i class="fas fa-building icon"></i> Chalet Units
          </a>
          <a href="userManagement.jsp" class="nav-link active">
            <i class="fas fa-users icon"></i> Guests
          </a>
        </nav>
        <div class="sidebar-footer">
          <form action="LogoutServlet" method="POST">
             <button type="submit" class="btn-logout">
               <i class="fas fa-sign-out-alt"></i> Logout
             </button>
          </form>
        </div>
      </aside>

      <!-- Main Content -->
      <main class="main-content">
        <div class="container">
          
          <div class="page-header">
            <h1>User Management</h1>
          </div>

          <!-- Search Form -->
          <div class="search-card">
            <form action="userManagement.jsp" method="GET" class="search-form">
              <label class="search-label">Search User:</label>
              <div class="search-input-wrapper">
                <i class="fas fa-search search-icon"></i>
                <input
                  type="text"
                  name="query"
                  placeholder="Enter name, email, or phone number to search..."
                  value="<%= request.getParameter("query") != null ? request.getParameter("query") : "" %>"
                  class="search-input"
                />
              </div>
              <button type="submit" class="btn-primary">Search</button>
              
              <% if (request.getParameter("query") != null && !request.getParameter("query").isEmpty()) { %>
                  <a href="userManagement.jsp" class="btn-clear">Clear</a>
              <% } %>
            </form>
          </div>

          <!-- Data Table -->
          <div class="table-card">
            <div class="table-header">
              <h2>Registered Users</h2>
            </div>
            
            <div class="table-responsive">
              <table class="data-table">
                <thead>
                  <tr>
                    <th>Name</th>
                    <th>Role</th>
                    <th>Email</th>
                    <th>Phone</th>
                    <th>Active Booking</th>
                    <th>Actions</th>
                  </tr>
                </thead>
                <tbody>
                  
                  <tr>
                    <td class="font-medium">Jane Doe</td>
                    <td><span class="badge badge-guest">Guest</span></td>
                    <td class="text-muted">jane@email.com</td>
                    <td class="text-muted">+6012-345-6789</td>
                    <td><span class="badge badge-active">Active</span></td>
                    <td>
                      <form action="DeleteUserServlet" method="POST" class="inline-form" onsubmit="return confirm('Are you sure you want to delete this user?');">
                        <input type="hidden" name="userId" value="1">
                        <button type="submit" class="btn-danger">Delete</button>
                      </form>
                    </td>
                  </tr>

                  <tr>
                    <td class="font-medium">System Admin</td>
                    <td><span class="badge badge-owner">Owner</span></td>
                    <td class="text-muted">admin@dgrimbun.com</td>
                    <td class="text-muted">+6019-876-5432</td>
                    <td><span class="badge badge-none">None</span></td>
                    <td><span class="text-muted italic">Restricted</span></td>
                  </tr>

                </tbody>
              </table>
            </div>
          </div>

        </div>
      </main>
    </div>
</body>
</html>