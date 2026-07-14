package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import DBConnection.DBConnection;
import model.Guest;
import util.PasswordUtil;

public class GuestDAO {

    private String generateGuestID() {

        String newID = "G001";

        String sql =
                "SELECT GUESTID FROM GUEST " +
                "ORDER BY GUESTID DESC FETCH FIRST 1 ROWS ONLY";

        try (
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery()
        ) {

            if (rs.next()) {

                String lastID = rs.getString("GUESTID");
                int number = Integer.parseInt(lastID.substring(1)) + 1;

                newID = String.format("G%03d", number);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return newID;
    }

    // Add a new guest as ACTIVE.
    public void addGuest(Guest guest) {

        String sql =
                "INSERT INTO GUEST " +
                "(GUESTID, GUESTNAME, GUESTEMAIL, " +
                "GUESTPHONENUMBER, GUESTPASSWORD, STATUS) " +
                "VALUES (?, ?, ?, ?, ?, 'ACTIVE')";

        try (
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(sql)
        ) {

            ps.setString(1, generateGuestID());
            ps.setString(2, guest.getGuestName());
            ps.setString(3, guest.getGuestEmail());
            ps.setString(4, guest.getGuestPhoneNumber());
            ps.setString(5, PasswordUtil.hashIfNeeded(guest.getGuestPassword()));

            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Return active guests only.
    public List<Guest> getAllGuest() {

        List<Guest> guestList = new ArrayList<>();

        String sql =
                "SELECT * FROM GUEST " +
                "WHERE STATUS = 'ACTIVE' " +
                "ORDER BY GUESTID";

        try (
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery()
        ) {

            while (rs.next()) {

                Guest guest = mapGuest(rs);
                guestList.add(guest);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return guestList;
    }

    // Return archived/inactive guests only.
    public List<Guest> getArchivedGuests() {

        List<Guest> guestList = new ArrayList<>();

        String sql =
                "SELECT * FROM GUEST " +
                "WHERE STATUS = 'INACTIVE' " +
                "ORDER BY GUESTID";

        try (
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery()
        ) {

            while (rs.next()) {

                Guest guest = mapGuest(rs);
                guestList.add(guest);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return guestList;
    }

    public Guest getGuestByID(String guestID) {

        Guest guest = null;

        String sql =
                "SELECT * FROM GUEST WHERE GUESTID = ?";

        try (
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(sql)
        ) {

            ps.setString(1, guestID);

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {
                    guest = mapGuest(rs);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return guest;
    }

    // Soft archive guest.
    public boolean archiveGuest(String guestID) {

        String sql =
                "UPDATE GUEST " +
                "SET STATUS = 'INACTIVE' " +
                "WHERE GUESTID = ?";

        try (
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(sql)
        ) {

            ps.setString(1, guestID);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Restore archived guest.
    public boolean restoreGuest(String guestID) {

        String sql =
                "UPDATE GUEST " +
                "SET STATUS = 'ACTIVE' " +
                "WHERE GUESTID = ?";

        try (
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(sql)
        ) {

            ps.setString(1, guestID);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Count active guests.
    public int getTotalGuest() {

        String sql =
                "SELECT COUNT(*) FROM GUEST " +
                "WHERE STATUS = 'ACTIVE'";

        return getCount(sql);
    }

    // Count archived guests.
    public int getArchivedGuestCount() {

        String sql =
                "SELECT COUNT(*) FROM GUEST " +
                "WHERE STATUS = 'INACTIVE'";

        return getCount(sql);
    }

    private Guest mapGuest(ResultSet rs) throws Exception {

        Guest guest = new Guest();

        guest.setGuestId(rs.getString("GUESTID"));
        guest.setGuestName(rs.getString("GUESTNAME"));
        guest.setGuestEmail(rs.getString("GUESTEMAIL"));
        guest.setGuestPhoneNumber(rs.getString("GUESTPHONENUMBER"));
        guest.setGuestPassword(rs.getString("GUESTPASSWORD"));
        guest.setStatus(rs.getString("STATUS"));

        return guest;
    }

    private int getCount(String sql) {

        int total = 0;

        try (
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery()
        ) {

            if (rs.next()) {
                total = rs.getInt(1);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return total;
    }
}