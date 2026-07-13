<%@ page import="java.util.List" %>
<%@ page import="model.Accommodation" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    List<Accommodation> accommodationList =
        (List<Accommodation>) request.getAttribute("accommodationList");
    Accommodation accommodationChosen =
        (Accommodation) request.getAttribute("accomodationChoosen");

    String selectedAccommodationId = request.getParameter("id");
    String availability = request.getParameter("availability");
    String bookingError = request.getParameter("error");

    String message = (String) request.getAttribute("message");
    String checkIn = (String) request.getAttribute("checkIn");
    String checkOut = (String) request.getAttribute("checkOut");
    String pax = (String) request.getAttribute("pax");

    if (checkIn == null) checkIn = request.getParameter("checkIn");
    if (checkOut == null) checkOut = request.getParameter("checkOut");
    if (pax == null) pax = request.getParameter("pax");

    if (checkIn == null) checkIn = "";
    if (checkOut == null) checkOut = "";
    if (pax == null) pax = "";
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Check Availability | Cuti Murah Melaka</title>

    <jsp:include page="guestHeader.jsp" />

    <style>
        body {
            margin: 0;
            background:
                linear-gradient(rgba(246, 242, 235, 0.94), rgba(246, 242, 235, 0.94)),
                url("${pageContext.request.contextPath}/images/cmm2.jpg") center/cover fixed;
            color: #1e2f2a;
        }

        .availability-page {
            max-width: 1180px;
            margin: 0 auto;
            padding: 52px 24px 70px;
        }

        .page-intro {
            margin-bottom: 28px;
            text-align: center;
        }

        .page-eyebrow {
            display: inline-block;
            margin-bottom: 10px;
            color: #6f7d77;
            font-size: 12px;
            font-weight: 700;
            letter-spacing: 0.18em;
            text-transform: uppercase;
        }

        .page-intro h1 {
            margin: 0 0 12px;
            color: #123a30;
            font-family: "Playfair Display", Georgia, serif;
            font-size: clamp(34px, 5vw, 54px);
        }

        .page-intro p {
            max-width: 660px;
            margin: 0 auto;
            color: #6b6a66;
            font-size: 16px;
            line-height: 1.7;
        }

        .search-card {
            margin-bottom: 36px;
            padding: 28px;
            background: rgba(255, 255, 255, 0.96);
            border: 1px solid #e3dbd1;
            border-radius: 18px;
            box-shadow: 0 10px 28px rgba(15, 45, 36, 0.08);
        }

        .search-form {
            display: grid;
            grid-template-columns: repeat(3, minmax(0, 1fr)) auto;
            gap: 18px;
            align-items: end;
        }

        .form-group label {
            display: block;
            margin-bottom: 9px;
            color: #263b34;
            font-size: 14px;
            font-weight: 700;
        }

        .form-control {
            width: 100%;
            min-height: 50px;
            box-sizing: border-box;
            padding: 12px 14px;
            border: 1px solid #d9d0c6;
            border-radius: 10px;
            background: #fff;
            color: #222;
            font: inherit;
            outline: none;
        }

        .form-control:focus {
            border-color: #0e5a46;
            box-shadow: 0 0 0 4px rgba(14, 90, 70, 0.10);
        }

        .btn-search,
        .btn-book {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            min-height: 50px;
            padding: 0 24px;
            border: 0;
            border-radius: 9px;
            background: #003d2f;
            color: #fff;
            font: inherit;
            font-size: 13px;
            font-weight: 800;
            letter-spacing: 0.08em;
            text-decoration: none;
            text-transform: uppercase;
            cursor: pointer;
        }

        .btn-search:hover,
        .btn-book:hover {
            background: #0a5945;
            color: #fff;
        }

        .message {
            margin-bottom: 24px;
            padding: 15px 18px;
            border: 1px solid #ead5a5;
            border-radius: 10px;
            background: #fff8e5;
            color: #7a5b17;
            font-weight: 600;
        }

        .results-heading {
            display: flex;
            align-items: flex-end;
            justify-content: space-between;
            gap: 20px;
            margin-bottom: 22px;
        }

        .results-heading h2 {
            margin: 0;
            color: #123a30;
            font-family: "Playfair Display", Georgia, serif;
            font-size: 31px;
        }

        .results-heading span {
            color: #7b756e;
            font-size: 14px;
            font-weight: 600;
        }

        .result-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(290px, 1fr));
            gap: 24px;
        }

        .accommodation-card {
            display: flex;
            flex-direction: column;
            overflow: hidden;
            min-height: 100%;
            background: rgba(255, 255, 255, 0.98);
            border: 1px solid #e3dbd1;
            border-radius: 16px;
            box-shadow: 0 8px 24px rgba(15, 45, 36, 0.07);
        }

        .card-image {
            height: 210px;
            background:
                linear-gradient(rgba(5, 35, 28, 0.08), rgba(5, 35, 28, 0.08)),
                url("${pageContext.request.contextPath}/images/cmm3.jpg") center/cover;
        }

        .card-body {
            display: flex;
            flex: 1;
            flex-direction: column;
            padding: 24px;
        }

        .card-type {
            margin-bottom: 7px;
            color: #6d7a75;
            font-size: 11px;
            font-weight: 800;
            letter-spacing: 0.16em;
            text-transform: uppercase;
        }

        .accommodation-card h3 {
            margin: 0 0 14px;
            color: #123a30;
            font-family: "Playfair Display", Georgia, serif;
            font-size: 25px;
        }

        .details-grid {
            display: grid;
            gap: 9px;
            margin-bottom: 15px;
        }

        .info {
            color: #625f5a;
            font-size: 14px;
            line-height: 1.55;
        }

        .info strong {
            color: #273b34;
        }

        .description {
            flex: 1;
            margin: 4px 0 18px;
            color: #77716a;
            font-size: 14px;
            line-height: 1.65;
        }

        .price {
            margin: 4px 0 18px;
            color: #0c6049;
            font-size: 23px;
            font-weight: 800;
        }

        .price small {
            color: #77716a;
            font-size: 13px;
            font-weight: 500;
        }

        .btn-book {
            width: 100%;
        }

        .empty {
            padding: 44px 24px;
            border: 1px dashed #d6ccc0;
            border-radius: 16px;
            background: rgba(255, 255, 255, 0.95);
            color: #6f6b66;
            text-align: center;
        }

        .empty h3 {
            margin: 0 0 8px;
            color: #173f34;
        }

        .availability-modal {
            position: fixed;
            z-index: 3000;
            inset: 0;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 24px;
            background: rgba(8, 28, 22, 0.62);
            backdrop-filter: blur(5px);
        }

        .availability-modal-card {
            width: min(460px, 100%);
            padding: 38px 34px 32px;
            border: 1px solid rgba(255, 255, 255, 0.7);
            border-radius: 22px;
            background: #fffdf9;
            box-shadow: 0 24px 70px rgba(4, 30, 22, 0.28);
            text-align: center;
            animation: modal-enter 0.24s ease-out;
        }

        .availability-modal-icon {
            display: flex;
            align-items: center;
            justify-content: center;
            width: 70px;
            height: 70px;
            margin: 0 auto 22px;
            border-radius: 50%;
            font-size: 32px;
            font-weight: 800;
        }

        .availability-modal-icon.available {
            background: #e5f7ee;
            color: #08734f;
        }

        .availability-modal-icon.unavailable {
            background: #fff0ed;
            color: #b33c2f;
        }

        .availability-modal-card h2 {
            margin: 0 0 12px;
            color: #123a30;
            font-family: "Playfair Display", Georgia, serif;
            font-size: 30px;
        }

        .availability-modal-card p {
            margin: 0 0 26px;
            color: #6f6b66;
            line-height: 1.65;
        }

        .modal-action {
            width: 100%;
        }

        @keyframes modal-enter {
            from { opacity: 0; transform: translateY(14px) scale(0.97); }
            to { opacity: 1; transform: translateY(0) scale(1); }
        }

        @media (max-width: 900px) {
            .search-form {
                grid-template-columns: repeat(2, minmax(0, 1fr));
            }

            .btn-search {
                width: 100%;
            }
        }

        @media (max-width: 620px) {
            .availability-page {
                padding: 34px 16px 55px;
            }

            .search-card {
                padding: 22px;
            }

            .search-form {
                grid-template-columns: 1fr;
            }

            .results-heading {
                align-items: flex-start;
                flex-direction: column;
            }
        }
    </style>
