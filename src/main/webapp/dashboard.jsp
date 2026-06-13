<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard - DG Rimbun</title>
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
          <a href="dashboard.jsp" class="nav-link active">
            <i class="fas fa-home icon"></i> Dashboard
          </a>
          <a href="#" class="nav-link">
            <i class="fas fa-calendar-alt icon"></i> Bookings
          </a>
          <a href="manageHomestays.jsp" class="nav-link">
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
          
          <div class="page-header">
            <h1>Dashboard Overview</h1>
            <p class="text-muted">Welcome back, System Admin.</p>
          </div>

          <!-- Stat Cards -->
          <div class="dashboard-stats">
            <div class="stat-card">
              <div class="stat-icon" style="background-color: #dbeafe; color: #2563eb;">
                <i class="fas fa-users"></i>
              </div>
              <div class="stat-info">
                <h3>Total Guests</h3>
                <p class="stat-number">124</p> <!-- Alya will replace this with <%= totalUsers %> later -->
              </div>
            </div>

            <div class="stat-card">
              <div class="stat-icon" style="background-color: #dcfce7; color: #16a34a;">
                <i class="fas fa-check-circle"></i>
              </div>
              <div class="stat-info">
                <h3>Active Bookings</h3>
                <p class="stat-number">18</p>
              </div>
            </div>

            <div class="stat-card">
              <div class="stat-icon" style="background-color: #fef9c3; color: #ca8a04;">
                <i class="fas fa-building"></i>
              </div>
              <div class="stat-info">
                <h3>Total Units</h3>
                <p class="stat-number">100</p>
              </div>
            </div>
          </div>

        </div>
      </main>
    </div>
</body>
</html>