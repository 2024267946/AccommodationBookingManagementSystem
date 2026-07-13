package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
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
            "A.PRICEPERNIGHT, A.MAXCAPACITY, A.ACCOMMODATIONTYPE, A.DESCRIPTION, " +
            "A.UNAVAILABLEDATES " +
            "FROM ACCOMMODATION A " +
            "WHERE A.MAXCAPACITY >= ? " +
            "AND NOT EXISTS ( " +
            "   SELECT 1 FROM BOOKING B " +
            "   JOIN BOOKINGDETAIL BD ON BD.BOOKINGID = B.BOOKINGID " +
            "   WHERE BD.ACCOMMODATIONID = A.ACCOMMODATIONID " +
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

            LocalDate requestedCheckIn = LocalDate.parse(checkIn);
            LocalDate requestedCheckOut = LocalDate.parse(checkOut);
            while (rs.next()) {
                String unavailableDates =
                        rs.getString("UNAVAILABLEDATES");

                if (containsUnavailableDate(
                        unavailableDates,
                        requestedCheckIn,
                        requestedCheckOut)) {
                    continue;
                }

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

    private boolean containsUnavailableDate(
            String unavailableDates,
            LocalDate checkIn,
            LocalDate checkOut) {

        if (unavailableDates == null
                || unavailableDates.trim().isEmpty()) {
            return false;
        }

        for (String unavailableDate : unavailableDates.split(",")) {
            try {
                LocalDate date = LocalDate.parse(unavailableDate.trim());

                if (!date.isBefore(checkIn)
                        && !date.isAfter(checkOut)) {
                    return true;
                }
            } catch (DateTimeParseException ignored) {
            }
        }

        return false;
    }

    public String getUnavailableDates(String accommodationId) {
        String sql =
                "SELECT UNAVAILABLEDATES FROM ACCOMMODATION " +
                "WHERE ACCOMMODATIONID = ?";

        try (
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(sql)
        ) {
            ps.setString(1, accommodationId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String unavailableDates = rs.getString("UNAVAILABLEDATES");
                    return unavailableDates == null ? "" : unavailableDates;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return "";
    }

    public boolean updateUnavailableDates(
            String accommodationId,
            String unavailableDates) {

        String sql =
                "UPDATE ACCOMMODATION SET UNAVAILABLEDATES = ? " +
                "WHERE ACCOMMODATIONID = ?";

        try (
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(sql)
        ) {
            if (unavailableDates == null || unavailableDates.isBlank()) {
                ps.setNull(1, java.sql.Types.VARCHAR);
            } else {
                ps.setString(1, unavailableDates);
            }

            ps.setString(2, accommodationId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
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

        return getAccommodationByStatus("WHERE UPPER(STATUS) = 'ACTIVE'");
    }

    public List<Accommodation> getArchivedAccommodation() {

        return getAccommodationByStatus("WHERE UPPER(STATUS) <> 'ACTIVE'");
    }

    public List<Accommodation> getAllAccommodationIncludingArchived() {

        return getAccommodationByStatus("");
    }

    private List<Accommodation> getAccommodationByStatus(String statusClause) {

        List<Accommodation> accommodationList = new ArrayList<>();

        String sql =
            "SELECT ACCOMMODATIONID, ACCOMMODATIONNAME, LOCATION, " +
            "PRICEPERNIGHT, MAXCAPACITY, ACCOMMODATIONTYPE, DESCRIPTION " +
            "FROM ACCOMMODATION " +
            statusClause + " " +
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

    public boolean archiveAccommodation(String accommodationId) {
        return updateAccommodationStatus(accommodationId, "INACTIVE");
    }

    public boolean restoreAccommodation(String accommodationId) {
        return updateAccommodationStatus(accommodationId, "ACTIVE");
    }

    private boolean updateAccommodationStatus(String accommodationId, String status) {
        String sql = "UPDATE ACCOMMODATION SET STATUS = ? WHERE ACCOMMODATIONID = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setString(2, accommodationId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }


 // Owner: Create new accommodation
    public boolean createAccommodation(
            Accommodation acc,
            Integer numberOfRooms,
            String hasLivingHall,
            String roomNumber,
            String floorLevel,
            String chaletCategory) {

        boolean success = false;

        String sql =
            "INSERT INTO ACCOMMODATION " +
            "(ACCOMMODATIONID, ACCOMMODATIONNAME, LOCATION, PRICEPERNIGHT, MAXCAPACITY, ACCOMMODATIONTYPE, DESCRIPTION) " +
            "VALUES (?, ?, ?, ?, ?, ?, ?)";

        Connection con = null;
        try {
            con = DBConnection.getConnection();
            con.setAutoCommit(false);
            String accommodationId = generateAccommodationId(con);

            try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, accommodationId);
            ps.setString(2, acc.getAccommodationName());
            ps.setString(3, acc.getLocation());
            ps.setDouble(4, acc.getPricePerNight());
            ps.setInt(5, acc.getMaxCapacity());
            ps.setString(6, acc.getAccommodationType());
            ps.setString(7, acc.getDescription());

                if (ps.executeUpdate() == 0) {
                    con.rollback();
                    return false;
                }
            }

            if ("HOMESTAY".equalsIgnoreCase(acc.getAccommodationType())) {
                String subtypeSql = "INSERT INTO HOMESTAY "
                        + "(ACCOMMODATIONID, NUMBEROFROOM, HASLIVINGHALL) VALUES (?, ?, ?)";
                try (PreparedStatement ps = con.prepareStatement(subtypeSql)) {
                    ps.setString(1, accommodationId);
                    ps.setInt(2, numberOfRooms);
                    ps.setString(3, hasLivingHall);
                    if (ps.executeUpdate() == 0) {
                        con.rollback();
                        return false;
                    }
                }
            } else if ("CHALET".equalsIgnoreCase(acc.getAccommodationType())) {
                String subtypeSql = "INSERT INTO CHALET "
                        + "(ACCOMMODATIONID, ROOMNUMBER, FLOORLEVEL, CHALETCATEGORY) "
                        + "VALUES (?, ?, ?, ?)";
                try (PreparedStatement ps = con.prepareStatement(subtypeSql)) {
                    ps.setString(1, accommodationId);
                    ps.setString(2, roomNumber);
                    ps.setString(3, floorLevel);
                    ps.setString(4, chaletCategory);
                    if (ps.executeUpdate() == 0) {
                        con.rollback();
                        return false;
                    }
                }
            }

            con.commit();
            success = true;

        } catch (Exception e) {
            System.out.println("ERROR CREATE ACCOMMODATION");
            e.printStackTrace();
            if (con != null) {
                try {
                    con.rollback();
                } catch (SQLException rollbackError) {
                    rollbackError.printStackTrace();
                }
            }
        } finally {
            if (con != null) {
                try {
                    con.setAutoCommit(true);
                    con.close();
                } catch (SQLException closeError) {
                    closeError.printStackTrace();
                }
            }
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
