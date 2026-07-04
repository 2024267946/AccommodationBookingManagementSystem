package dao;

import java.sql.*;

import java.util.logging.Logger;
import model.Booking;
import DBConnection.DBConnection;

public class BookingDAO {

    private static final Logger logger = Logger.getLogger(BookingDAO.class.getName());
    
    public static boolean createBooking(Booking booking){

        try{
            
            Connection conn = DBConnection.getConnection();

            String sql = """
            INSERT INTO Booking (
                    bookingID,
                    checkInDate,
                    checkOutDate,
                    numberOfPax,
                    totalPrice,
                    bookingStatus,
                    staffID,
                    guestID,
                    accommodationID
                ) VALUES (GUEST_SEQ.NEXTVAL,?, ?, ?, ?, ?, ?, ?, ?)
                """;


            PreparedStatement preparedStatement = conn.prepareStatement(sql);
            preparedStatement.setString(1, booking.getCheckInDate());
            preparedStatement.setString(2, booking.getCheckOutDate());
            preparedStatement.setInt(3, booking.getNumberOfPax());
            preparedStatement.setDouble(4, booking.getTotalPrice());
            preparedStatement.setInt(5, booking.getStaffID());
            preparedStatement.setInt(6, booking.getGuestID());

            int result = preparedStatement.executeUpdate();
            
            if(result > 0){
                return true;
            }else{
                return false;
            }

        }catch(Exception e){
            logger.info(e.getMessage());
            return false;
        }
    }
}
