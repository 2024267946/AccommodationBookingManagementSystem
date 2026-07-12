package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import DBConnection.DBConnection;
import model.Guest;
import model.Staff;

public class UserDAO {

    public boolean registerGuest(Guest guest) {

        String sql =
                "INSERT INTO GUEST " +
                "(GUESTID, GUESTNAME, GUESTEMAIL, " +
                "GUESTPHONENUMBER, GUESTPASSWORD) " +
                "VALUES (GUEST_SEQ.NEXTVAL, ?, ?, ?, ?)";

        try (
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql)
        ) {

            ps.setString(1, guest.getGuestName());
            ps.setString(2, guest.getGuestEmail());
            ps.setString(3, guest.getGuestPhoneNumber());
            ps.setString(4, guest.getGuestPassword());

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
                "WHERE GUESTEMAIL = ? " +
                "AND GUESTPASSWORD = ?";

        try (
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql)
        ) {

            ps.setString(1, email);
            ps.setString(2, password);

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {

                    Guest guest = new Guest();

                    guest.setGuestId(
                            rs.getString("GUESTID"));

                    guest.setGuestName(
                            rs.getString("GUESTNAME"));

                    guest.setGuestEmail(
                            rs.getString("GUESTEMAIL"));

                    guest.setGuestPhoneNumber(
                            rs.getString("GUESTPHONENUMBER"));

                    guest.setGuestPassword(
                            rs.getString("GUESTPASSWORD"));

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
                "WHERE STAFFEMAIL = ? " +
                "AND STAFFPASSWORD = ?";

        try (
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql)
        ) {

            ps.setString(1, email);
            ps.setString(2, password);

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {

                    Staff staff = new Staff();

                    staff.setStaffId(
                            rs.getString("STAFFID"));

                    staff.setStaffName(
                            rs.getString("STAFFNAME"));

                    staff.setStaffEmail(
                            rs.getString("STAFFEMAIL"));

                    staff.setStaffPhoneNumber(
                            rs.getString("STAFFPHONENUMBER"));

                    staff.setStaffPassword(
                            rs.getString("STAFFPASSWORD"));

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
}