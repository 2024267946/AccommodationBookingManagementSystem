package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;

import model.Booking;
import DBConnection.DBConnection;

public class BookingDAO {

    private static final Logger logger = Logger.getLogger(BookingDAO.class.getName());

    // 1. /booking/create-booking
    // Creates a booking and returns its generated ID, for example B005.
    public static String createBooking(Booking booking) {

        String bookingID = generateNewBookingId();

        if (bookingID == null) {
            return null;
        }

        String sql =
            "INSERT INTO BOOKING " +
            "(BOOKINGID, GUESTID, STAFFID, ACCOMMODATIONID, " +
            "CHECKINDATE, CHECKOUTDATE, NUMBEROFPAX, TOTALPRICE, BOOKINGSTATUS) " +
            "VALUES (?, ?, ?, ?, TO_DATE(?, 'YYYY-MM-DD'), " +
            "TO_DATE(?, 'YYYY-MM-DD'), ?, ?, ?)";

        try (
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql)
        ) {

            ps.setString(1, bookingID);
            ps.setString(2, booking.getGuestID());

            if (booking.getStaffID() == null
                    || booking.getStaffID().trim().isEmpty()) {
                ps.setNull(3, Types.VARCHAR);
            } else {
                ps.setString(3, booking.getStaffID());
            }

            ps.setString(4, booking.getAccommodationID());
            ps.setString(5, booking.getCheckInDate());
            ps.setString(6, booking.getCheckOutDate());
            ps.setInt(7, booking.getNumberOfPax());
            ps.setDouble(8, booking.getTotalPrice());
            ps.setString(9, booking.getBookingStatus());

            if (ps.executeUpdate() > 0) {
                return bookingID;
            }

        } catch (Exception e) {
            logger.info(e.getMessage());
            e.printStackTrace();
        }

