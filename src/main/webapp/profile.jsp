<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Profile" %>
<%@ page import="model.Booking,java.util.List" %>
<% List<Booking> profileBookings=(List<Booking>)request.getAttribute("profileBookings"); %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>My Profile - Cuti Murah Melaka</title>
    <jsp:include page="header.jsp" />
</head>
<body>
    <jsp:include page="navbar.jsp" />

    <main class="container" style="padding: 3rem 5%; min-height: 75vh;">
        <div class="page-header">
            <h1>Customer Portal</h1>
        </div>

        <div class="profile-grid">
            <div class="profile-card">
                <div class="profile-header">
                    <h2>${profile.name != null ? profile.name : "Guest User"}</h2>
                    <p class="badge badge-guest" style="margin-top: 0.25rem;">${profile.role != null ? profile.role : "GUEST"} Account</p>
                </div>
                
                <div class="profile-details">
                    <p><strong><i class="fas fa-envelope text-muted"></i> Email:</strong> ${profile.email != null ? profile.email : "Not Specified"}</p>
                    <p><strong><i class="fas fa-phone text-muted"></i> Phone:</strong> ${profile.phone != null ? profile.phone : "Not Specified"}</p>
                </div>
                
                <div class="profile-actions">
                    <a href="${pageContext.request.contextPath}/profile/edit" class="btn-primary btn-block text-center" style="text-decoration: none; display: block; text-align: center;">Edit Account</a>
                    <button type="button" class="btn-clear btn-block" style="width:100%;margin-top:10px;" onclick="togglePasswordReset()">Reset Password</button>
                </div>
            </div>

            <% if (request.getParameter("passwordError") != null) { %>
                <div class="message message-error">Unable to reset password. Check your current password and make sure the new passwords match.</div>
            <% } %>

            <div class="booking-history">
                <h2>My Reservation History</h2>
                <div class="table-card" style="margin-top: 1rem;">
                    <div class="table-responsive">
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>Booking ID</th>
                                    <th>Accommodation</th>
                                    <th>Check-In Date</th>
                                    <th>Status</th>
                                    <th style="text-align: center;">Action Summary</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% if(profileBookings==null||profileBookings.isEmpty()){ %>
                                <tr><td colspan="5" style="text-align:center;">No reservation history found.</td></tr>
                                <% } else { for(Booking booking:profileBookings){ %>
                                <tr><td class="font-medium"><%= booking.getBookingID() %></td><td><%= booking.getAccommodationName() %></td><td><%= booking.getCheckInDate() %></td><td><span class="badge badge-active"><%= "PENDING".equalsIgnoreCase(booking.getBookingStatus())?"PENDING PAYMENT":booking.getBookingStatus() %></span></td><td style="text-align:center;">
                                <% if(booking.isPaid()){ %><a href="${pageContext.request.contextPath}/booking/invoice?bookingID=<%= booking.getBookingID() %>" class="btn-primary" style="padding:6px 12px;font-size:.85rem;text-decoration:none;border-radius:4px;">View Invoice</a>
                                <% } else if("PENDING".equalsIgnoreCase(booking.getBookingStatus())){ %><a href="${pageContext.request.contextPath}/booking/pay?bookingID=<%= booking.getBookingID() %>" class="btn-primary" style="padding:6px 12px;font-size:.85rem;text-decoration:none;border-radius:4px;">Pay Now</a><% } else { %>—<% } %>
                                </td></tr>
                                <% }} %>
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
    <% if ("true".equals(request.getParameter("updateSuccess"))) { %><script>showAppNotification("Account Updated Successfully","Your latest profile information has been saved.","success",3500);</script><% } %>
<script>
function togglePasswordReset(){showPasswordResetModal('${pageContext.request.contextPath}/profile/reset-password');}
</script>
</body>
</html>
