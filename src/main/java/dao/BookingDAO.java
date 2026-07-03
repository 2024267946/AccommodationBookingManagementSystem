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
    public static boolean createBooking(Booking booking) {
        try {
            Connection conn = DBConnection.getConnection();

            // insert into booking table
            String sql1 = "INSERT INTO BOOKING (BOOKINGID, GUESTID, STAFFID, CHECKINDATE, CHECKOUTDATE, NUMBEROFPAX, TOTALPRICE, BOOKINGSTATUS) VALUES (SEQ_BOOKING.NEXTVAL, ?, ?, TO_DATE(?, 'YYYY-MM-DD'), TO_DATE(?, 'YYYY-MM-DD'), ?, ?, ?)";
            PreparedStatement ps1 = conn.prepareStatement(sql1);
            ps1.setInt(1, booking.getGuestID());
            ps1.setInt(2, booking.getStaffID());
            ps1.setString(3, booking.getCheckInDate());
            ps1.setString(4, booking.getCheckOutDate());
            ps1.setInt(5, booking.getNumberOfPax());
            ps1.setDouble(6, booking.getTotalPrice());
            ps1.setString(7, booking.getBookingStatus());
            
            int result1 = ps1.executeUpdate();

            // insert into bookingdetail table
            String sql2 = "INSERT INTO BOOKINGDETAIL (BOOKINGID, ACCOMMODATIONID) VALUES (SEQ_BOOKING.CURRVAL, ?)";
            PreparedStatement ps2 = conn.prepareStatement(sql2);
            ps2.setInt(1, booking.getAccommodationID()); // Pulls from your model object
            
            int result2 = ps2.executeUpdate();

            // check
            if (result1 > 0 && result2 > 0) {
                return true;
            } else {
                return false;
            }

        } catch (Exception e) {
            logger.info(e.getMessage());
            return false;
        }
    }
    
    // 2. /booking/cancel-booking
    public boolean cancelBooking(Booking booking) {
        try {
            Connection conn = DBConnection.getConnection();
            String sql = "UPDATE BOOKING SET BOOKINGSTATUS = 'Cancelled' WHERE BOOKINGID = ?";
            
            PreparedStatement preparedStatement = conn.prepareStatement(sql);
            preparedStatement.setInt(1, booking.getBookingID());
            
            int result = preparedStatement.executeUpdate();
          
            if (result > 0) {
                return true;
            } else {
                return false;
            }
        } catch (Exception e) {
            logger.info(e.getMessage());
            return false;
        }
    }
    
    // 3. /staff/booking/verify
    public boolean verifyBooking(Booking booking) {
        try {
            Connection conn = DBConnection.getConnection();
            String sql = "UPDATE BOOKING SET BOOKINGSTATUS = 'Verified', STAFFID = ? WHERE BOOKINGID = ?";
            
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, booking.getStaffID());
            ps.setInt(2, booking.getBookingID());
            
            int result = ps.executeUpdate();
            
            if (result > 0) {
                return true;
            } else {
                return false;
            }
        } catch (Exception e) {
            logger.info(e.getMessage());
            return false;
        }
    }
    
    // 4. /booking/my-bookings
    public List<Booking> getBookingsByGuest(int guestID) {
        List<Booking> list = new ArrayList<>();
        try {
            Connection conn = DBConnection.getConnection();
            String sql = "SELECT BOOKINGID, GUESTID, STAFFID, NUMBEROFPAX, TOTALPRICE, BOOKINGSTATUS, TO_CHAR(CHECKINDATE, 'YYYY-MM-DD') AS checkInStr, TO_CHAR(CHECKOUTDATE, 'YYYY-MM-DD') AS checkOutStr FROM BOOKING WHERE GUESTID = ? ORDER BY BOOKINGID DESC";
            
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, guestID);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Booking b = new Booking();
                b.setBookingID(rs.getInt("BOOKINGID"));
                b.setCheckInDate(rs.getString("checkInStr"));
                b.setCheckOutDate(rs.getString("checkOutStr"));
                b.setNumberOfPax(rs.getInt("NUMBEROFPAX"));
                b.setTotalPrice(rs.getDouble("TOTALPRICE"));
                b.setBookingStatus(rs.getString("BOOKINGSTATUS"));
                b.setStaffID(rs.getInt("STAFFID"));
                b.setGuestID(rs.getInt("GUESTID"));
                
                list.add(b);
            }
        } catch (Exception e) {
            logger.info(e.getMessage());
        }
        return list;
    }
    
    // 5. /staff/view-bookings
    public List<Booking> getAllBookings() {
        List<Booking> list = new ArrayList<>();
        try {
            Connection conn = DBConnection.getConnection();
            String sql = "SELECT BOOKINGID, GUESTID, STAFFID, NUMBEROFPAX, TOTALPRICE, BOOKINGSTATUS, TO_CHAR(CHECKINDATE, 'YYYY-MM-DD') AS checkInStr, TO_CHAR(CHECKOUTDATE, 'YYYY-MM-DD') AS checkOutStr FROM BOOKING ORDER BY BOOKINGID DESC";
            
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery(sql);
            
            while (rs.next()) {
                Booking b = new Booking();
                b.setBookingID(rs.getInt("BOOKINGID"));
                b.setCheckInDate(rs.getString("checkInStr"));
                b.setCheckOutDate(rs.getString("checkOutStr"));
                b.setNumberOfPax(rs.getInt("NUMBEROFPAX"));
                b.setTotalPrice(rs.getDouble("TOTALPRICE"));
                b.setBookingStatus(rs.getString("BOOKINGSTATUS"));
                b.setStaffID(rs.getInt("STAFFID"));
                b.setGuestID(rs.getInt("GUESTID"));
                
                list.add(b);
            }
        } catch (Exception e) {
            logger.info(e.getMessage());
        }
        return list;
    }
}