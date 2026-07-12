package controller;

import java.io.IOException;
import java.time.LocalDate;

import dao.PaymentDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Payment;

@WebServlet("/PaymentReturnServlet")
public class PaymentReturnServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String statusID = request.getParameter("status_id");

        if (!"1".equals(statusID)) {
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

        PaymentDAO paymentDAO = new PaymentDAO();
        boolean saved = paymentDAO.makePayment(payment);

        if (saved) {
            session.removeAttribute("bookingID");
            session.removeAttribute("totalAmount");
            response.sendRedirect(request.getContextPath() + "/booking/my-booking?payment=success");
        } else {
            response.sendRedirect(request.getContextPath() + "/booking/my-booking?payment=saveFailed");
        }
    }
}