</head>

<body>

<jsp:include page="navbar.jsp" />

<main class="availability-page">

    <section class="page-intro">
        <span class="page-eyebrow">Find Your Stay</span>
        <h1>Check Availability</h1>
        <p>
            Select your travel dates and number of guests to view
            homestays that are available for your stay.
        </p>
    </section>

    <% if (message != null) { %>
        <div class="message"><%= message %></div>
    <% } %>

    <section class="search-card">

        <form action="${pageContext.request.contextPath}/homestays/search"
              method="get"
              class="search-form">

            <% if (selectedAccommodationId != null
                    && !selectedAccommodationId.trim().isEmpty()) { %>
                <input type="hidden" name="id" value="<%= selectedAccommodationId %>">
            <% } %>

            <div class="form-group">
                <label for="checkIn">Check-in Date</label>
                <input id="checkIn"
                       type="date"
                       name="checkIn"
                       value="<%= checkIn %>"
                       class="form-control"
                       required>
            </div>

            <div class="form-group">
                <label for="checkOut">Check-out Date</label>
                <input id="checkOut"
                       type="date"
                       name="checkOut"
                       value="<%= checkOut %>"
                       class="form-control"
                       required>
            </div>

            <div class="form-group">
                <label for="pax">Number of Guests</label>
                <input id="pax"
                       type="number"
                       name="pax"
                       min="1"
                       value="<%= pax %>"
                       class="form-control"
                       required>
            </div>

            <button type="submit" class="btn-search">
                Search
            </button>

        </form>

    </section>

    <% if (selectedAccommodationId != null && accommodationChosen != null) { %>
        <div class="results-heading">
            <h2>Selected Homestay</h2>
            <span>Checking this accommodation</span>
        </div>

        <div class="result-grid" id="selected-accommodation">
            <article class="accommodation-card">
                <div class="card-image"></div>
                <div class="card-body">
                    <div class="card-type"><%= accommodationChosen.getAccommodationType() %></div>
                    <h3><%= accommodationChosen.getAccommodationName() %></h3>
                    <div class="details-grid">
                        <div class="info"><strong>Accommodation ID:</strong> <%= accommodationChosen.getAccommodationId() %></div>
                        <div class="info"><strong>Location:</strong> <%= accommodationChosen.getLocation() %></div>
                        <div class="info"><strong>Maximum Capacity:</strong> <%= accommodationChosen.getMaxCapacity() %> guests</div>
                    </div>
                    <div class="description">
                        <%= accommodationChosen.getDescription() == null
                                ? "No description available."
                                : accommodationChosen.getDescription() %>
                    </div>
                    <div class="price">
                        RM <%= String.format("%.2f", accommodationChosen.getPricePerNight()) %>
                        <small>/ night</small>
                    </div>
                </div>
            </article>
        </div>
    <% } %>

    <% if (accommodationList != null) { %>

        <% if (accommodationList.isEmpty()) { %>

            <div class="empty">
                <h3>No accommodation available</h3>
                <p>Please try another date or reduce the number of guests.</p>
            </div>

        <% } else { %>

            <div class="results-heading">
                <h2>Available Homestays</h2>
                <span><%= accommodationList.size() %> result(s) found</span>
            </div>

            <div class="result-grid">

                <% for (Accommodation acc : accommodationList) { %>

                    <article class="accommodation-card">

                        <div class="card-image"></div>

                        <div class="card-body">

                            <div class="card-type">
                                <%= acc.getAccommodationType() %>
                            </div>

                            <h3>
                                <%= acc.getAccommodationName() %>
                            </h3>

                            <div class="details-grid">

                                <div class="info">
                                    <strong>Accommodation ID:</strong>
                                    <%= acc.getAccommodationId() %>
                                </div>

                                <div class="info">
                                    <strong>Location:</strong>
                                    <%= acc.getLocation() %>
                                </div>

                                <div class="info">
                                    <strong>Maximum Capacity:</strong>
                                    <%= acc.getMaxCapacity() %> guests
                                </div>

                            </div>

                            <div class="description">
                                <%= acc.getDescription() == null
                                        ? "No description available."
                                        : acc.getDescription() %>
                            </div>

                            <div class="price">
                                RM <%= String.format("%.2f",
                                        acc.getPricePerNight()) %>
                                <small>/ night</small>
                            </div>

                            <a class="btn-book"
                               href="${pageContext.request.contextPath}/booking?id=<%= acc.getAccommodationId() %>&checkIn=<%= checkIn %>&checkOut=<%= checkOut %>&pax=<%= pax %>">
                                Book Now
                            </a>

                        </div>

                    </article>

                <% } %>

            </div>

        <% } %>

    <% } %>

