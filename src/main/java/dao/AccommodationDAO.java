package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import DBConnection.DBConnection;
import model.Accommodation;

public class AccommodationDAO {
  
  // Search and return available accommodations based on check-in, check-out and number of guests.
    public List<Accommodation> searchAvailability(String checkIn, String checkOut, int pax) {

        List<Accommodation> accommodationList = new ArrayList<>();

        String sql =
            "SELECT A.ACCOMMODATIONID, A.ACCOMMODATIONNAME, A.LOCATION, " +
            "A.PRICEPERNIGHT, A.MAXCAPACITY, A.ACCOMMODATIONTYPE, A.DESCRIPTION " +
            "FROM ACCOMMODATION A " +
            "WHERE A.MAXCAPACITY >= ? " +
            "AND NOT EXISTS ( " +
            "   SELECT 1 FROM BOOKING B " +
            "   WHERE B.ACCOMMODATIONID = A.ACCOMMODATIONID " +
            "   AND UPPER(B.BOOKINGSTATUS) NOT IN ('CANCELLED', 'COMPLETED') " +
            "   AND TO_DATE(?, 'YYYY-MM-DD') < B.CHECKOUTDATE " +
            "   AND TO_DATE(?, 'YYYY-MM-DD') > B.CHECKINDATE " +
            ") " +
            "ORDER BY A.ACCOMMODATIONID";

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
                acc.setAccommodationName(rs.getString("ACCOMMODATIONNAME"));
                acc.setLocation(rs.getString("LOCATION"));
                acc.setPricePerNight(rs.getDouble("PRICEPERNIGHT"));
                acc.setMaxCapacity(rs.getInt("MAXCAPACITY"));
                acc.setAccommodationType(rs.getString("ACCOMMODATIONTYPE"));
                acc.setDescription(rs.getString("DESCRIPTION"));

                accommodationList.add(acc);
            }

            rs.close();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return accommodationList;
    }
 
 // Generate Accommodation ID (A001, A002, A003...)
    private String generateAccommodationId(Connection con) {

        String accommodationId = "A001";

        String sql =
            "SELECT 'A' || LPAD(NVL(MAX(TO_NUMBER(SUBSTR(ACCOMMODATIONID, 2))), 0) + 1, 3, '0') AS NEWID " +
            "FROM ACCOMMODATION";

        try (
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery()
        ) {
            if (rs.next()) {
                accommodationId = rs.getString("NEWID");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return accommodationId;
    }

 // Retrieve all accommodation records from the database.
    public List<Accommodation> getAllAccommodation() {

        List<Accommodation> accommodationList = new ArrayList<>();

        String sql =
            "SELECT ACCOMMODATIONID, ACCOMMODATIONNAME, LOCATION, " +
            "PRICEPERNIGHT, MAXCAPACITY, ACCOMMODATIONTYPE, DESCRIPTION " +
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
                acc.setAccommodationName(rs.getString("ACCOMMODATIONNAME"));
                acc.setLocation(rs.getString("LOCATION"));
                acc.setPricePerNight(rs.getDouble("PRICEPERNIGHT"));
                acc.setMaxCapacity(rs.getInt("MAXCAPACITY"));
                acc.setAccommodationType(rs.getString("ACCOMMODATIONTYPE"));
                acc.setDescription(rs.getString("DESCRIPTION"));

                accommodationList.add(acc);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return accommodationList;
    }

 // Owner: Create new accommodation
    public boolean createAccommodation(Accommodation acc) {

        boolean success = false;

        String sql =
            "INSERT INTO ACCOMMODATION " +
            "(ACCOMMODATIONID, ACCOMMODATIONNAME, LOCATION, PRICEPERNIGHT, MAXCAPACITY, ACCOMMODATIONTYPE, DESCRIPTION) " +
            "VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(sql)
        ) {
            String accommodationId = generateAccommodationId(con);

            ps.setString(1, accommodationId);
            ps.setString(2, acc.getAccommodationName());
            ps.setString(3, acc.getLocation());
            ps.setDouble(4, acc.getPricePerNight());
            ps.setInt(5, acc.getMaxCapacity());
            ps.setString(6, acc.getAccommodationType());
            ps.setString(7, acc.getDescription());

            int result = ps.executeUpdate();

            if (result > 0) {
                success = true;
            }

        } catch (Exception e) {
            System.out.println("ERROR CREATE ACCOMMODATION");
            e.printStackTrace();
        }

        return success;
    }
    
 // Owner/Staff: Get accommodation by ID
    public Accommodation getAccommodationById(String accommodationId) {

        Accommodation acc = null;

        String sql =
            "SELECT ACCOMMODATIONID, ACCOMMODATIONNAME, ACCOMMODATIONTYPE, " +
            "MAXCAPACITY, PRICEPERNIGHT, LOCATION, DESCRIPTION " +
            "FROM ACCOMMODATION " +
            "WHERE ACCOMMODATIONID = ?";

        try (
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(sql)
        ) {

            // Set accommodation ID
            ps.setString(1, accommodationId);

            ResultSet rs = ps.executeQuery();

            // If accommodation exists
            if (rs.next()) {

                acc = new Accommodation();

                acc.setAccommodationId(rs.getString("ACCOMMODATIONID"));
                acc.setAccommodationName(rs.getString("ACCOMMODATIONNAME"));
                acc.setAccommodationType(rs.getString("ACCOMMODATIONTYPE"));
                acc.setMaxCapacity(rs.getInt("MAXCAPACITY"));
                acc.setPricePerNight(rs.getDouble("PRICEPERNIGHT"));
                acc.setLocation(rs.getString("LOCATION"));
                acc.setDescription(rs.getString("DESCRIPTION"));
            }

            rs.close();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return acc;
    }
    
    
 // Update an existing accommodation record.
        public boolean updateAccommodation(Accommodation acc) {

            boolean success = false;

            String sql =
                "UPDATE ACCOMMODATION SET " +
                "ACCOMMODATIONNAME = ?, " +
                "LOCATION = ?, " +
                "PRICEPERNIGHT = ?, " +
                "MAXCAPACITY = ?, " +
                "ACCOMMODATIONTYPE = ?, " +
                "DESCRIPTION = ? " +
                "WHERE ACCOMMODATIONID = ?";
            try (
                    Connection con = DBConnection.getConnection();
                    PreparedStatement ps = con.prepareStatement(sql)
                ) {
                    ps.setString(1, acc.getAccommodationName());
                    ps.setString(2, acc.getLocation());
                    ps.setDouble(3, acc.getPricePerNight());
                    ps.setInt(4, acc.getMaxCapacity());
                    ps.setString(5, acc.getAccommodationType());
                    ps.setString(6, acc.getDescription());
                    ps.setString(7, acc.getAccommodationId());

                    success = ps.executeUpdate() > 0;

                } catch (Exception e) {
                    e.printStackTrace();
                }

                return success;
            }
        }