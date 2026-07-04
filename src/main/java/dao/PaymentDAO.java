package dao;

import java.sql.Connection;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.sql.PreparedStatement;

import DBConnection.DBConnection;
import model.Payment;

public class PaymentDAO {

    public boolean makePayment(Payment payment) {

        boolean success = false;

        try {

            Connection conn = DBConnection.getConnection();

            String sql =
            	    "INSERT INTO PAYMENT "
            	  + "(PAYMENTID, BOOKINGID, PAYMENTDATE, TOTALAMOUNT, "
            	  + "PAYMENTMETHOD, PAYMENTSTATUS, SECURITYDEPOSIT, PAYMENTINVOICE) "
            	  + "VALUES "
            	  + "(PAYMENT_SEQ.NEXTVAL, ?, ?, ?, ?, ?, ?, ?)";
            
            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setString(1, payment.getBookingID());           
            ps.setDate(2, new java.sql.Date(System.currentTimeMillis()));            
            ps.setDouble(3, payment.getTotalAmount());
            ps.setString(4, payment.getPaymentMethod());
            ps.setString(5, payment.getPaymentStatus());
            ps.setDouble(6, payment.getSecurityDeposit());
            ps.setString(7, payment.getPaymentInvoice());

            success = ps.executeUpdate() > 0;

            ps.close();
            conn.close();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return success;
    }
}