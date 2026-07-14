package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import DBConnection.DBConnection;
import model.Payment;

public class PaymentDAO {

    private String generatePaymentId(Connection conn) {

        String paymentId = "PAY001";

        String sql =
            "SELECT 'PAY' || LPAD(NVL(MAX(TO_NUMBER(SUBSTR(PAYMENTID,4))),0)+1,3,'0') AS NEWID " +
            "FROM PAYMENT " +
            "WHERE REGEXP_LIKE(PAYMENTID,'^PAY[0-9]+$')";

        try (
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery()
        ) {
            if (rs.next()) {
                paymentId = rs.getString("NEWID");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return paymentId;
    }

    public boolean makePayment(Payment payment) {

        boolean success = false;

        String sql =
            "INSERT INTO PAYMENT " +
            "(PAYMENTID, BOOKINGID, PAYMENTDATE, TOTALAMOUNT, PAYMENTSTATUS) " +
            "VALUES (?, ?, ?, ?, ?)";

        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);
            String paymentId = generatePaymentId(conn);

            try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, paymentId);
            ps.setString(2, payment.getBookingID());
            ps.setDate(3, java.sql.Date.valueOf(payment.getPaymentDate()));
            ps.setDouble(4, payment.getTotalAmount());
           
            ps.setString(5, payment.getPaymentStatus());

                if (ps.executeUpdate() == 0) { conn.rollback(); return false; }
            }

            try (PreparedStatement ps = conn.prepareStatement(
                    "UPDATE BOOKING SET BOOKINGSTATUS='CONFIRMED' "
                    + "WHERE BOOKINGID=? AND UPPER(BOOKINGSTATUS)='PENDING'")) {
                ps.setString(1, payment.getBookingID());
                if (ps.executeUpdate() == 0) { conn.rollback(); return false; }
            }
            conn.commit();
            success = true;

        } catch (Exception e) {
            e.printStackTrace();
            if (conn != null) try { conn.rollback(); } catch (Exception ignored) { }
        } finally {
            if (conn != null) try { conn.setAutoCommit(true); conn.close(); } catch (Exception ignored) { }
        }

        return success;
    }

    public Payment getPaidPaymentByBookingId(String bookingId) {
        String sql = "SELECT PAYMENTID, BOOKINGID, TO_CHAR(PAYMENTDATE,'YYYY-MM-DD') PAYMENTDATE, "
                + "TOTALAMOUNT, PAYMENTSTATUS FROM PAYMENT "
                + "WHERE BOOKINGID=? AND UPPER(PAYMENTSTATUS)='PAID' ORDER BY PAYMENTDATE DESC FETCH FIRST 1 ROWS ONLY";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, bookingId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Payment payment = new Payment();
                    payment.setPaymentID(rs.getString("PAYMENTID"));
                    payment.setBookingID(rs.getString("BOOKINGID"));
                    payment.setPaymentDate(rs.getString("PAYMENTDATE"));
                    payment.setTotalAmount(rs.getDouble("TOTALAMOUNT"));
                    
                    payment.setPaymentStatus(rs.getString("PAYMENTSTATUS"));
                    return payment;
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return null;
    }
}