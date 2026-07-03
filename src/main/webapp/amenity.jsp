<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.Amenity" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Manage Amenities - Cuti Murah Melaka</title>
    <link rel="stylesheet" type="text/css" href="css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body class="admin-body">
    <div class="admin-layout">
        
        <!-- Sidebar Navigation -->
        <aside class="sidebar">
            <div class="sidebar-header">
                <span class="brand-text">Cuti Murah Admin</span>
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
                <a href="userManagement.jsp" class="nav-link">
                    <i class="fas fa-users icon"></i> Guests
                </a>
                <a href="${pageContext.request.contextPath}/amenity" class="nav-link active">
                    <i class="fas fa-list icon"></i> Amenities
                </a>
            </nav>
        </aside>

        <!-- Main Workspace -->
        <main class="main-content">
            <div class="container">
                
                <div class="page-header" style="display: flex; justify-content: space-between; align-items: center;">
                    <div>
                        <h1>Centralized Amenities Management</h1>
                        <p class="text-muted">Manage standard amenities available across all chalet listings.</p>
                    </div>
                </div>

                <div class="profile-grid" style="grid-template-columns: 1fr 2fr; gap: 2rem;">
                    
                    <!-- Left Side: Add New Amenity Form -->
                    <div class="table-card" style="padding: 1.5rem; background: #fff;">
                        <h3 style="margin-bottom: 1rem; color: var(--primary-color);">Add New Amenity</h3>
                        <form action="${pageContext.request.contextPath}/amenity/create" method="POST">
                            <div class="form-group">
                                <label>Amenity Name</label>
                                <input type="text" name="amenityName" class="form-control" placeholder="e.g., Wi-Fi, Swimming Pool" required>
                            </div>
                            <button type="submit" class="btn-primary btn-block" style="margin-top: 1rem;">Save Amenity</button>
                        </form>
                    </div>

                    <!-- Right Side: Amenities List Table -->
                    <div class="table-card">
                        <div class="table-header">
                            <h2>Active System Amenities</h2>
                        </div>
                        <div class="table-responsive">
                            <table class="data-table">
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Amenity Name</th>
                                        <th style="text-align: center;">Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <%
                                        List<Amenity> amenityList = (List<Amenity>) request.getAttribute("amenityList");
                                        if (amenityList != null && !amenityList.isEmpty()) {
                                            for (Amenity amenity : amenityList) {
                                    %>
                                    <tr>
                                        <td class="font-medium">#<%= amenity.getAmenityId() %></td>
                                        <td>
                                            <!-- Inline Update Form for quick name modification -->
                                            <form action="${pageContext.request.contextPath}/amenity/update" method="POST" style="display: flex; gap: 0.5rem; margin: 0;">
                                                <input type="hidden" name="amenityId" value="<%= amenity.getAmenityId() %>">
                                                <input type="text" name="amenityName" class="form-control" value="<%= amenity.getAmenityName() %>" style="padding: 0.25rem 0.5rem;" required>
                                                <button type="submit" class="btn-primary" style="padding: 0.25rem 0.75rem; font-size: 0.85rem;">Update</button>
                                            </form>
                                        </td>
                                        <td style="text-align: center; vertical-align: middle;">
                                            <a href="${pageContext.request.contextPath}/amenity/archive?id=<%= amenity.getAmenityId() %>" 
                                               class="btn-danger" 
                                               style="text-decoration: none; padding: 0.25rem 0.5rem;"
                                               onclick="return confirm('Are you sure you want to archive this amenity?');">
                                               <i class="fas fa-archive"></i> Archive
                                            </a>
                                        </td>
                                    </tr>
                                    <%
                                            }
                                        } else {
                                    %>
                                    <tr>
                                        <td colspan="3" style="text-align: center; color: var(--text-muted); font-style: italic; padding: 2rem;">
                                            No active amenities found in the system. Use the form on the left to add one!
                                        </td>
                                    </tr>
                                    <%
                                        }
                                    %>
                                </tbody>
                            </table>
                        </div>
                    </div>

                </div>

            </div>
        </main>
    </div>
</body>
</html>