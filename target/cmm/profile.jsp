<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>My Profile - DG Rimbun</title>
    <link rel="stylesheet" type="text/css" href="css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
    <nav class="navbar">
        <div class="nav-brand">DG Rimbun</div>
        <div class="nav-links">
            <a href="index.jsp">Home</a>
            <a href="homestays.jsp">View Units</a>
            <a href="contact.jsp">Contact</a>
            <a href="profile.jsp" class="active-link">My Profile</a>
            <!-- Simple logout button -->
            <form action="LogoutServlet" method="POST" style="display:inline;">
                <button type="submit" class="btn-outline" style="border:none; cursor:pointer;">Logout</button>
            </form>
        </div>
    </nav>

    <main class="container" style="padding: 3rem 5%; min-height: 60vh;">
        <div class="page-header">
            <h1>My Profile</h1>
        </div>

        <div class="profile-grid">
            <!-- Left Side: Profile Info Card -->
            <div class="profile-card">
                <div class="profile-header">
                    <div class="profile-avatar">
                        <i class="fas fa-user"></i>
                    </div>
                    <h2>Jane Doe</h2>
                    <p class="text-muted">Guest Account</p>
                </div>
                <div class="profile-details">
                    <p><strong><i class="fas fa-envelope text-muted"></i> Email:</strong> jane@email.com</p>
                    <p><strong><i class="fas fa-phone text-muted"></i> Phone:</strong> +6012-345-6789</p>
                </div>
                <div class="profile-actions">
                    <a href="editAccount.jsp" class="btn-primary btn-block text-center" style="text-decoration: none; display: block;">Edit Profile</a>
                </div>
            </div>

            <!-- Right Side: Booking History -->
            <div class="booking-history">
                <h2>Booking History</h2>
                <div class="table-card" style="margin-top: 1rem;">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>Booking ID</th>
                                <th>Chalet</th>
                                <th>Check-in</th>
                                <th>Status</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>#BK-1001</td>
                                <td>Standard Chalet A1</td>
                                <td>2026-06-20</td>
                                <td><span class="badge badge-active">Confirmed</span></td>
                                <td><a href="invoice.jsp?id=1001" class="btn-primary" style="padding: 5px 10px; font-size: 0.85rem; text-decoration: none;">View Invoice</a></td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </main>

    <footer class="site-footer">
        <p>&copy; 2026 DG Rimbun Chalet Management. All rights reserved.</p>
    </footer>
</body>
</html>