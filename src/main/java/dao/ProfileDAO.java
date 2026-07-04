package dao;

import java.sql.*;
import model.Profile;
import DBConnection.DBConnection;

public class ProfileDAO {

    // Retrieves account details by email and active session role
    public Profile getProfileByEmail(String email, String role) {
        Profile profile = null;
        Connection conn = DBConnection.getConnection();
        String sql = "";

        if ("GUEST".equalsIgnoreCase(role)) {
            sql = "SELECT GUESTID, GUESTNAME, GUESTEMAIL, GUESTPHONENUMBER FROM GUEST WHERE GUESTEMAIL = ?";
        } else {
            sql = "SELECT STAFFID, STAFFNAME, STAFFEMAIL, STAFFPHONENUMBER FROM STAFF WHERE STAFFEMAIL = ?";
        }

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    profile = new Profile();
                    profile.setId(rs.getInt(1));
                    profile.setName(rs.getString(2));
                    profile.setEmail(rs.getString(3));
                    profile.setPhone(rs.getString(4));
                    profile.setRole(role.toUpperCase());
                }
            }
            conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return profile;
    }

    // Updates user's own profile columns based on active role
    public boolean updateProfile(Profile profile) {
        boolean success = false;
        Connection conn = DBConnection.getConnection();
        String sql = "";

        boolean hasPassword = profile.getPassword() != null && !profile.getPassword().trim().isEmpty();

        if ("GUEST".equalsIgnoreCase(profile.getRole())) {
            sql = hasPassword ? 
                "UPDATE GUEST SET GUESTNAME = ?, GUESTPHONENUMBER = ?, GUESTPASSWORD = ? WHERE GUESTID = ?" :
                "UPDATE GUEST SET GUESTNAME = ?, GUESTPHONENUMBER = ? WHERE GUESTID = ?";
        } else {
            sql = hasPassword ? 
                "UPDATE STAFF SET STAFFNAME = ?, STAFFPHONENUMBER = ?, STAFFPASSWORD = ? WHERE STAFFID = ?" :
                "UPDATE STAFF SET STAFFNAME = ?, STAFFPHONENUMBER = ? WHERE STAFFID = ?";
        }

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, profile.getName());
            ps.setString(2, profile.getPhone());
            
            if (hasPassword) {
                ps.setString(3, profile.getPassword());
                ps.setInt(4, profile.getId());
            } else {
                ps.setInt(3, profile.getId());
            }

            success = ps.executeUpdate() > 0;
            conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return success;
    }
}