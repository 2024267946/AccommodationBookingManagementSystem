<%@ page import="java.util.List" %>
<%@ page import="model.Accommodation" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    List<Accommodation> accommodationList =
        (List<Accommodation>) request.getAttribute("accommodationList");

    String message = (String) request.getAttribute("message");
    String checkIn = (String) request.getAttribute("checkIn");
    String checkOut = (String) request.getAttribute("checkOut");
    String pax = (String) request.getAttribute("pax");

    if (checkIn == null) checkIn = "";
    if (checkOut == null) checkOut = "";
    if (pax == null) pax = "";
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Search Availability | Cuti Murah Melaka</title>

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

<jsp:include page="guestNavbar.jsp" />

<main class="availability-page">

    <section class="page-intro">
        <span class="page-eyebrow">Find Your Stay</span>
        <h1>Search Availability</h1>
        <p>
            Select your travel dates and number of guests to view
            homestays that are available for your stay.
        </p>
    </section>

    <% if (message != null) { %>
        <div class="message"><%= message %></div>
    <% } %>

    <section class="search-card">

        <form action="${pageContext.request.contextPath}/SearchAvailabilityServlet"
              method="get"
              class="search-form">

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
                               href="${pageContext.request.contextPath}/booking.jsp?id=<%= acc.getAccommodationId() %>&checkIn=<%= checkIn %>&checkOut=<%= checkOut %>&pax=<%= pax %>&price=<%= acc.getPricePerNight() %>">
                                Book Now
                            </a>

                        </div>

                    </article>

                <% } %>

            </div>

        <% } %>

    <% } %>

</main>

</body>
</html>