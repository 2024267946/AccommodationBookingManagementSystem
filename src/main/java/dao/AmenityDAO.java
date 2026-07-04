package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Amenity;
import DBConnection.DBConnection;

public class AmenityDAO {

    // 1. Read / List all active amenities
    public List<Amenity> getAllActiveAmenities() {
        List<Amenity> list = new ArrayList<>();
        String sql = "SELECT AMENITYID, AMENITYNAME FROM AMENITY WHERE STATUS = 'ACTIVE' ORDER BY AMENITYID DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                Amenity amenity = new Amenity();
                amenity.setAmenityId(rs.getInt("AMENITYID"));
                amenity.setAmenityName(rs.getString("AMENITYNAME"));
                amenity.setStatus("ACTIVE");
                list.add(amenity);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // 2. Create / Add a brand new amenity
    public boolean createAmenity(Amenity amenity) {
        boolean success = false;
        String sql = "INSERT INTO AMENITY (AMENITYID, AMENITYNAME, STATUS) VALUES (AMENITY_SEQ.NEXTVAL, ?, 'ACTIVE')";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, amenity.getAmenityName());
            success = ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return success;
    }

    // 3. Update existing amenity name
    public boolean updateAmenity(Amenity amenity) {
        boolean success = false;
        String sql = "UPDATE AMENITY SET AMENITYNAME = ? WHERE AMENITYID = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, amenity.getAmenityName());
            ps.setInt(2, amenity.getAmenityId());
            success = ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return success;
    }

    // 4. Archive (Soft-delete) an amenity
    public boolean archiveAmenity(int amenityId) {
        boolean success = false;
        String sql = "UPDATE AMENITY SET STATUS = 'ARCHIVED' WHERE AMENITYID = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, amenityId);
            success = ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return success;
    }
}