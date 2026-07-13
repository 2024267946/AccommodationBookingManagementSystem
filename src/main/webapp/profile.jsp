<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Profile" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>My Profile - Cuti Murah Melaka</title>
    <jsp:include page="header.jsp" />
    <jsp:include page="navbar.jsp" />
</head>
<body>
    

    <main class="container" style="padding: 3rem 5%; min-height: 75vh;">
        <div class="page-header">
            <h1>Customer Portal</h1>
        </div>

        <div class="profile-grid">
            <div class="profile-card">
                <div class="profile-header">
                    <div class="profile-avatar">
                        <i class="fas fa-user"></i>
                    </div>
                    <h2>${profile.name != null ? profile.name : "Guest User"}</h2>
                    <p class="badge badge-guest" style="margin-top: 0.25rem;">${profile.role != null ? profile.role : "GUEST"} Account</p>
                </div>
                
                <div class="profile-details">
                    <p><strong><i class="fas fa-envelope text-muted"></i> Email:</strong> ${profile.email != null ? profile.email : "Not Specified"}</p>
                    <p><strong><i class="fas fa-phone text-muted"></i> Phone:</strong> ${profile.phone != null ? profile.phone : "Not Specified"}</p>
                </div>
                
                <div class="profile-actions">
                    <a href="${pageContext.request.contextPath}/profile/edit" class="btn-primary btn-block text-center" style="text-decoration: none; display: block; text-align: center;">Edit Profile</a>
                </div>
            </div>

            <div class="booking-history">
                <h2>My Reservation History</h2>
                <div class="table-card" style="margin-top: 1rem;">
                    <div class="table-responsive">
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>Booking ID</th>
                                    <th>Chalet Description</th>
                                    <th>Check-In Date</th>
                                    <th>Status</th>
                                    <th style="text-align: center;">Action Summary</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td class="font-medium">#BK-1001</td>
                                    <td>Standard Chalet A1 (Melaka Town)</td>
                                    <td>2026-06-20</td>
                                    <td><span class="badge badge-active">Confirmed</span></td>
                                    <td style="text-align: center;">
                                        <a href="invoice.jsp?id=1001" class="btn-primary" style="padding: 6px 12px; font-size: 0.85rem; text-decoration: none; border-radius: 4px;">
                                            <i class="fas fa-file-invoice"></i> View Invoice
                                        </a>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <footer class="site-footer">
        <p>&copy; 2026 Cuti Murah Melaka Management. All rights reserved.</p>
    </footer>
</body>
</html>
