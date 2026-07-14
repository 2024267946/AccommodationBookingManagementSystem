<%@ page import="java.util.List" %>
<%@ page import="model.Booking" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    List<Booking> bookingsList = (List<Booking>) request.getAttribute("bookingsList");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>My Bookings | Cuti Murah Melaka</title>
    <jsp:include page="guestHeader.jsp" />
    <style>
        .booking-page { width:min(1120px, 92%); margin:45px auto 80px; }
        .booking-page h1 { color:#123a30; font-family:"Playfair Display", Georgia, serif; font-size:44px; margin-bottom:8px; }
        .booking-page .subtitle { color:#77716a; margin-bottom:30px; }
        .success-message { padding:15px 18px; margin-bottom:24px; background:#eaf7ef; border:1px solid #afd7bd; color:#23633a; border-radius:10px; font-weight:700; }
        .booking-card { background:#fff; border:1px solid #e3dbd1; border-radius:16px; padding:24px; margin-bottom:20px; box-shadow:0 8px 24px rgba(15,45,36,.07); }
        .booking-top { display:flex; justify-content:space-between; gap:20px; align-items:flex-start; }
        .booking-id { color:#123a30; font-size:22px; margin:0 0 10px; }
        .status { padding:7px 13px; border-radius:20px; background:#eef4f1; color:#0e5a46; font-size:12px; font-weight:800; text-transform:uppercase; }
        .booking-details { display:grid; grid-template-columns:repeat(4,minmax(0,1fr)); gap:16px; margin:20px 0; }
        .booking-details small { display:block; color:#8a837b; margin-bottom:5px; }
        .booking-details strong { color:#263b34; }
        .booking-actions { display:flex; gap:12px; flex-wrap:wrap; }
        .receipt-btn, .cancel-btn { display:inline-flex; align-items:center; justify-content:center; min-height:42px; padding:0 18px; border-radius:7px; font-weight:800; text-decoration:none; border:0; cursor:pointer; }
        .receipt-btn { background:#0e5a46; color:#fff; }
        .cancel-btn { background:#f7eeee; color:#9b2f2f; }
        .empty-box { padding:50px; background:#fff; border:1px solid #e3dbd1; border-radius:16px; text-align:center; }
        @media(max-width:800px){ .booking-details{grid-template-columns:repeat(2,1fr);} }
    </style>
</head>
<body class="afterglow-luxury">
<jsp:include page="navbar.jsp" />

<main class="booking-page">
    <h1>My Bookings</h1>
    <p class="subtitle">View your booking status, payment information and receipt.</p>

    <% if ("success".equals(request.getParameter("payment"))) { %>
        <div class="success-message">Payment successful. Your booking has been recorded.</div>
    <% } %>
    <% if ("created".equals(request.getParameter("booking"))) { %>
        <div class="success-message">Booking submitted. Complete payment from the booking below when you are ready.</div>
    <% } %>

    <% if ("success".equals(request.getParameter("cancel"))) { %>
        <div class="success-message">Your booking has been cancelled successfully.</div>
    <% } else if ("failed".equals(request.getParameter("cancel"))) { %>
        <div class="message message-error">The booking could not be cancelled.</div>
    <% } %>

    <% if (bookingsList == null || bookingsList.isEmpty()) { %>
        <div class="empty-box">
            <h2>No booking found</h2>
            <p>You have not made any booking yet.</p>
            <a class="receipt-btn" href="${pageContext.request.contextPath}/homestays/search">Check Availability</a>
        </div>
    <% } else { %>
        <% for (Booking booking : bookingsList) { %>
            <section class="booking-card">
                <div class="booking-top">
                    <div>
                        <h2 class="booking-id">Booking <%= booking.getBookingID() %></h2>
                        <div>Accommodation ID: <strong><%= booking.getAccommodationID() %></strong></div>
                    </div>
                    <span class="status"><%= "PENDING".equalsIgnoreCase(booking.getBookingStatus())
                            ? "PENDING PAYMENT" : booking.getBookingStatus() %></span>
                </div>

                <div class="booking-details">
                    <div><small>Check-in</small><strong><%= booking.getCheckInDate() %></strong></div>
                    <div><small>Check-out</small><strong><%= booking.getCheckOutDate() %></strong></div>
                    <div><small>Guests</small><strong><%= booking.getNumberOfPax() %></strong></div>
                    <div><small>Total</small><strong>RM <%= String.format("%.2f", booking.getTotalPrice()) %></strong></div>
                </div>

                <div class="booking-actions">
                    <% if (!booking.isPaid() && "PENDING".equalsIgnoreCase(booking.getBookingStatus())) { %>
                        <a class="receipt-btn" href="${pageContext.request.contextPath}/booking/pay?bookingID=<%= booking.getBookingID() %>">Pay Now</a>
                    <% } else if (booking.isPaid()) { %>
                        <a class="receipt-btn" href="${pageContext.request.contextPath}/booking/receipt?bookingID=<%= booking.getBookingID() %>">View Receipt</a>
                    <% } %>

                    <% if (!"CANCELLED".equalsIgnoreCase(booking.getBookingStatus()) &&
                           !"COMPLETED".equalsIgnoreCase(booking.getBookingStatus())) { %>
                        <form action="${pageContext.request.contextPath}/booking/cancel-booking" method="POST" style="margin:0;">
                            <input type="hidden" name="bookingID" value="<%= booking.getBookingID() %>">
                            <button type="button" class="cancel-btn open-cancel-modal" data-booking-id="<%= booking.getBookingID() %>">Cancel</button>
                        </form>
                    <% } %>
                </div>
            </section>
        <% } %>
    <% } %>
</main>
<div id="cancelBookingModal" style="display:none;position:fixed;z-index:3000;inset:0;align-items:center;justify-content:center;padding:24px;background:rgba(8,28,22,.62);">
    <div style="width:min(420px,100%);padding:34px;border-radius:18px;background:#fff;text-align:center;box-shadow:0 24px 70px rgba(0,0,0,.22);">
        <h2 style="margin:0 0 10px;color:#123a30;">Cancel Booking?</h2><p style="color:#746f69;margin:0 0 24px;">Are you sure you want to cancel booking <strong id="cancelBookingIdText"></strong>?</p>
        <div style="display:flex;justify-content:center;gap:12px;"><button type="button" class="receipt-btn" id="closeCancelModal">Confirm</button><button type="button" class="cancel-btn" id="confirmCancelBooking">Cancel</button></div>
    </div>
</div>
<script>
const cancelModal=document.getElementById('cancelBookingModal');let cancelForm=null;
document.querySelectorAll('.open-cancel-modal').forEach(function(button){button.addEventListener('click',function(){cancelForm=button.closest('form');document.getElementById('cancelBookingIdText').textContent=button.dataset.bookingId;cancelModal.style.display='flex';});});
document.getElementById('closeCancelModal').addEventListener('click',function(){cancelModal.style.display='none';cancelForm=null;});
document.getElementById('confirmCancelBooking').addEventListener('click',function(){if(cancelForm)cancelForm.submit();});
cancelModal.addEventListener('click',function(event){if(event.target===cancelModal){cancelModal.style.display='none';cancelForm=null;}});
</script>
</body>
</html>
