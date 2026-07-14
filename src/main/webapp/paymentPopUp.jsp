<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.time.LocalDate" %>

<%
    String bookingID =
            (String) session.getAttribute("bookingID");

    Double totalAmount =
            (Double) session.getAttribute("totalAmount");

    String accommodationID =
            (String) session.getAttribute("selectedAccommodationID");

    String checkIn =
            (String) session.getAttribute("bookingCheckIn");

    String checkOut =
            (String) session.getAttribute("bookingCheckOut");

    Integer numberOfPax =
            (Integer) session.getAttribute("bookingPax");

    if (bookingID == null || totalAmount == null) {
        response.sendRedirect(
                request.getContextPath()
                + "/Homepage.jsp?payment=failed&reason=noBooking");
        return;
    }

    String paymentDate = LocalDate.now().toString();
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Secure Payment | Cuti Murah Melaka</title>

    <jsp:include page="guestHeader.jsp" />

    <style>
        body {
            margin: 0;
            background:
                linear-gradient(rgba(246, 242, 235, 0.94), rgba(246, 242, 235, 0.94)),
                url("${pageContext.request.contextPath}/images/cmm2.jpg") center/cover fixed;
        }

        .payment-page {
            max-width: 760px;
            margin: 0 auto;
            padding: 55px 20px 75px;
        }

        .payment-card {
            overflow: hidden;
            background: rgba(255, 255, 255, 0.98);
            border: 1px solid #e1d8ce;
            border-radius: 18px;
            box-shadow: 0 12px 32px rgba(15, 45, 36, 0.10);
        }

        .payment-header {
            padding: 34px 36px 25px;
            border-bottom: 1px solid #e8e0d7;
            text-align: center;
        }

        .payment-header span {
            color: #6b7973;
            font-size: 11px;
            font-weight: 800;
            letter-spacing: 0.17em;
            text-transform: uppercase;
        }

        .payment-header h1 {
            margin: 8px 0 8px;
            color: #123a30;
            font-family: "Playfair Display", Georgia, serif;
            font-size: 38px;
        }

        .payment-header p {
            margin: 0;
            color: #77716a;
        }

        .payment-body {
            padding: 30px 36px 36px;
        }

        .booking-summary {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 14px;
            margin-bottom: 28px;
        }

        .summary-item {
            padding: 15px 17px;
            background: #f7f4ef;
            border: 1px solid #e5ddd3;
            border-radius: 10px;
        }

        .summary-item small {
            display: block;
            margin-bottom: 5px;
            color: #7a756f;
            font-size: 11px;
            font-weight: 700;
            letter-spacing: 0.08em;
            text-transform: uppercase;
        }

        .summary-item strong {
            color: #203a32;
        }

        .amount-box {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 20px;
            margin-bottom: 28px;
            padding: 20px;
            background: #ecf4f0;
            border: 1px solid #cfe0d8;
            border-radius: 12px;
        }

        .amount-box span {
            color: #49635a;
            font-weight: 600;
        }

        .amount-box strong {
            color: #003d2f;
            font-size: 27px;
        }

        .payment-form input {
            width: 100%;
            box-sizing: border-box;
        }

        .pay-button {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 100%;
            min-height: 54px;
            border: 0;
            border-radius: 9px;
            background: #003d2f;
            color: #ffffff;
            font: inherit;
            font-size: 13px;
            font-weight: 800;
            letter-spacing: 0.10em;
            text-transform: uppercase;
            cursor: pointer;
        }

        .pay-button:hover {
            background: #0a5945;
        }

        .back-link {
            display: block;
            margin-top: 17px;
            color: #536c63;
            text-align: center;
            text-decoration: none;
        }

        .error-message {
            margin-bottom: 22px;
            padding: 14px 17px;
            color: #a61b1b;
            background: #fff0f0;
            border: 1px solid #f1baba;
            border-radius: 9px;
            font-weight: 600;
        }

        @media (max-width: 600px) {
            .booking-summary {
                grid-template-columns: 1fr;
            }

            .payment-header,
            .payment-body {
                padding-right: 22px;
                padding-left: 22px;
            }

            .amount-box {
                align-items: flex-start;
                flex-direction: column;
            }
        }
    </style>
</head>

<body>

<jsp:include page="navbar.jsp" />

<main class="payment-page">

    <section class="payment-card">

        <div class="payment-header">
            <span>Secure Checkout</span>
            <h1>Confirm Payment</h1>
            <p>Confirm the amount below before continuing to ToyyibPay.</p>
        </div>

        <div class="payment-body">

            <% if ("toyyibpay".equals(request.getParameter("error"))) { %>
                <div class="error-message">
                    Unable to connect to ToyyibPay. Please try again.
                </div>
            <% } %>

            <div class="booking-summary">

                <div class="summary-item">
                    <small>Booking ID</small>
                    <strong><%= bookingID %></strong>
                </div>

                <div class="summary-item">
                    <small>Accommodation</small>
                    <strong><%= accommodationID == null ? "-" : accommodationID %></strong>
                </div>

                <div class="summary-item">
                    <small>Check-in</small>
                    <strong><%= checkIn == null ? "-" : checkIn %></strong>
                </div>

                <div class="summary-item">
                    <small>Check-out</small>
                    <strong><%= checkOut == null ? "-" : checkOut %></strong>
                </div>

                <div class="summary-item">
                    <small>Guests</small>
                    <strong><%= numberOfPax == null ? "-" : numberOfPax %></strong>
                </div>

                <div class="summary-item">
                    <small>Payment Date</small>
                    <strong><%= paymentDate %></strong>
                </div>

            </div>

            <div class="amount-box">
                <span>Total payment</span>
                <strong>RM <%= String.format("%.2f", totalAmount) %></strong>
            </div>

            <form action="${pageContext.request.contextPath}/PaymentServlet"
                  method="post"
                  class="payment-form">

                <input type="hidden"
                       name="bookingID"
                       value="<%= bookingID %>">

                <input type="hidden"
                       name="totalAmount"
                       value="<%= String.format("%.2f", totalAmount) %>">

                <input type="hidden"
                       name="paymentDate"
                       value="<%= paymentDate %>">

                <button type="submit" class="pay-button">
                    Pay with ToyyibPay
                </button>

            </form>

            <a href="${pageContext.request.contextPath}/booking/pay?bookingID=<%= bookingID %>"
               class="back-link">
                Back to Invoice
            </a>

        </div>

    </section>

</main>

</body>
</html>
