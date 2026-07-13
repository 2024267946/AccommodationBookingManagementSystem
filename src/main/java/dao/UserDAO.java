package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import DBConnection.DBConnection;
import model.Guest;
import model.Staff;
import util.PasswordUtil;

public class UserDAO {

    public boolean emailExists(String email) {
        String sql = "SELECT 1 FROM GUEST WHERE LOWER(GUESTEMAIL)=LOWER(?) "
                + "UNION ALL SELECT 1 FROM STAFF WHERE LOWER(STAFFEMAIL)=LOWER(?) FETCH FIRST 1 ROWS ONLY";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setString(2, email);
            try (ResultSet rs = ps.executeQuery()) { return rs.next(); }
        } catch (Exception e) {
            e.printStackTrace();
            return true;
        }
    }

    public boolean registerGuest(Guest guest) {

        String sql =
                "INSERT INTO GUEST " +
                "(GUESTID, GUESTNAME, GUESTEMAIL, " +
                "GUESTPHONENUMBER, GUESTPASSWORD) " +
                "VALUES ('G'||LPAD(GUEST_SEQ.NEXTVAL, 3,'0'), ?, ?, ?, ?)";

        try (
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql)
        ) {

            ps.setString(1, guest.getGuestName());
            ps.setString(2, guest.getGuestEmail());
            ps.setString(3, guest.getGuestPhoneNumber());
            ps.setString(4, PasswordUtil.hash(guest.getGuestPassword()));

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Authenticate guest and return the full Guest object.
    public Guest loginGuest(String email, String password) {

        String sql =
                "SELECT GUESTID, GUESTNAME, GUESTEMAIL, " +
                "GUESTPHONENUMBER, GUESTPASSWORD " +
                "FROM GUEST " +
                "WHERE GUESTEMAIL = ? AND UPPER(STATUS)='ACTIVE'";

        try (
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql)
        ) {

            ps.setString(1, email);

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {
                    String storedPassword = rs.getString("GUESTPASSWORD");
                    if (!PasswordUtil.matches(password, storedPassword)) return null;
                    if (!PasswordUtil.isBcryptHash(storedPassword)) {
                        upgradePassword(conn, "GUEST", "GUESTID", rs.getString("GUESTID"),
                                "GUESTPASSWORD", password);
                    }

                    Guest guest = new Guest();

                    guest.setGuestId(
                            rs.getString("GUESTID"));

                    guest.setGuestName(
                            rs.getString("GUESTNAME"));

                    guest.setGuestEmail(
                            rs.getString("GUESTEMAIL"));

                    guest.setGuestPhoneNumber(
                            rs.getString("GUESTPHONENUMBER"));

                    guest.setGuestPassword(null);

                    return guest;
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    // Authenticate owner or staff and return the full Staff object.
    public Staff loginStaff(String email, String password) {

        String sql =
                "SELECT STAFFID, STAFFNAME, STAFFEMAIL, " +
                "STAFFPHONENUMBER, STAFFPASSWORD, STAFFROLES " +
                "FROM STAFF " +
                "WHERE STAFFEMAIL = ? AND UPPER(STATUS)='ACTIVE'";

        try (
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql)
        ) {

            ps.setString(1, email);

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {
                    String storedPassword = rs.getString("STAFFPASSWORD");
                    if (!PasswordUtil.matches(password, storedPassword)) return null;
                    if (!PasswordUtil.isBcryptHash(storedPassword)) {
                        upgradePassword(conn, "STAFF", "STAFFID", rs.getString("STAFFID"),
                                "STAFFPASSWORD", password);
                    }

                    Staff staff = new Staff();

                    staff.setStaffId(
                            rs.getString("STAFFID"));

                    staff.setStaffName(
                            rs.getString("STAFFNAME"));

                    staff.setStaffEmail(
                            rs.getString("STAFFEMAIL"));

                    staff.setStaffPhoneNumber(
                            rs.getString("STAFFPHONENUMBER"));

                    staff.setStaffPassword(null);

                    staff.setStaffRoles(
                            rs.getString("STAFFROLES"));

                    return staff;
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    /*
     * Kept for compatibility with any older code that still calls login().
     */
    public String login(String email, String password) {

        Guest guest = loginGuest(email, password);

        if (guest != null) {
            return "GUEST";
        }

        Staff staff = loginStaff(email, password);

        if (staff != null) {
            return staff.getStaffRoles();
        }

        return null;
    }

    private void upgradePassword(Connection conn, String table, String idColumn,
            String id, String passwordColumn, String password) throws Exception {
        String sql = "UPDATE " + table + " SET " + passwordColumn + "=? WHERE " + idColumn + "=?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, PasswordUtil.hash(password));
            ps.setString(2, id);
            ps.executeUpdate();
        }
    }
}
