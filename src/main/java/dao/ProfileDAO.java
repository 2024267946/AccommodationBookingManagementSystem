package dao;

import java.sql.*;
import model.Profile;
import DBConnection.DBConnection;
import util.PasswordUtil;

public class ProfileDAO {

    // Retrieves the authenticated account directly from the database.
    public Profile getProfileById(String userId, String role) {
        Profile profile = null;
        String sql = "";

        if ("GUEST".equalsIgnoreCase(role)) {
            sql = "SELECT GUESTID, GUESTNAME, GUESTEMAIL, GUESTPHONENUMBER FROM GUEST WHERE GUESTID = ?";
        } else {
            sql = "SELECT STAFFID, STAFFNAME, STAFFEMAIL, STAFFPHONENUMBER FROM STAFF WHERE STAFFID = ?";
        }

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    profile = new Profile();
                    profile.setId(rs.getString(1));
                    profile.setName(rs.getString(2));
                    profile.setEmail(rs.getString(3));
                    profile.setPhone(rs.getString(4));
                    profile.setRole(role.toUpperCase());
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return profile;
    }

    // Updates user's own profile columns based on active role
    public boolean updateProfile(Profile profile) {
        boolean success = false;
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

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, profile.getName());
            ps.setString(2, profile.getPhone());
            
            if (hasPassword) {
                ps.setString(3, PasswordUtil.hash(profile.getPassword()));
                ps.setString(4, profile.getId());
            } else {
                ps.setString(3, profile.getId());
            }

            success = ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return success;
    }

    public boolean resetGuestPassword(String guestId, String currentPassword, String newPassword) {
        String selectSql = "SELECT GUESTPASSWORD FROM GUEST WHERE GUESTID=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement select = conn.prepareStatement(selectSql)) {
            select.setString(1, guestId);
            try (ResultSet rs = select.executeQuery()) {
                if (!rs.next() || !PasswordUtil.matches(currentPassword, rs.getString(1))) return false;
            }
            try (PreparedStatement update = conn.prepareStatement(
                    "UPDATE GUEST SET GUESTPASSWORD=? WHERE GUESTID=?")) {
                update.setString(1, PasswordUtil.hash(newPassword));
                update.setString(2, guestId);
                return update.executeUpdate() > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
