package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import model.Staff;
import DBConnection.DBConnection;

public class StaffDAO {

    private String generateStaffID() {
        String newID = "S001";

        try {
            Connection con = DBConnection.getConnection();

            String sql = "SELECT STAFFID FROM STAFF ORDER BY STAFFID DESC FETCH FIRST 1 ROWS ONLY";
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                String lastID = rs.getString("STAFFID"); // S001
                int number = Integer.parseInt(lastID.substring(1)); // 001
                number++;
                newID = String.format("S%03d", number);
            }

            con.close();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return newID;
    }

    public void addStaff(Staff staff) {
        try {
            Connection con = DBConnection.getConnection();

            String sql = "INSERT INTO STAFF "
                    + "(STAFFID, STAFFNAME, STAFFPASSWORD, STAFFEMAIL, STAFFPHONENUMBER, STAFFROLES) "
                    + "VALUES (?, ?, ?, ?, ?, ?)";

            PreparedStatement ps = con.prepareStatement(sql);

            ps.setString(1, generateStaffID());
            ps.setString(2, staff.getStaffName());
            ps.setString(3, staff.getStaffPassword());
            ps.setString(4, staff.getStaffEmail());
            ps.setString(5, staff.getStaffPhoneNumber());
            ps.setString(6, staff.getStaffRoles());

            ps.executeUpdate();
            con.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public List<Staff> getAllStaff() {
        List<Staff> staffList = new ArrayList<>();

        try {
            Connection con = DBConnection.getConnection();

            String sql = "SELECT * FROM STAFF ORDER BY STAFFID";
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Staff staff = new Staff();

                staff.setStaffId(rs.getString("STAFFID"));
                staff.setStaffName(rs.getString("STAFFNAME"));
                staff.setStaffPassword(rs.getString("STAFFPASSWORD"));
                staff.setStaffEmail(rs.getString("STAFFEMAIL"));
                staff.setStaffPhoneNumber(rs.getString("STAFFPHONENUMBER"));
                staff.setStaffRoles(rs.getString("STAFFROLES"));

                staffList.add(staff);
            }

            con.close();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return staffList;
    }

    public Staff getStaffByID(String staffID) {
        Staff staff = null;

        try {
            Connection con = DBConnection.getConnection();

            String sql = "SELECT * FROM STAFF WHERE STAFFID = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, staffID);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                staff = new Staff();

                staff.setStaffId(rs.getString("STAFFID"));
                staff.setStaffName(rs.getString("STAFFNAME"));
                staff.setStaffPassword(rs.getString("STAFFPASSWORD"));
                staff.setStaffEmail(rs.getString("STAFFEMAIL"));
                staff.setStaffPhoneNumber(rs.getString("STAFFPHONENUMBER"));
                staff.setStaffRoles(rs.getString("STAFFROLES"));
            }

            con.close();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return staff;
    }

    public void updateStaff(Staff staff) {
        try {
            Connection con = DBConnection.getConnection();

            String sql = "UPDATE STAFF SET "
                    + "STAFFNAME = ?, "
                    + "STAFFPASSWORD = ?, "
                    + "STAFFEMAIL = ?, "
                    + "STAFFPHONENUMBER = ?, "
                    + "STAFFROLES = ? "
                    + "WHERE STAFFID = ?";

            PreparedStatement ps = con.prepareStatement(sql);

            ps.setString(1, staff.getStaffName());
            ps.setString(2, staff.getStaffPassword());
            ps.setString(3, staff.getStaffEmail());
            ps.setString(4, staff.getStaffPhoneNumber());
            ps.setString(5, staff.getStaffRoles());
            ps.setString(6, staff.getStaffId());

            ps.executeUpdate();
            con.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public boolean deleteStaff(String staffID) {
        boolean success = false;

        try {
            Connection con = DBConnection.getConnection();

            String sql = "DELETE FROM STAFF WHERE STAFFID = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, staffID);

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
    
    public int getTotalStaff() {

        int total = 0;

        try {

            Connection con = DBConnection.getConnection();

            String sql = "SELECT COUNT(*) FROM STAFF WHERE STAFFROLES='STAFF'";

            PreparedStatement ps = con.prepareStatement(sql);

            ResultSet rs = ps.executeQuery();

            if(rs.next()){
                total = rs.getInt(1);
            }

            con.close();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return total;
    }
    
    public int getTotalOwner() {

        int total = 0;

        try {

            Connection con = DBConnection.getConnection();

            String sql = "SELECT COUNT(*) FROM STAFF WHERE STAFFROLES='OWNER'";

            PreparedStatement ps = con.prepareStatement(sql);

            ResultSet rs = ps.executeQuery();

            if(rs.next()){
                total = rs.getInt(1);
            }

            con.close();

        } catch(Exception e){
            e.printStackTrace();
        }

        return total;
    }
}