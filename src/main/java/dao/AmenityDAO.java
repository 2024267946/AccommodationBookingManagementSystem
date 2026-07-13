package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import DBConnection.DBConnection;
import model.Amenity;

public class AmenityDAO {

 // Generate Accommodation ID (A001, A002, A003...)
    private String generateAmenityID(Connection con) {

        String ammenityId = "AM001";

        String sql =
            "SELECT 'AM' || LPAD(" +
            "NVL(MAX(TO_NUMBER(SUBSTR(AMENITYID, 3))), 0) + 1, " +
            "3, '0') AS NEWID " +
            "FROM AMENITY " +
            "WHERE REGEXP_LIKE(AMENITYID, '^AM[0-9]+$')";

        try (
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery()
        ) {
            if (rs.next()) {
                ammenityId = rs.getString("NEWID");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return ammenityId;
    }

    // List all active amenities.
    public List<Amenity> getAllActiveAmenities() {

        return getAmenitiesByStatus("ACTIVE");
    }

    public List<Amenity> getArchivedAmenities() {

        return getAmenitiesByStatus("ARCHIVED");
    }

    private List<Amenity> getAmenitiesByStatus(String status) {

        List<Amenity> list = new ArrayList<>();

        String sql =
                "SELECT AMENITYID, AMENITYNAME, STATUS, ACCOMMODATIONID " +
                "FROM AMENITY " +
                "WHERE UPPER(STATUS) = ? " +
                "ORDER BY AMENITYID DESC";

        try (
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql)
        ) {
            ps.setString(1, status);

            try (ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {

                Amenity amenity = new Amenity();

                amenity.setAmenityId(
                        rs.getString("AMENITYID"));

                amenity.setAmenityName(
                        rs.getString("AMENITYNAME"));

                amenity.setStatus(
                        rs.getString("STATUS"));

                amenity.setAccommodationId(
                    rs.getString("ACCOMMODATIONID")
                );

                list.add(amenity);
            }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    // List active amenities belonging to one accommodation.
    public List<Amenity> getAmenitiesByAccommodation(
            String accommodationId) {

        List<Amenity> list = new ArrayList<>();

        String sql =
                "SELECT AMENITYID, AMENITYNAME, STATUS, ACCOMMODATIONID " +
                "FROM AMENITY " +
                "WHERE ACCOMMODATIONID = ? " +
                "AND STATUS = 'ACTIVE' " +
                "ORDER BY AMENITYID";

        try (
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql)
        ) {

            ps.setString(
                    1,
                    accommodationId.trim());

            try (ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {

                    Amenity amenity = new Amenity();

                    amenity.setAmenityId(
                            rs.getString("AMENITYID"));

                    amenity.setAmenityName(
                            rs.getString("AMENITYNAME"));

                    amenity.setStatus(
                            rs.getString("STATUS"));

                    list.add(amenity);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    /*
     * Add one amenity to an accommodation.
     * AMENITYID is generated in the AM001, AM002... format.
     * Empty textbox is treated as optional and returns true.
     */
    public boolean addAmenityToAccommodation(
            String amenityName,
            String accommodationId) {

        if (isBlank(amenityName)) {
            return true;
        }

        if (isBlank(accommodationId)) {
            return false;
        }

        String cleanAmenityName =
                amenityName.trim();

        String cleanAccommodationId =
                accommodationId.trim();

        String duplicateSql =
                "SELECT COUNT(*) " +
                "FROM AMENITY " +
                "WHERE UPPER(AMENITYNAME) = UPPER(?) " +
                "AND ACCOMMODATIONID = ? " +
                "AND STATUS = 'ACTIVE'";

        String insertSql =
                "INSERT INTO AMENITY " +
                "(AMENITYID, AMENITYNAME, ACCOMMODATIONID, STATUS) " +
                "VALUES (?, ?, ?, 'ACTIVE')";

        try (Connection conn = DBConnection.getConnection()) {

            try (
                PreparedStatement duplicatePs =
                        conn.prepareStatement(duplicateSql)
            ) {

                duplicatePs.setString(
                        1,
                        cleanAmenityName);

                duplicatePs.setString(
                        2,
                        cleanAccommodationId);

                try (ResultSet rs = duplicatePs.executeQuery()) {

                    if (rs.next() && rs.getInt(1) > 0) {
                        // Amenity already exists for this accommodation.
                        return true;
                    }
                }
            }

            try (
                PreparedStatement insertPs =
                        conn.prepareStatement(insertSql)
            ) {

                String amenityId = generateAmenityID(conn);

                insertPs.setString(
                        1,
                        amenityId);

                insertPs.setString(
                        2,
                        cleanAmenityName);

                insertPs.setString(
                        3,
                        cleanAccommodationId);

                return insertPs.executeUpdate() > 0;
            }

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /*
     * Transaction version, used when accommodation update and
     * amenity inserts should share the same Connection.
     */
    public boolean addAmenityToAccommodation(
            Connection conn,
            String amenityName,
            String accommodationId)
            throws SQLException {

        if (isBlank(amenityName)) {
            return true;
        }

        if (conn == null || isBlank(accommodationId)) {
            return false;
        }

        String cleanAmenityName =
                amenityName.trim();

        String cleanAccommodationId =
                accommodationId.trim();

        String duplicateSql =
                "SELECT COUNT(*) " +
                "FROM AMENITY " +
                "WHERE UPPER(AMENITYNAME) = UPPER(?) " +
                "AND ACCOMMODATIONID = ? " +
                "AND STATUS = 'ACTIVE'";

        String insertSql =
                "INSERT INTO AMENITY " +
                "(AMENITYID, AMENITYNAME, ACCOMMODATIONID, STATUS) " +
                "VALUES (?, ?, ?, 'ACTIVE')";

        try (
            PreparedStatement duplicatePs =
                    conn.prepareStatement(duplicateSql)
        ) {

            duplicatePs.setString(
                    1,
                    cleanAmenityName);

            duplicatePs.setString(
                    2,
                    cleanAccommodationId);

            try (ResultSet rs = duplicatePs.executeQuery()) {

                if (rs.next() && rs.getInt(1) > 0) {
                    return true;
                }
            }
        }

        try (
            PreparedStatement insertPs =
                    conn.prepareStatement(insertSql)
        ) {

            String amenityId = generateAmenityID(conn);

            insertPs.setString(
                    1,
                    amenityId);

            insertPs.setString(
                    2,
                    cleanAmenityName);

            insertPs.setString(
                    3,
                    cleanAccommodationId);

            return insertPs.executeUpdate() > 0;
        }
    }

    // Update amenity name.
    public boolean updateAmenity(Amenity amenity) {

        String sql =
                "UPDATE AMENITY " +
                "SET AMENITYNAME = ? " +
                "WHERE AMENITYID = ?";

        try (
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql)
        ) {

            ps.setString(
                    1,
                    amenity.getAmenityName().trim());

            ps.setString(
                    2,
                    amenity.getAmenityId());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Soft-delete amenity.
    public boolean archiveAmenity(String amenityId) {

        String sql =
                "UPDATE AMENITY " +
                "SET STATUS = 'ARCHIVED' " +
                "WHERE AMENITYID = ?";

        try (
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql)
        ) {

            ps.setString(
                    1,
                    amenityId);

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean restoreAmenity(String amenityId) {
        String sql = "UPDATE AMENITY SET STATUS = 'ACTIVE' WHERE AMENITYID = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, amenityId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }
}
