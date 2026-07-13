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
        double totalAmount = ((Number) session.getAttribute("totalAmount")).doubleValue();
        int amountInSen = (int) (totalAmount * 100);
        String baseUrl = request.getScheme() + "://" + request.getServerName() + ":"
                + request.getServerPort() + request.getContextPath();
        String params =
                "userSecretKey=" + enc(SECRET_KEY) + "&categoryCode=" + enc(CATEGORY_CODE)
                + "&billName=" + enc("DG Rimbun Booking Payment")
                + "&billDescription=" + enc("Payment for Booking " + bookingID)
                + "&billPriceSetting=1&billPayorInfo=1&billAmount=" + amountInSen
                + "&billReturnUrl=" + enc(baseUrl + "/PaymentReturnServlet")
                + "&billCallbackUrl=" + enc(baseUrl + "/PaymentCallbackServlet")
                + "&billExternalReferenceNo=" + enc(bookingID)
                + "&billTo=" + enc("Guest") + "&billEmail=" + enc("guest@email.com")
                + "&billPhone=" + enc("0123456789")
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
            response.sendRedirect(request.getContextPath() + "/paymentPopUp.jsp?error=toyyibpay");
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
        request.getRequestDispatcher("/paymentPopUp.jsp").forward(request, response);
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
        Payment payment = new Payment();
        payment.setBookingID(bookingID);
        payment.setPaymentDate(LocalDate.now().toString());
        payment.setTotalAmount(totalAmount);
        payment.setPaymentMethod("ToyyibPay");
        payment.setPaymentStatus("PAID");
        payment.setPaymentInvoice("INV-" + bookingID);
        if (new PaymentDAO().makePayment(payment)) {
            session.removeAttribute("bookingID");
            session.removeAttribute("totalAmount");
            response.sendRedirect(request.getContextPath() + "/booking/my-booking?payment=success");
        } else {
            response.sendRedirect(request.getContextPath() + "/booking/my-booking?payment=saveFailed");
        }
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
