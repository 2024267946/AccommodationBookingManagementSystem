package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import DBConnection.DBConnection;
import model.Accommodation;

public class AvailabilityDAO {

    // Guest: Search available accommodation
    public List<Accommodation> searchAvailability(String checkIn, String checkOut, int pax) {

        List<Accommodation> accommodationList = new ArrayList<>();

        String sql =
            "SELECT ACCOMMODATIONID, ACCOMMODATIONTYPE, MAXCAPACITY, " +
            "PRICEPERNIGHT, LOCATION, DESCRIPTION " +
            "FROM ACCOMMODATION " +
            "WHERE MAXCAPACITY >= ? " +
            "AND ACCOMMODATIONID NOT IN ( " +
            "   SELECT BD.ACCOMMODATIONID " +
            "   FROM BOOKINGDETAIL BD " +
            "   JOIN BOOKING B ON BD.BOOKINGID = B.BOOKINGID " +
            "   WHERE B.BOOKINGSTATUS NOT IN ('Cancelled', 'Rejected') " +
            "   AND TO_DATE(?, 'YYYY-MM-DD') < B.CHECKOUTDATE " +
            "   AND TO_DATE(?, 'YYYY-MM-DD') > B.CHECKINDATE " +
            ")";

        try (
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(sql)
        ) {
            ps.setInt(1, pax);
            ps.setString(2, checkIn);
            ps.setString(3, checkOut);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Accommodation acc = new Accommodation();

                acc.setAccommodationId(rs.getString("ACCOMMODATIONID"));
                acc.setAccommodationType(rs.getString("ACCOMMODATIONTYPE"));
                acc.setMaxCapacity(rs.getInt("MAXCAPACITY"));
                acc.setPricePerNight(rs.getDouble("PRICEPERNIGHT"));
                acc.setLocation(rs.getString("LOCATION"));
                acc.setDescription(rs.getString("DESCRIPTION"));

                accommodationList.add(acc);
            }

            rs.close();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return accommodationList;
    }

    // Staff: Get all accommodation
    public List<Accommodation> getAllAccommodation() {

        List<Accommodation> accommodationList = new ArrayList<>();

        String sql =
            "SELECT ACCOMMODATIONID, ACCOMMODATIONTYPE, MAXCAPACITY, " +
            "PRICEPERNIGHT, LOCATION, DESCRIPTION " +
            "FROM ACCOMMODATION " +
            "ORDER BY ACCOMMODATIONID";

        try (
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery()
        ) {

            while (rs.next()) {
                Accommodation acc = new Accommodation();

                acc.setAccommodationId(rs.getString("ACCOMMODATIONID"));
                acc.setAccommodationType(rs.getString("ACCOMMODATIONTYPE"));
                acc.setMaxCapacity(rs.getInt("MAXCAPACITY"));
                acc.setPricePerNight(rs.getDouble("PRICEPERNIGHT"));
                acc.setLocation(rs.getString("LOCATION"));
                acc.setDescription(rs.getString("DESCRIPTION"));

                accommodationList.add(acc);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return accommodationList;
    }

    // Staff: Block or reopen accommodation date
    public boolean updateAvailability(String accommodationId, String staffId,
                                      String checkIn, String checkOut,
                                      String status) {

        if (status.equalsIgnoreCase("Unavailable")) {
            return blockAvailability(accommodationId, staffId, checkIn, checkOut);
        } else if (status.equalsIgnoreCase("Available")) {
            return reopenAvailability(accommodationId, checkIn, checkOut);
        }

        return false;
    }

    // Staff: Make selected date unavailable
    private boolean blockAvailability(String accommodationId, String staffId,
                                      String checkIn, String checkOut) {

        boolean success = false;
        String bookingId = generateBookingId();

        String sqlBooking =
            "INSERT INTO BOOKING " +
            "(BOOKINGID, GUESTID, STAFFID, CHECKINDATE, CHECKOUTDATE, " +
            "NUMBEROFPAX, TOTALPRICE, BOOKINGSTATUS) " +
            "VALUES (?, ?, ?, TO_DATE(?, 'YYYY-MM-DD'), TO_DATE(?, 'YYYY-MM-DD'), ?, ?, ?)";

        String sqlDetail =
            "INSERT INTO BOOKINGDETAIL (BOOKINGID, ACCOMMODATIONID) " +
            "VALUES (?, ?)";

        try {
            Connection con = DBConnection.getConnection();
            con.setAutoCommit(false);

            PreparedStatement psBooking = con.prepareStatement(sqlBooking);
            psBooking.setString(1, bookingId);
            psBooking.setString(2, "SYSTEM");
            psBooking.setString(3, staffId);
            psBooking.setString(4, checkIn);
            psBooking.setString(5, checkOut);
            psBooking.setInt(6, 0);
            psBooking.setDouble(7, 0.00);
            psBooking.setString(8, "Unavailable");

            int resultBooking = psBooking.executeUpdate();

            PreparedStatement psDetail = con.prepareStatement(sqlDetail);
            psDetail.setString(1, bookingId);
            psDetail.setString(2, accommodationId);

            int resultDetail = psDetail.executeUpdate();

            if (resultBooking > 0 && resultDetail > 0) {
                con.commit();
                success = true;
            } else {
                con.rollback();
            }

            psDetail.close();
            psBooking.close();
            con.close();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return success;
    }

    // Staff: Reopen blocked date
    private boolean reopenAvailability(String accommodationId, String checkIn, String checkOut) {

        boolean success = false;

        String sql =
            "UPDATE BOOKING B " +
            "SET B.BOOKINGSTATUS = 'Cancelled' " +
            "WHERE B.BOOKINGSTATUS = 'Unavailable' " +
            "AND B.BOOKINGID IN ( " +
            "   SELECT BD.BOOKINGID " +
            "   FROM BOOKINGDETAIL BD " +
            "   WHERE BD.ACCOMMODATIONID = ? " +
            ") " +
            "AND TO_DATE(?, 'YYYY-MM-DD') < B.CHECKOUTDATE " +
            "AND TO_DATE(?, 'YYYY-MM-DD') > B.CHECKINDATE";

        try (
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(sql)
        ) {
            ps.setString(1, accommodationId);
            ps.setString(2, checkIn);
            ps.setString(3, checkOut);

            int result = ps.executeUpdate();

            if (result > 0) {
                success = true;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return success;
    }

    // Generate Booking ID like B001, B002, B003
    private String generateBookingId() {

        String bookingId = "B001";

        String sql =
            "SELECT 'B' || LPAD(NVL(MAX(TO_NUMBER(SUBSTR(BOOKINGID, 2))), 0) + 1, 3, '0') AS NEWID " +
            "FROM BOOKING " +
            "WHERE REGEXP_LIKE(BOOKINGID, '^B[0-9]+$')";

        try (
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery()
        ) {

            if (rs.next()) {
                bookingId = rs.getString("NEWID");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return bookingId;
    }
}