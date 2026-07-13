package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import DBConnection.DBConnection;
import model.Staff;
import util.PasswordUtil;

public class StaffDAO {

    private String generateStaffID() {

        String newID = "S001";

        String sql =
                "SELECT STAFFID FROM STAFF " +
                "ORDER BY STAFFID DESC FETCH FIRST 1 ROWS ONLY";

        try (
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery()
        ) {

            if (rs.next()) {
                String lastID = rs.getString("STAFFID");
                int number =
                        Integer.parseInt(lastID.substring(1)) + 1;

                newID = String.format("S%03d", number);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return newID;
    }

    public boolean addStaff(Staff staff) {

        String sql =
                "INSERT INTO STAFF " +
                "(STAFFID, STAFFNAME, STAFFPASSWORD, STAFFEMAIL, " +
                "STAFFPHONENUMBER, STAFFROLES, STATUS) " +
                "VALUES (?, ?, ?, ?, ?, ?, 'ACTIVE')";

        try (
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(sql)
        ) {

            ps.setString(1, generateStaffID());
            ps.setString(2, staff.getStaffName());
            ps.setString(3, PasswordUtil.hashIfNeeded(staff.getStaffPassword()));
            ps.setString(4, staff.getStaffEmail());
            ps.setString(5, staff.getStaffPhoneNumber());
            ps.setString(6, staff.getStaffRoles());

            ps.executeUpdate();
            return true;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Staff> getAllStaff() {

        List<Staff> staffList = new ArrayList<>();

        String sql =
                "SELECT * FROM STAFF " +
                "WHERE UPPER(STATUS) = 'ACTIVE' " +
                "ORDER BY STAFFID";

        try (
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery()
        ) {

            while (rs.next()) {
                staffList.add(mapStaff(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return staffList;
    }

    public List<Staff> getArchivedStaff() {

        List<Staff> staffList = new ArrayList<>();

        String sql =
                "SELECT * FROM STAFF " +
                "WHERE UPPER(STATUS) = 'INACTIVE' " +
                "AND UPPER(STAFFROLES) = 'STAFF' " +
                "ORDER BY STAFFID";

        try (
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery()
        ) {

            while (rs.next()) {
                staffList.add(mapStaff(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return staffList;
    }

    public Staff getStaffByID(String staffID) {

        Staff staff = null;

        String sql =
                "SELECT * FROM STAFF WHERE STAFFID = ?";

        try (
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(sql)
        ) {

            ps.setString(1, staffID);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    staff = mapStaff(rs);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return staff;
    }

    public boolean updateStaff(Staff staff) {

        String sql =
                "UPDATE STAFF SET " +
                "STAFFNAME = ?, " +
                "STAFFPASSWORD = ?, " +
                "STAFFEMAIL = ?, " +
                "STAFFPHONENUMBER = ?, " +
                "STAFFROLES = ? " +
                "WHERE STAFFID = ?";

        try (
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(sql)
        ) {

            ps.setString(1, staff.getStaffName());
            ps.setString(2, PasswordUtil.hashIfNeeded(staff.getStaffPassword()));
            ps.setString(3, staff.getStaffEmail());
            ps.setString(4, staff.getStaffPhoneNumber());
            ps.setString(5, staff.getStaffRoles());
            ps.setString(6, staff.getStaffId());

            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
		return false;
    }

    public boolean archiveStaff(String staffID) {

        if (staffID == null || staffID.trim().isEmpty()) {
            return false;
        }

        String sql =
                "UPDATE STAFF " +
                "SET STATUS = 'INACTIVE' " +
                "WHERE STAFFID = ? " +
                "AND UPPER(STAFFROLES) = 'STAFF'";

        try (
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(sql)
        ) {

            ps.setString(1, staffID);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean restoreStaff(String staffID) {

        if (staffID == null || staffID.trim().isEmpty()) {
            return false;
        }

        String sql =
                "UPDATE STAFF " +
                "SET STATUS = 'ACTIVE' " +
                "WHERE STAFFID = ? " +
                "AND UPPER(STAFFROLES) = 'STAFF'";

        try (
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(sql)
        ) {

            ps.setString(1, staffID);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public int getTotalStaff() {

        String sql =
                "SELECT COUNT(*) FROM STAFF " +
                "WHERE UPPER(STAFFROLES) = 'STAFF' " +
                "AND UPPER(STATUS) = 'ACTIVE'";

        return getCount(sql);
    }

    public int getTotalOwner() {

        String sql =
                "SELECT COUNT(*) FROM STAFF " +
                "WHERE UPPER(STAFFROLES) = 'OWNER' " +
                "AND UPPER(STATUS) = 'ACTIVE'";

        return getCount(sql);
    }

    public int getArchivedStaffCount() {

        String sql =
                "SELECT COUNT(*) FROM STAFF " +
                "WHERE UPPER(STAFFROLES) = 'STAFF' " +
                "AND UPPER(STATUS) = 'INACTIVE'";

        return getCount(sql);
    }

    private Staff mapStaff(ResultSet rs) throws Exception {

        Staff staff = new Staff();

        staff.setStaffId(rs.getString("STAFFID"));
        staff.setStaffName(rs.getString("STAFFNAME"));
        staff.setStaffPassword(rs.getString("STAFFPASSWORD"));
        staff.setStaffEmail(rs.getString("STAFFEMAIL"));
        staff.setStaffPhoneNumber(
                rs.getString("STAFFPHONENUMBER"));
        staff.setStaffRoles(rs.getString("STAFFROLES"));
        staff.setStatus(rs.getString("STATUS"));

        return staff;
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
