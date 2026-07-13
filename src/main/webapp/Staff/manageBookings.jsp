<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.Booking" %>
<%
List<Booking> masterBookingsList =
        (List<Booking>) request.getAttribute("masterBookingsList");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Booking Verification Pipeline - Cuti Murah Melaka</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/theme.css">
</head>
<body class="admin-body">
<jsp:include page="StaffNavbar.jsp" />
    <div class="admin-layout">

      <jsp:include page="StaffSidebar.jsp" />

      <main class="main-content">
        <div class="container">

          <div class="page-header">
            <h1>Booking Management</h1>
            <p class="text-muted">Review, track, and verify upcoming homestay reservations.</p>
          </div>

          <div class="table-card">
            <div class="table-header">
              <h2>Pending &amp; Past Reservations</h2>
            </div>

            <div class="table-responsive">
              <table class="data-table">
                <thead>
                  <tr>
                    <th>Booking ID</th>
                    <th>Guest ID</th>
                    <th>Accommodation ID</th>
                    <th>Check-In</th>
                    <th>Check-Out</th>
                    <th>Amount</th>
                    <th>Status</th>
                    <th class="text-center">Actions</th>
                  </tr>
                </thead>
                <tbody>
                <% if (masterBookingsList != null && !masterBookingsList.isEmpty()) {
                    for (Booking booking : masterBookingsList) {
                        boolean pending = "PENDING".equalsIgnoreCase(booking.getBookingStatus());
                %>
                  <tr>
                    <td class="font-medium"><%= booking.getBookingID() %></td>
                    <td><%= booking.getGuestID() %></td>
                    <td><%= booking.getAccommodationID() %></td>
                    <td><%= booking.getCheckInDate() %></td>
                    <td><%= booking.getCheckOutDate() %></td>
                    <td class="font-medium" style="color: var(--primary-color);">RM <%= String.format("%.2f", booking.getTotalPrice()) %></td>
                    <td><span class="badge-status-pending" style="font-weight:600; padding: 4px 10px; border-radius: 20px; font-size: 0.75rem;"><%= booking.getBookingStatus() %></span></td>
                    <td class="text-center">
                      <% if (pending) { %>
                      <form action="${pageContext.request.contextPath}/staff/booking/verify" method="POST" style="margin:0;">
                        <input type="hidden" name="bookingID" value="<%= booking.getBookingID() %>">
                        <button type="submit" class="btn-primary" style="padding: 8px 16px; font-size: 0.8rem; border-radius: 8px !important;">
                            Verify
                        </button>
                      </form>
                      <% } else { %>
                        <span class="text-muted">—</span>
                      <% } %>
                    </td>
                  </tr>
                <%  }
                   } else { %>
                  <tr>
                    <td colspan="8" class="text-center text-muted">No bookings available.</td>
                  </tr>
                <% } %>
                </tbody>
              </table>
            </div>
          </div>

        </div>
      </main>
    </div>
</body>
</html>
