<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Booking,model.Guest,java.time.LocalDate,java.time.temporal.ChronoUnit" %>
<%
Booking booking = (Booking) request.getAttribute("booking");
Guest guest = (Guest) session.getAttribute("loggedGuest");
if (booking == null || guest == null) {
    response.sendRedirect(request.getContextPath() + "/booking/my-booking?payment=invalid");
    return;
}
long nights = ChronoUnit.DAYS.between(
        LocalDate.parse(booking.getCheckInDate()), LocalDate.parse(booking.getCheckOutDate()));
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Review Invoice <%= booking.getBookingID() %></title>
    <jsp:include page="header.jsp" />
</head>
<body class="invoice-page-body">
<jsp:include page="navbar.jsp" />

<main class="container" style="max-width:800px;margin:40px auto;">
    <div style="margin-bottom:1.5rem;">
        <a href="${pageContext.request.contextPath}/booking/my-booking" class="btn-clear" style="text-decoration:none;">&larr; Back to My Bookings</a>
    </div>

    <% if ("toyyibpay".equals(request.getParameter("error"))) { %>
        <div class="message message-error">Unable to connect to ToyyibPay. Please try again.</div>
    <% } %>

    <div class="invoice-card">
        <div class="invoice-header">
            <div>
                <h2 style="color:var(--primary-color);">Cuti Murah Melaka</h2>
                <p class="text-muted">Melaka, Malaysia</p>
            </div>
            <div style="text-align:right;">
                <h2>INVOICE REVIEW</h2>
                <p><strong>Invoice:</strong> Pending Payment</p>
                <p><strong>Booking:</strong> <%= booking.getBookingID() %></p>
                <p><strong>Issue Date:</strong> <%= LocalDate.now() %></p>
            </div>
        </div>

        <div class="invoice-body">
            <div class="invoice-customer">
                <h3>Billed To:</h3>
                <p style="font-weight:bold;"><%= guest.getGuestName() %></p>
                <p><%= guest.getGuestEmail() %></p>
                <p><%= guest.getGuestPhoneNumber() %></p>
            </div>

            <table class="data-table" style="margin-top:2rem;width:100%;">
                <thead><tr><th>Description</th><th>Dates</th><th>Nights</th><th>Guests</th><th style="text-align:right;">Amount</th></tr></thead>
                <tbody><tr>
                    <td><%= booking.getAccommodationName() %> (<%= booking.getAccommodationID() %>)</td>
                    <td><%= booking.getCheckInDate() %> - <%= booking.getCheckOutDate() %></td>
                    <td><%= nights %></td>
                    <td><%= booking.getNumberOfPax() %></td>
                    <td style="text-align:right;">RM <%= String.format("%.2f", booking.getTotalPrice()) %></td>
                </tr></tbody>
            </table>

            <div class="invoice-total">
                <p><strong>Payment Method:</strong> ToyyibPay</p>
                <p><strong>Payment Status:</strong> PENDING PAYMENT</p>
                <p><strong>Total Amount:</strong> <span class="price">RM <%= String.format("%.2f", booking.getTotalPrice()) %></span></p>
            </div>

            <form action="${pageContext.request.contextPath}/booking/pay" method="get" style="margin-top:2rem;text-align:right;">
                <input type="hidden" name="bookingID" value="<%= booking.getBookingID() %>">
                <input type="hidden" name="step" value="confirm">
                <button type="submit" class="btn-primary" style="padding:14px 28px;">Proceed to Payment</button>
            </form>
        </div>
    </div>
</main>
</body>
</html>
