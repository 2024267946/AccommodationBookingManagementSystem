package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import model.Guest;
import DBConnection.DBConnection;

public class GuestDAO {

    private String generateGuestID() {
        String newID = "G001";

        try {
            Connection con = DBConnection.getConnection();

            String sql = "SELECT GUESTID FROM GUEST ORDER BY GUESTID DESC FETCH FIRST 1 ROWS ONLY";
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                String lastID = rs.getString("GUESTID");
                int number = Integer.parseInt(lastID.substring(1));
                number++;
                newID = String.format("G%03d", number);
            }

            con.close();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return newID;
    }

    public void addGuest(Guest guest) {
        try {
            Connection con = DBConnection.getConnection();

            String sql = "INSERT INTO GUEST "
                    + "(GUESTID, GUESTNAME, GUESTEMAIL, GUESTPHONENUMBER, GUESTPASSWORD) "
                    + "VALUES (?, ?, ?, ?, ?)";

            PreparedStatement ps = con.prepareStatement(sql);

            ps.setString(1, generateGuestID());
            ps.setString(2, guest.getGuestName());
            ps.setString(3, guest.getGuestEmail());
            ps.setString(4, guest.getGuestPhoneNumber());
            ps.setString(5, guest.getGuestPassword());

            ps.executeUpdate();
            con.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public List<Guest> getAllGuest() {
        List<Guest> guestList = new ArrayList<>();

        try {
            Connection con = DBConnection.getConnection();

            String sql = "SELECT * FROM GUEST ORDER BY GUESTID";
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Guest guest = new Guest();

                guest.setGuestId(rs.getString("GUESTID"));
                guest.setGuestName(rs.getString("GUESTNAME"));
                guest.setGuestEmail(rs.getString("GUESTEMAIL"));
                guest.setGuestPhoneNumber(rs.getString("GUESTPHONENUMBER"));
                guest.setGuestPassword(rs.getString("GUESTPASSWORD"));

                guestList.add(guest);
            }

            con.close();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return guestList;
    }

    public Guest getGuestByID(String guestID) {
        Guest guest = null;

        try {
            Connection con = DBConnection.getConnection();

            String sql = "SELECT * FROM GUEST WHERE GUESTID = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, guestID);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                guest = new Guest();

                guest.setGuestId(rs.getString("GUESTID"));
                guest.setGuestName(rs.getString("GUESTNAME"));
                guest.setGuestEmail(rs.getString("GUESTEMAIL"));
                guest.setGuestPhoneNumber(rs.getString("GUESTPHONENUMBER"));
                guest.setGuestPassword(rs.getString("GUESTPASSWORD"));
            }

            con.close();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return guest;
    }

    public boolean deleteGuest(String guestID) {
        boolean success = false;

        try {
            Connection con = DBConnection.getConnection();

            String sql = "DELETE FROM GUEST WHERE GUESTID = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, guestID);

            int row = ps.executeUpdate();
            success = row > 0;

            con.close();

        } catch (SQLIntegrityConstraintViolationException e) {
            success = false;
        } catch (Exception e) {
            e.printStackTrace();
            success = false;
        }

        return success;
    }
    public int getTotalGuest(){

        int total = 0;

        try{

            Connection con = DBConnection.getConnection();

            String sql = "SELECT COUNT(*) FROM GUEST";

            PreparedStatement ps = con.prepareStatement(sql);

            ResultSet rs = ps.executeQuery();

            if(rs.next()){
                total = rs.getInt(1);
            }

            con.close();

        }catch(Exception e){
            e.printStackTrace();
        }

        return total;
    }
}