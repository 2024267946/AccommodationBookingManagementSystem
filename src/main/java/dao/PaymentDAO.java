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
            "(PAYMENTID, BOOKINGID, PAYMENTDATE, TOTALAMOUNT, PAYMENTMETHOD, PAYMENTSTATUS) " +
            "VALUES (?, ?, ?, ?, ?, ?)";

        try (
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql)
        ) {
            String paymentId = generatePaymentId(conn);

            ps.setString(1, paymentId);
            ps.setString(2, payment.getBookingID());
            ps.setDate(3, java.sql.Date.valueOf(payment.getPaymentDate()));
            ps.setDouble(4, payment.getTotalAmount());
            ps.setString(5, payment.getPaymentMethod());
            ps.setString(6, payment.getPaymentStatus());

            success = ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return success;
    }
}