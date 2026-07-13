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
    <style>.account-modal{position:fixed;z-index:3000;inset:0;display:flex;align-items:center;justify-content:center;background:rgba(8,28,22,.62);padding:24px}.account-modal-card{width:min(420px,100%);padding:34px;border-radius:18px;background:#fff;text-align:center;box-shadow:0 24px 70px rgba(0,0,0,.22)}.account-modal-icon{display:flex;align-items:center;justify-content:center;width:62px;height:62px;margin:0 auto 18px;border-radius:50%;background:#eaf7ef;color:#17633a;font-size:28px;font-weight:bold}.account-modal h2{margin:0 0 9px;color:#123a30}.account-modal p{margin:0 0 22px;color:#746f69}</style>
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

            <div id="passwordResetCard" class="profile-card" style="display:none;text-align:left;">
                <h2 style="margin-top:0;">Reset Password</h2>
                <% if (request.getParameter("passwordError") != null) { %>
                    <div class="message message-error">Unable to reset password. Verify your current password and ensure the new passwords match.</div>
                <% } else if ("success".equals(request.getParameter("passwordReset"))) { %>
                    <div class="message message-success">Password updated successfully.</div>
                <% } %>
                <form action="${pageContext.request.contextPath}/profile/reset-password" method="post">
                    <div class="form-group"><label>Current Password</label><input class="form-control" type="password" name="currentPassword" required></div>
                    <div class="form-group"><label>New Password</label><input id="newPassword" class="form-control" type="password" name="newPassword" minlength="6" required></div>
                    <div class="form-group"><label>Confirm New Password</label><input id="confirmPassword" class="form-control" type="password" name="confirmPassword" minlength="6" required></div>
                    <div id="passwordMismatch" style="display:none;color:#a61b1b;margin-bottom:12px;">New passwords do not match.</div>
                    <button type="submit" class="btn-primary">Save New Password</button>
                </form>
            </div>

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
    <% if ("true".equals(request.getParameter("updateSuccess"))) { %>
    <div class="account-modal"><div class="account-modal-card"><div class="account-modal-icon">✓</div><h2>Account Updated Successfully</h2><p>Your latest profile information has been saved.</p><a class="btn-primary" href="${pageContext.request.contextPath}/profile" style="text-decoration:none;display:inline-flex;">Done</a></div></div>
    <% } %>
<script>
function togglePasswordReset(){const card=document.getElementById('passwordResetCard');card.style.display=card.style.display==='none'?'block':'none';}
const newPassword=document.getElementById('newPassword'),confirmPassword=document.getElementById('confirmPassword');
function validateResetPassword(){const mismatch=confirmPassword.value!==''&&newPassword.value!==confirmPassword.value;confirmPassword.setCustomValidity(mismatch?'Passwords do not match.':'');document.getElementById('passwordMismatch').style.display=mismatch?'block':'none';}
newPassword.addEventListener('input',validateResetPassword);confirmPassword.addEventListener('input',validateResetPassword);
<% if (request.getParameter("passwordError") != null || request.getParameter("passwordReset") != null) { %>document.getElementById('passwordResetCard').style.display='block';<% } %>
</script>
</body>
</html>
