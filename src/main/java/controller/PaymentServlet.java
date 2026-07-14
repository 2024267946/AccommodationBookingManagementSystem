package controller;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.time.LocalDate;
import java.util.List;

import dao.BookingDAO;
import dao.PaymentDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Booking;
import model.Guest;
import model.Payment;

@WebServlet(urlPatterns = {"/PaymentServlet", "/PaymentCallbackServlet", "/PaymentReturnServlet", "/booking/pay", "/booking/receipt", "/booking/invoice"})
public class PaymentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final String SECRET_KEY = "qlp9i554-uc58-ej30-urd4-60ko8r3joprp";
    private static final String CATEGORY_CODE = "0b6zvz2n";
    private static final String MAIL_API_URL =
            "https://cutimurah-mail-api-e8045fc9b8a5.herokuapp.com/api/mail/send";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        switch (request.getServletPath()) {
            case "/PaymentReturnServlet": paymentReturn(request, response); break;
            case "/booking/pay": openPayment(request, response); break;
            case "/booking/receipt": receipt(request, response); break;
            case "/booking/invoice": invoice(request, response); break;
            default: response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if ("/PaymentCallbackServlet".equals(request.getServletPath())) {
            response.getWriter().write("OK");
        } else if ("/PaymentServlet".equals(request.getServletPath())) {
            startPayment(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
        }
    }

    private void startPayment(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("bookingID") == null
                || session.getAttribute("totalAmount") == null) {
            response.sendRedirect(request.getContextPath() + "/booking/my-booking?payment=invalid");
            return;
        }
        String bookingID = session.getAttribute("bookingID").toString();
        Guest guest = (Guest) session.getAttribute("loggedGuest");
        Booking booking = findGuestBooking(guest, bookingID);
        if (guest == null || booking == null) {
            response.sendRedirect(request.getContextPath() + "/booking/my-booking?payment=invalid");
            return;
        }
        double totalAmount = ((Number) session.getAttribute("totalAmount")).doubleValue();
        int amountInSen = (int) Math.round(totalAmount * 100);
        String baseUrl = request.getScheme() + "://" + request.getServerName() + ":"
                + request.getServerPort() + request.getContextPath();
        String params =
                "userSecretKey=" + enc(SECRET_KEY) + "&categoryCode=" + enc(CATEGORY_CODE)
                + "&billName=" + enc(booking.getAccommodationName() + " Booking")
                + "&billDescription=" + enc("Payment for " + booking.getAccommodationName()
                        + " (Booking " + bookingID + ")")
                + "&billPriceSetting=1&billPayorInfo=1&billAmount=" + amountInSen
                + "&billReturnUrl=" + enc(baseUrl + "/PaymentReturnServlet")
                + "&billCallbackUrl=" + enc(baseUrl + "/PaymentCallbackServlet")
                + "&billExternalReferenceNo=" + enc(bookingID)
                + "&billTo=" + enc(guest.getGuestName())
                + "&billEmail=" + enc(guest.getGuestEmail())
                + "&billPhone=" + enc(guest.getGuestPhoneNumber())
                + "&billSplitPayment=0&billPaymentChannel=0"
                + "&billContentEmail=" + enc("Thank you for payment.")
                + "&billChargeToCustomer=1";

        HttpURLConnection conn = (HttpURLConnection)
                new URL("https://dev.toyyibpay.com/index.php/api/createBill").openConnection();
        conn.setRequestMethod("POST");
        conn.setDoOutput(true);
        conn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
        try (OutputStream os = conn.getOutputStream()) {
            os.write(params.getBytes(java.nio.charset.StandardCharsets.UTF_8));
        }
        String result;
        try (BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream()))) {
            result = br.readLine();
        }
        if (result == null || !result.contains("BillCode")) {
            response.sendRedirect(request.getContextPath() + "/booking/pay?bookingID="
                    + enc(bookingID) + "&step=confirm&error=toyyibpay");
            return;
        }
        String billCode = result.split("\"BillCode\":\"")[1].split("\"")[0];
        response.sendRedirect("https://dev.toyyibpay.com/" + billCode);
    }

    private void openPayment(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        Guest guest = session == null ? null : (Guest) session.getAttribute("loggedGuest");
        if (guest == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=unauthorized");
            return;
        }
        String bookingId = request.getParameter("bookingID");
        Booking selected = null;
        for (Booking booking : new BookingDAO().getBookingsByGuest(guest.getGuestId())) {
            if (booking.getBookingID().equals(bookingId)
                    && "PENDING".equalsIgnoreCase(booking.getBookingStatus())) {
                selected = booking;
                break;
            }
        }
        if (selected == null) {
            response.sendRedirect(request.getContextPath() + "/booking/my-booking?payment=invalid");
            return;
        }
        session.setAttribute("bookingID", selected.getBookingID());
        session.setAttribute("totalAmount", selected.getTotalPrice());
        session.setAttribute("selectedAccommodationID", selected.getAccommodationID());
        session.setAttribute("bookingCheckIn", selected.getCheckInDate());
        session.setAttribute("bookingCheckOut", selected.getCheckOutDate());
        session.setAttribute("bookingPax", selected.getNumberOfPax());
        request.setAttribute("booking", selected);
        if ("confirm".equalsIgnoreCase(request.getParameter("step"))) {
            request.getRequestDispatcher("/paymentPopUp.jsp").forward(request, response);
        } else {
            request.getRequestDispatcher("/pendingInvoice.jsp").forward(request, response);
        }
    }

    private void paymentReturn(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        if (!"1".equals(request.getParameter("status_id"))) {
            response.sendRedirect(request.getContextPath() + "/booking/my-booking?payment=failed");
            return;
        }
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        String bookingID = (String) session.getAttribute("bookingID");
        Double totalAmount = (Double) session.getAttribute("totalAmount");
        if (bookingID == null || totalAmount == null) {
            response.sendRedirect(request.getContextPath() + "/booking/my-booking?payment=invalid");
            return;
        }
        Guest guest = (Guest) session.getAttribute("loggedGuest");
        Booking paidBooking = findGuestBooking(guest, bookingID);
        Payment payment = new Payment();
        payment.setBookingID(bookingID);
        payment.setPaymentDate(LocalDate.now().toString());
        payment.setTotalAmount(totalAmount);
        payment.setPaymentMethod("ToyyibPay");
        payment.setPaymentStatus("PAID");
        payment.setPaymentInvoice("INV-" + bookingID);
        if (new PaymentDAO().makePayment(payment)) {
            if (guest != null && paidBooking != null) {
                sendPaymentConfirmationEmail(paidBooking, guest);
            } else {
                System.err.println("Payment saved, but email data could not be loaded for booking "
                        + bookingID);
            }
            session.removeAttribute("bookingID");
            session.removeAttribute("totalAmount");
            response.sendRedirect(request.getContextPath() + "/booking/my-booking?payment=success");
        } else {
            response.sendRedirect(request.getContextPath() + "/booking/my-booking?payment=saveFailed");
        }
    }

    private Booking findGuestBooking(Guest guest, String bookingID) {
        if (guest == null || bookingID == null) return null;
        for (Booking booking : new BookingDAO().getBookingsByGuest(guest.getGuestId())) {
            if (bookingID.equals(booking.getBookingID())) return booking;
        }
        return null;
    }

    private boolean sendPaymentConfirmationEmail(Booking booking, Guest guest) {
        HttpURLConnection connection = null;
        try {
            connection = (HttpURLConnection) new URL(MAIL_API_URL).openConnection();
            connection.setRequestMethod("POST");
            connection.setConnectTimeout(15000);
            connection.setReadTimeout(30000);
            connection.setDoOutput(true);
            connection.setRequestProperty("Content-Type", "application/json");
            connection.setRequestProperty("Accept", "text/plain, application/json");

            String body = "{"+
                    "\"bookingID\":\"" + json(booking.getBookingID()) + "\","+
                    "\"guestName\":\"" + json(guest.getGuestName()) + "\","+
                    "\"accommodationName\":\"" + json(booking.getAccommodationName()) + "\","+
                    "\"checkInDate\":\"" + json(booking.getCheckInDate()) + "\","+
                    "\"checkOutDate\":\"" + json(booking.getCheckOutDate()) + "\","+
                    "\"guestEmail\":\"" + json(guest.getGuestEmail()) + "\"}";

            try (OutputStream output = connection.getOutputStream()) {
                output.write(body.getBytes(java.nio.charset.StandardCharsets.UTF_8));
            }
            int status = connection.getResponseCode();
            java.io.InputStream responseStream = status >= 200 && status < 300
                    ? connection.getInputStream() : connection.getErrorStream();
            String apiResponse = "";
            if (responseStream != null) {
                try (BufferedReader reader = new BufferedReader(
                        new InputStreamReader(responseStream,
                                java.nio.charset.StandardCharsets.UTF_8))) {
                    StringBuilder responseBody = new StringBuilder();
                    String line;
                    while ((line = reader.readLine()) != null) responseBody.append(line);
                    apiResponse = responseBody.toString();
                }
            }
            if (status < 200 || status >= 300) {
                System.err.println("Mail API returned HTTP " + status
                        + " for booking " + booking.getBookingID() + ": " + apiResponse);
                return false;
            }
            System.out.println("Mail API success for booking " + booking.getBookingID()
                    + ": " + apiResponse);
            return true;
        } catch (Exception e) {
            System.err.println("Payment saved, but confirmation email failed for booking "
                    + booking.getBookingID() + ": " + e.getMessage());
            return false;
        } finally {
            if (connection != null) connection.disconnect();
        }
    }

    private String json(String value) {
        if (value == null) return "";
        return value.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\r", "\\r")
                .replace("\n", "\\n");
    }

    private void receipt(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        Guest guest = session == null ? null : (Guest) session.getAttribute("loggedGuest");
        if (guest == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=unauthorized");
            return;
        }
        String bookingID = request.getParameter("bookingID");
        if (bookingID == null || bookingID.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/booking/my-booking?error=receiptNotFound");
            return;
        }
        List<Booking> bookings = new BookingDAO().getBookingsByGuest(guest.getGuestId());
        Booking selected = null;
        for (Booking booking : bookings) {
            if (bookingID.equals(booking.getBookingID())) { selected = booking; break; }
        }
        if (selected == null || !selected.isPaid()) {
            response.sendRedirect(request.getContextPath() + "/booking/my-booking?error=receiptNotFound");
            return;
        }
        request.setAttribute("booking", selected);
        request.getRequestDispatcher("/receipt.jsp").forward(request, response);
    }

    private void invoice(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        Guest guest = session == null ? null : (Guest) session.getAttribute("loggedGuest");
        if (guest == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=unauthorized");
            return;
        }
        String bookingId = request.getParameter("bookingID");
        Booking selected = null;
        for (Booking booking : new BookingDAO().getBookingsByGuest(guest.getGuestId())) {
            if (booking.getBookingID().equals(bookingId) && booking.isPaid()) { selected = booking; break; }
        }
        Payment payment = selected == null ? null : new PaymentDAO().getPaidPaymentByBookingId(bookingId);
        if (selected == null || payment == null) {
            response.sendRedirect(request.getContextPath() + "/profile?error=invoiceNotFound");
            return;
        }
        request.setAttribute("booking", selected);
        request.setAttribute("payment", payment);
        request.getRequestDispatcher("/invoice.jsp").forward(request, response);
    }

    private String enc(String value) {
        return URLEncoder.encode(value == null ? "" : value,
                java.nio.charset.StandardCharsets.UTF_8);
    }
}
