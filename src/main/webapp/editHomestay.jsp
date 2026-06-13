<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Edit Chalet - DG Rimbun Admin</title>
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
      </aside>

      <!-- Main Content -->
      <main class="main-content">
        <div class="container" style="max-width: 800px; margin: 0;">
          
          <div class="page-header">
            <a href="manageHomestays.jsp" class="btn-clear" style="display: inline-block; margin-bottom: 1rem; text-decoration: none;">&larr; Back to List</a>
            <h1>Add / Edit Chalet Unit</h1>
          </div>

          <div class="table-card" style="padding: 2rem;">
            <form action="SaveHomestayServlet" method="POST">
                <!-- Hidden input for ID (if editing) -->
                <input type="hidden" name="homestayId" value="<%= request.getParameter("id") != null ? request.getParameter("id") : "" %>">
                
                <div class="admin-form-grid">
                    <div class="form-group">
                        <label>Unit Code (e.g., A01)</label>
                        <input type="text" name="unitCode" class="form-control" required>
                    </div>
                    
                    <div class="form-group">
                        <label>Chalet Name</label>
                        <input type="text" name="name" class="form-control" required>
                    </div>
                </div>

                <div class="admin-form-grid">
                    <div class="form-group">
                        <label>Price per Night (RM)</label>
                        <input type="number" name="price" class="form-control" step="0.01" required>
                    </div>
                    
                    <div class="form-group">
                        <label>Max Capacity (Guests)</label>
                        <input type="number" name="capacity" class="form-control" min="1" required>
                    </div>
                </div>

                <div class="form-group">
                    <label>Description</label>
                    <textarea name="description" class="form-control" rows="4" required></textarea>
                </div>
                
                <div class="form-group">
                    <label>Status</label>
                    <select name="status" class="form-control" required>
                        <option value="Available">Available</option>
                        <option value="Maintenance">Maintenance</option>
                    </select>
                </div>

                <div style="margin-top: 2rem; text-align: right;">
                    <button type="submit" class="btn-primary" style="padding: 0.75rem 2rem;">Save Unit Details</button>
                </div>
            </form>
          </div>

        </div>
      </main>
    </div>
</body>
</html>