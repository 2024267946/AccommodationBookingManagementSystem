<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Manage Chalets - DG Rimbun Admin</title>
    <link rel="stylesheet" type="text/css" href="css/style.css">
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
          <a href="manageHomestays.jsp" class="nav-link active">
            <i class="fas fa-building icon"></i> Chalet Units
          </a>
          <a href="userManagement.jsp" class="nav-link">
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
          
          <div class="page-header" style="display: flex; justify-content: space-between; align-items: center;">
            <div>
                <h1>Manage Chalet Units</h1>
                <p class="text-muted">View, add, edit, or remove Encik Ridzuan's 100 units.</p>
            </div>
            <!-- Button to Add New Unit -->
            <a href="editHomestay.jsp" class="btn-primary" style="text-decoration: none;">
                <i class="fas fa-plus"></i> Add New Unit
            </a>
          </div>

          <!-- Chalet Units Table -->
          <div class="table-card">
            <div class="table-responsive">
              <table class="data-table">
                <thead>
                  <tr>
                    <th>Unit Code</th>
                    <th>Name</th>
                    <th>Capacity</th>
                    <th>Price / Night</th>
                    <th>Status</th>
                    <th>Actions</th>
                  </tr>
                </thead>
                <tbody>
                  
                  <tr>
                    <td class="font-medium">A01</td>
                    <td>Standard Chalet A1</td>
                    <td>2 Guests</td>
                    <td>RM 150.00</td>
                    <td><span class="badge badge-active">Available</span></td>
                    <td style="display: flex; gap: 10px;">
                      <a href="editHomestay.jsp?id=1" class="btn-primary" style="padding: 4px 8px; font-size: 0.85rem; text-decoration: none;">Edit</a>
                      <form action="DeleteHomestayServlet" method="POST" class="inline-form" onsubmit="return confirm('Delete this unit?');">
                        <input type="hidden" name="homestayId" value="1">
                        <button type="submit" class="btn-danger">Delete</button>
                      </form>
                    </td>
                  </tr>

                  <tr>
                    <td class="font-medium">B01</td>
                    <td>Family Suite B1</td>
                    <td>4 Guests</td>
                    <td>RM 280.00</td>
                    <td><span class="badge badge-owner">Maintenance</span></td>
                    <td style="display: flex; gap: 10px;">
                      <a href="editHomestay.jsp?id=2" class="btn-primary" style="padding: 4px 8px; font-size: 0.85rem; text-decoration: none;">Edit</a>
                      <form action="DeleteHomestayServlet" method="POST" class="inline-form" onsubmit="return confirm('Delete this unit?');">
                        <input type="hidden" name="homestayId" value="2">
                        <button type="submit" class="btn-danger">Delete</button>
                      </form>
                    </td>
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