        return null;
    }

    // Generates IDs in the format B001, B002, B003 and so on.
    private static String generateNewBookingId() {

        String sql =
            "SELECT 'B' || LPAD(" +
            "NVL(MAX(TO_NUMBER(SUBSTR(BOOKINGID, 2))), 0) + 1, " +
            "3, '0') AS NEWID " +
            "FROM BOOKING " +
            "WHERE REGEXP_LIKE(BOOKINGID, '^B[0-9]+$')";

        try (
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery()
        ) {

            if (rs.next()) {
                return rs.getString("NEWID");
            }

        } catch (Exception e) {
            logger.info(e.getMessage());
            e.printStackTrace();
        }

        return null;
    }

    // 2. /booking/cancel-booking
    public boolean cancelBooking(Booking booking) {

        String sql =
            "UPDATE BOOKING SET BOOKINGSTATUS = 'Cancelled' WHERE BOOKINGID = ?";

        try (
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql)
        ) {

            ps.setString(1, booking.getBookingID());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            logger.info(e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    // 3. /staff/booking/verify
    public boolean verifyBooking(Booking booking) {

        String sql =
            "UPDATE BOOKING SET BOOKINGSTATUS = 'Verified', STAFFID = ? WHERE BOOKINGID = ?";

        try (
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql)
        ) {

            ps.setString(1, booking.getStaffID());
            ps.setString(2, booking.getBookingID());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            logger.info(e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    // 4. /booking/my-bookings
    public List<Booking> getBookingsByGuest(String guestId) {

        List<Booking> list = new ArrayList<>();

        String sql =
            "SELECT BOOKINGID, GUESTID, STAFFID, ACCOMMODATIONID, NUMBEROFPAX, TOTALPRICE, BOOKINGSTATUS, " +
            "TO_CHAR(CHECKINDATE, 'YYYY-MM-DD') AS CHECKINSTR, " +
            "TO_CHAR(CHECKOUTDATE, 'YYYY-MM-DD') AS CHECKOUTSTR " +
            "FROM BOOKING " +
            "WHERE GUESTID = ? " +
            "ORDER BY BOOKINGID DESC";

        try (
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql)
        ) {

            ps.setString(1, guestId);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Booking b = new Booking();

                b.setBookingID(rs.getString("BOOKINGID"));
                b.setGuestID(rs.getString("GUESTID"));
                b.setStaffID(rs.getString("STAFFID"));
                b.setAccommodationID(rs.getString("ACCOMMODATIONID"));
                b.setCheckInDate(rs.getString("CHECKINSTR"));
                b.setCheckOutDate(rs.getString("CHECKOUTSTR"));
                b.setNumberOfPax(rs.getInt("NUMBEROFPAX"));
                b.setTotalPrice(rs.getDouble("TOTALPRICE"));
                b.setBookingStatus(rs.getString("BOOKINGSTATUS"));

                list.add(b);
            }

        } catch (Exception e) {
            logger.info(e.getMessage());
            e.printStackTrace();
        }

        return list;
    }

    // 5. /staff/view-bookings
    public List<Booking> getAllBookings() {

        List<Booking> list = new ArrayList<>();

        String sql =
            "SELECT BOOKINGID, GUESTID, STAFFID, ACCOMMODATIONID, NUMBEROFPAX, TOTALPRICE, BOOKINGSTATUS, " +
            "TO_CHAR(CHECKINDATE, 'YYYY-MM-DD') AS CHECKINSTR, " +
            "TO_CHAR(CHECKOUTDATE, 'YYYY-MM-DD') AS CHECKOUTSTR " +
            "FROM BOOKING " +
            "ORDER BY BOOKINGID DESC";

        try (
            Connection conn = DBConnection.getConnection();
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery(sql)
        ) {

            while (rs.next()) {
                Booking b = new Booking();

                b.setBookingID(rs.getString("BOOKINGID"));
                b.setGuestID(rs.getString("GUESTID"));
                b.setStaffID(rs.getString("STAFFID"));
                b.setAccommodationID(rs.getString("ACCOMMODATIONID"));
                b.setCheckInDate(rs.getString("CHECKINSTR"));
                b.setCheckOutDate(rs.getString("CHECKOUTSTR"));
                b.setNumberOfPax(rs.getInt("NUMBEROFPAX"));
                b.setTotalPrice(rs.getDouble("TOTALPRICE"));
                b.setBookingStatus(rs.getString("BOOKINGSTATUS"));

                list.add(b);
            }

        } catch (Exception e) {
            logger.info(e.getMessage());
            e.printStackTrace();
        }

        return list;
    }

    // 6. Staff update accommodation availability
    public boolean updateAvailability(String accommodationID, String staffID,
                                      String checkIn, String checkOut, String status) {

        if ("Unavailable".equalsIgnoreCase(status)) {
            return blockAvailability(accommodationID, staffID, checkIn, checkOut);
        } else if ("Available".equalsIgnoreCase(status)) {
            return reopenAvailability(accommodationID, checkIn, checkOut);
        }

        return false;
    }

    // Staff blocks accommodation date
    private boolean blockAvailability(String accommodationID, String staffID,
                                      String checkIn, String checkOut) {

        String bookingId = generateBookingId();

        String sql =
            "INSERT INTO BOOKING " +
            "(BOOKINGID, GUESTID, STAFFID, ACCOMMODATIONID, CHECKINDATE, CHECKOUTDATE, NUMBEROFPAX, TOTALPRICE, BOOKINGSTATUS) " +
            "VALUES (?, ?, ?, ?, TO_DATE(?, 'YYYY-MM-DD'), TO_DATE(?, 'YYYY-MM-DD'), ?, ?, ?)";

        try (
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql)
        ) {

            ps.setString(1, bookingId);
            ps.setString(2, null);
            ps.setString(3, staffID);
            ps.setString(4, accommodationID);
            ps.setString(5, checkIn);
            ps.setString(6, checkOut);
            ps.setInt(7, 0);
            ps.setDouble(8, 0.00);
            ps.setString(9, "Unavailable");

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            logger.info(e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    // Staff reopens blocked accommodation date
    private boolean reopenAvailability(String accommodationID, String checkIn, String checkOut) {

        String sql =
            "UPDATE BOOKING SET BOOKINGSTATUS = 'Cancelled' " +
            "WHERE ACCOMMODATIONID = ? " +
            "AND UPPER(BOOKINGSTATUS) = 'UNAVAILABLE' " +
            "AND TO_DATE(?, 'YYYY-MM-DD') < CHECKOUTDATE " +
            "AND TO_DATE(?, 'YYYY-MM-DD') > CHECKINDATE";

        try (
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql)
        ) {

            ps.setString(1, accommodationID);
            ps.setString(2, checkIn);
            ps.setString(3, checkOut);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            logger.info(e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    // Generate Booking ID like B001, B002, B003
    private String generateBookingId() {

        String bookingId = "B001";

        String sql =
            "SELECT 'B' || LPAD(NVL(MAX(TO_NUMBER(SUBSTR(BOOKINGID, 2))), 0) + 1, 3, '0') AS NEWID " +
            "FROM BOOKING WHERE REGEXP_LIKE(BOOKINGID, '^B[0-9]+$')";

        try (
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery()
        ) {

            if (rs.next()) {
                bookingId = rs.getString("NEWID");
            }

        } catch (Exception e) {
            logger.info(e.getMessage());
            e.printStackTrace();
        }

        return bookingId;
    }
}