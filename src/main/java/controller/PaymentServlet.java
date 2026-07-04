package controller;

import java.io.IOException;

import dao.PaymentDAO;
import model.Payment;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/PaymentServlet")
public class PaymentServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

    	String bookingID = request.getParameter("bookingID");
    	String paymentDate = request.getParameter("paymentDate");
        double totalAmount = Double.parseDouble(request.getParameter("totalAmount"));
        String paymentMethod = request.getParameter("paymentMethod");
        double securityDeposit = Double.parseDouble(request.getParameter("securityDeposit"));
        String sourceId = request.getParameter("sourceId");

        Payment payment = new Payment();

        payment.setBookingID(bookingID);
        payment.setPaymentDate(paymentDate);
        payment.setTotalAmount(totalAmount);
        payment.setPaymentMethod(paymentMethod);
        payment.setPaymentStatus("PAID");
        payment.setSecurityDeposit(securityDeposit);
        payment.setPaymentInvoice("INV-" + bookingID);
        
        System.out.println("Square token: " + sourceId);
        PaymentDAO dao = new PaymentDAO();

        boolean success = dao.makePayment(payment);
        System.out.println(request.getParameter("paymentDate"));
        if (success) {
            response.sendRedirect("successPopup.jsp");
        } else {
            response.sendRedirect("paymentPopup.jsp");
        }
    }
}