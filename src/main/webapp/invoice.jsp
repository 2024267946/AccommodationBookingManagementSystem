<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Booking,model.Payment,model.Guest,java.time.LocalDate,java.time.temporal.ChronoUnit" %>
<%
Booking booking=(Booking)request.getAttribute("booking"); Payment payment=(Payment)request.getAttribute("payment"); Guest guest=(Guest)session.getAttribute("loggedGuest");
if(booking==null||payment==null||guest==null){response.sendRedirect(request.getContextPath()+"/profile?error=invoiceNotFound");return;}
long nights=ChronoUnit.DAYS.between(LocalDate.parse(booking.getCheckInDate()),LocalDate.parse(booking.getCheckOutDate()));
%>
<!DOCTYPE html><html><head><meta charset="UTF-8"><title>Invoice <%= booking.getBookingID() %></title><jsp:include page="header.jsp" /></head>
<body class="invoice-page-body"><jsp:include page="navbar.jsp" />
<div class="container" style="max-width:800px;margin:40px auto;">
<div class="no-print" style="margin-bottom:1.5rem;display:flex;justify-content:space-between;"><a href="${pageContext.request.contextPath}/profile" class="btn-clear" style="text-decoration:none;">&larr; Back to Profile</a><button onclick="window.print()" class="btn-primary">Print / Save PDF</button></div>
<div class="invoice-card"><div class="invoice-header"><div><h2 style="color:var(--primary-color);">Cuti Murah Melaka</h2><p class="text-muted">Melaka, Malaysia</p></div><div style="text-align:right;"><h2>INVOICE</h2><p><strong>Invoice:</strong> <%= payment.getPaymentID() %></p><p><strong>Booking:</strong> <%= booking.getBookingID() %></p><p><strong>Issue Date:</strong> <%= payment.getPaymentDate() %></p></div></div>
<div class="invoice-body"><div class="invoice-customer"><h3>Billed To:</h3><p style="font-weight:bold;"><%= guest.getGuestName() %></p><p><%= guest.getGuestEmail() %></p><p><%= guest.getGuestPhoneNumber() %></p></div>
<table class="data-table" style="margin-top:2rem;width:100%;"><thead><tr><th>Description</th><th>Dates</th><th>Nights</th><th>Guests</th><th style="text-align:right;">Amount</th></tr></thead><tbody><tr><td><%= booking.getAccommodationName() %> (<%= booking.getAccommodationID() %>)</td><td><%= booking.getCheckInDate() %> - <%= booking.getCheckOutDate() %></td><td><%= nights %></td><td><%= booking.getNumberOfPax() %></td><td style="text-align:right;">RM <%= String.format("%.2f",payment.getTotalAmount()) %></td></tr></tbody></table>
<div class="invoice-total"><p><strong>Payment Method:</strong> <%= payment.getPaymentMethod() %></p><p><strong>Payment Status:</strong> <%= payment.getPaymentStatus() %></p><p><strong>Total Amount:</strong> <span class="price">RM <%= String.format("%.2f",payment.getTotalAmount()) %></span></p></div><div style="text-align:center;margin-top:4rem;color:var(--text-muted);"><p>Thank you for choosing Cuti Murah Melaka!</p></div></div></div></div></body></html>
