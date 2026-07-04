package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.logging.Logger;

import DBConnection.DBConnection;

public class DashboardDAO {

    private static final Logger logger = Logger.getLogger(DashboardDAO.class.getName());

    // 1. Total Guests
    public int getTotalGuests() {
        int total = 0;

        try {
            Connection conn = DBConnection.getConnection();

            String sql = "SELECT COUNT(*) AS TOTAL FROM GUEST";
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                total = rs.getInt("TOTAL");
            }

        } catch (Exception e) {
            logger.info(e.getMessage());
        }

        return total;
    }

    // 2. Active Bookings
    public int getActiveBookings() {
        int total = 0;

        try {
            Connection conn = DBConnection.getConnection();
            String sql = "SELECT COUNT(*) AS TOTAL FROM BOOKING WHERE BOOKINGSTATUS = 'Verified'";
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                total = rs.getInt("TOTAL");
            }
            
        } catch (Exception e) {
            logger.info(e.getMessage());
        }

        return total;
    }

    // 3. Total Units / Accommodation
    public int getTotalUnits() {
        int total = 0;

        try {
            Connection conn = DBConnection.getConnection();

            String sql = "SELECT COUNT(*) AS TOTAL FROM ACCOMMODATION";
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                total = rs.getInt("TOTAL");
            }

        } catch (Exception e) {
            logger.info(e.getMessage());
        }

        return total;
    }
}