</main>

<% if (availability != null && accommodationChosen != null) {
       boolean isAvailable = "true".equalsIgnoreCase(availability);
%>
<div class="availability-modal" id="availability-result-modal" role="dialog" aria-modal="true" aria-labelledby="availability-result-title">
    <div class="availability-modal-card">
        <div class="availability-modal-icon <%= isAvailable ? "available" : "unavailable" %>">
            <%= isAvailable ? "&#10003;" : "&#10005;" %>
        </div>
        <h2 id="availability-result-title">
            <%= isAvailable ? "Your Stay Is Available" : "Dates Not Available" %>
        </h2>
        <p>
            <%= isAvailable
                    ? "Great news! This accommodation is available for your selected dates. Continue to complete your booking."
                    : "This accommodation is unavailable for part of your selected date range. Please choose different dates and try again." %>
        </p>
        <% if (isAvailable) { %>
            <a class="btn-book modal-action"
               href="<%= request.getContextPath() %>/booking?id=<%= accommodationChosen.getAccommodationId() %>&checkIn=<%= checkIn %>&checkOut=<%= checkOut %>&pax=<%= pax %>">
                Continue to Booking
            </a>
        <% } else { %>
            <button type="button" class="btn-search modal-action" id="close-availability-modal">
                Choose Different Dates
            </button>
        <% } %>
    </div>
</div>
<% if (!isAvailable) { %>
<script>
    document.getElementById("close-availability-modal").addEventListener("click", function () {
        document.getElementById("availability-result-modal").remove();
    });
</script>
<% } %>
<% } %>

<% if ("bookingFailed".equals(bookingError)) { %>
<div class="availability-modal" id="booking-error-modal" role="dialog" aria-modal="true" aria-labelledby="booking-error-title">
    <div class="availability-modal-card">
        <div class="availability-modal-icon unavailable">!</div>
        <h2 id="booking-error-title">Something Went Wrong</h2>
        <p>
            We couldn’t create your booking. Your selected accommodation and dates have been kept, so you can review them and try again.
        </p>
        <button type="button" class="btn-search modal-action" id="close-booking-error-modal">
            Review Search
        </button>
    </div>
</div>
<script>
    document.getElementById("close-booking-error-modal").addEventListener("click", function () {
        document.getElementById("booking-error-modal").remove();
    });
</script>
<% } %>

</body>
</html>
