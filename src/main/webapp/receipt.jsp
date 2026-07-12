<%@ page import="model.Booking" %>
<%@ page import="model.Guest" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    Booking booking = (Booking) request.getAttribute("booking");
    Guest guest = (Guest) session.getAttribute("loggedGuest");
    if (booking == null) {
        response.sendRedirect(request.getContextPath() + "/booking/my-booking?error=receiptNotFound");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Payment Receipt | Cuti Murah Melaka</title>
    <jsp:include page="guestHeader.jsp" />
    <style>
        .receipt-wrap{width:min(820px,92%);margin:45px auto 80px}.receipt-actions{display:flex;justify-content:space-between;margin-bottom:18px}.receipt-paper{background:#fff;border:1px solid #ded7ce;padding:42px;box-shadow:0 12px 35px rgba(15,45,36,.1)}.receipt-head{display:flex;justify-content:space-between;border-bottom:2px solid #123a30;padding-bottom:24px;margin-bottom:28px}.receipt-head h1{margin:0;color:#123a30}.receipt-head p{margin:5px 0;color:#777}.paid{display:inline-block;padding:7px 13px;border-radius:20px;background:#e8f6ed;color:#21683a;font-weight:800}.receipt-table{width:100%;border-collapse:collapse;margin-top:25px}.receipt-table td{padding:13px 6px;border-bottom:1px solid #eee}.receipt-table td:last-child{text-align:right;font-weight:700}.receipt-total{display:flex;justify-content:flex-end;font-size:24px;color:#0e5a46;margin-top:25px}.action-link{padding:11px 17px;background:#0e5a46;color:#fff;text-decoration:none;border:0;border-radius:6px;font-weight:800;cursor:pointer}.back-link{color:#0e5a46;text-decoration:none;font-weight:800}@media print{.no-print,.guest-user-nav{display:none!important}.receipt-wrap{width:100%;margin:0}.receipt-paper{box-shadow:none;border:0}}
    </style>
</head>
<body class="afterglow-luxury">
<jsp:include page="guestNavbar.jsp" />
<div class="receipt-wrap">
    <div class="receipt-actions no-print">
        <a class="back-link" href="${pageContext.request.contextPath}/booking/my-booking">&larr; Back to My Bookings</a>
        <button class="action-link" onclick="window.print()">Print Receipt</button>
    </div>

    <section class="receipt-paper">
        <div class="receipt-head">
            <div>
                <h1>Cuti Murah Melaka</h1>
                <p>Payment Receipt</p>
            </div>
            <div style="text-align:right">
                <span class="paid">PAID</span>
                <p><strong>Receipt:</strong> INV-<%= booking.getBookingID() %></p>
            </div>
        </div>

        <p><strong>Guest:</strong> <%= guest == null ? "Guest" : guest.getGuestName() %></p>
        <p><strong>Email:</strong> <%= guest == null ? "-" : guest.getGuestEmail() %></p>
        <p><strong>Booking ID:</strong> <%= booking.getBookingID() %></p>

        <table class="receipt-table">
            <tr><td>Accommodation ID</td><td><%= booking.getAccommodationID() %></td></tr>
            <tr><td>Check-in Date</td><td><%= booking.getCheckInDate() %></td></tr>
            <tr><td>Check-out Date</td><td><%= booking.getCheckOutDate() %></td></tr>
            <tr><td>Number of Guests</td><td><%= booking.getNumberOfPax() %></td></tr>
            <tr><td>Payment Method</td><td>ToyyibPay</td></tr>
            <tr><td>Payment Status</td><td>PAID</td></tr>
        </table>

        <div class="receipt-total"><strong>Total: RM <%= String.format("%.2f", booking.getTotalPrice()) %></strong></div>
        <p style="text-align:center;color:#777;margin-top:45px">Thank you for choosing Cuti Murah Melaka.</p>
    </section>
</div>
</body>
</html>
