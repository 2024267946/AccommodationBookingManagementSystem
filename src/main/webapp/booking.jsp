<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="model.Accommodation" %>
<%
    Accommodation bookingAccommodation =
            (Accommodation) request.getAttribute("bookingAccommodation");
    if (bookingAccommodation == null) {
        response.sendRedirect(request.getContextPath() + "/homestays/search");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Book Accommodation - Cuti Murah Melaka</title>
<jsp:include page="header.jsp" />

</head>
<body class="auth-body booking-page">
<style>
body.booking-page {
    padding-top: 0 !important;
}

body.booking-page .guest-user-nav,
body.booking-page .guest-top-nav,
body.booking-page .guest-top-nav .navbar {
    position: relative !important;
    top: auto !important;
    left: auto !important;
}
</style>
<jsp:include page="navbar.jsp" />
	<div class="container booking-container">
		<div class="auth-card" style="margin: 2rem auto;">
			<div class="auth-header">
				<h2>Complete Your Booking</h2>
				<p><%= bookingAccommodation.getAccommodationName() %></p>
			</div>

<form action="${pageContext.request.contextPath}/booking/create-booking"
      method="POST">

    <input type="hidden"
           name="accommodationID"
           value="<%= bookingAccommodation.getAccommodationId() %>">

    <div class="form-group">
        <label>Check-in Date</label>

        <input type="date"
               name="checkInDate"
               class="form-control"
               value="<%= request.getParameter("checkIn") %>"
               readonly
               required>
    </div>

    <div class="form-group">
        <label>Check-out Date</label>

        <input type="date"
               name="checkOutDate"
               class="form-control"
               value="<%= request.getParameter("checkOut") %>"
               readonly
               required>
    </div>

    <div class="form-group">
        <label>Number of Guests</label>

        <input type="number"
               name="numberOfPax"
               class="form-control"
               value="<%= request.getParameter("pax") %>"
               readonly
               required>
    </div>

    <button type="submit" class="btn-primary">
        Submit
    </button>

</form>
		</div>
	</div>
</body>
</html>
