<%@ page import="java.util.List" %>
<%@ page import="dao.AvailabilityDAO" %>
<%@ page import="model.Accommodation" %>

<%
    String checkIn = request.getParameter("checkIn");
    String checkOut = request.getParameter("checkOut");
    String paxParam = request.getParameter("pax");

    List<Accommodation> accommodationList = null;

    if (checkIn != null && checkOut != null && paxParam != null &&
        !checkIn.trim().equals("") && !checkOut.trim().equals("") && !paxParam.trim().equals("")) {

        int pax = Integer.parseInt(paxParam);

        AvailabilityDAO dao = new AvailabilityDAO();
        accommodationList = dao.searchAvailability(checkIn, checkOut, pax);
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Search Availability | Cuti Murah Melaka</title>
    <link rel="stylesheet" href="css/searchAvailability.css">
</head>

<body>

<header class="navbar">
    <div class="logo">Cuti Murah Melaka</div>

    <nav>
        <a href="index.jsp">Home</a>
        <a href="searchAvailability.jsp" class="active">Search Availability</a>
        <a href="myBooking.jsp">My Bookings</a>
        <a href="account.jsp">Account</a>
        <a href="logout.jsp">Logout</a>
    </nav>
</header>

<section class="hero">
    <div class="hero-content">
        <h1>Find Your Perfect Escape</h1>
        <p>Search available homestay and chalet in Melaka</p>
    </div>
</section>

<section class="search-box">
    <form action="searchAvailability.jsp" method="get" class="search-form">

        <div class="form-group">
            <label>Check-in</label>
            <input type="date" name="checkIn"
                   value="<%= checkIn != null ? checkIn : "" %>" required>
        </div>

        <div class="form-group">
            <label>Check-out</label>
            <input type="date" name="checkOut"
                   value="<%= checkOut != null ? checkOut : "" %>" required>
        </div>

        <div class="form-group">
            <label>Number of Pax</label>
            <input type="number" name="pax" min="1"
                   value="<%= paxParam != null ? paxParam : "2" %>" required>
        </div>

        <button type="submit" class="search-btn">
            Check Availability
        </button>

    </form>
</section>

<main class="container">

    <h2>Available Accommodation</h2>

    <%
        if (accommodationList == null) {
    %>

        <div class="message-box">
            Please select check-in date, check-out date, and number of pax.
        </div>

    <%
        } else if (accommodationList.isEmpty()) {
    %>

        <div class="message-box">
            No available accommodation found for your selected date.
        </div>

    <%
        } else {
    %>

    <div class="card-grid">

        <%
            for (Accommodation acc : accommodationList) {
        %>

        <div class="card">

            <div class="card-image">
                <img src="images/accommodation-default.jpg" alt="Accommodation Image">

                <span class="location-badge">
                    <%= acc.getLocation() %>
                </span>

                <span class="type-badge">
                    <%= acc.getAccommodationType() %>
                </span>
            </div>

            <div class="card-body">

                <h3><%= acc.getAccommodationType() %></h3>

                <p class="description">
                    <%= acc.getDescription() != null ? acc.getDescription() : "Comfortable stay in Melaka." %>
                </p>

                <div class="info-row">
                    <span>Up to <%= acc.getMaxCapacity() %> Guests</span>

                    <span class="price">
                        RM<%= String.format("%.2f", acc.getPricePerNight()) %>
                    </span>
                </div>

                <a class="book-btn"
                   href="booking.jsp?accommodationId=<%= acc.getAccommodationId() %>&checkIn=<%= checkIn %>&checkOut=<%= checkOut %>&pax=<%= paxParam %>">
                    Book Now
                </a>

            </div>

        </div>

        <%
            }
        %>

    </div>

    <%
        }
    %>

</main>

<footer class="footer">
    <div>
        <h2>Cuti Murah Melaka</h2>
        <p>Affordable homestay and chalet booking in Melaka.</p>
    </div>

    <div>
        <h3>Contact Us</h3>
        <p>Jasin, Melaka, Malaysia</p>
        <p>+60 12-345 6789</p>
        <p>info@cutimurahmelaka.com</p>
    </div>
</footer>

</body>
</html>