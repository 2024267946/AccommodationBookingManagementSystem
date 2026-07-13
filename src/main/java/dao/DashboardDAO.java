package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import DBConnection.DBConnection;

public class DashboardDAO {

    public Map<String, Object> getDashboardAnalytics() {
        Map<String, Object> data = new HashMap<>();

        String metricsSql =
            "SELECT " +
            "(SELECT COUNT(*) FROM BOOKING) TOTALBOOKINGS, " +
            "(SELECT NVL(SUM(TOTALAMOUNT),0) FROM PAYMENT WHERE UPPER(PAYMENTSTATUS)='PAID') TOTALREVENUE, " +
            "(SELECT COUNT(*) FROM BOOKING WHERE UPPER(BOOKINGSTATUS)='CANCELLED') TOTALCANCELLED, " +
            "(SELECT COUNT(*) FROM GUEST WHERE UPPER(STATUS)='ACTIVE') ACTIVECUSTOMERS, " +
            "(SELECT COUNT(*) FROM STAFF WHERE UPPER(STATUS)='ACTIVE' AND UPPER(STAFFROLES)='STAFF') ACTIVESTAFF, " +
            "(SELECT COUNT(*) FROM BOOKING WHERE UPPER(BOOKINGSTATUS) NOT IN ('CANCELLED','COMPLETED') AND CHECKINDATE >= TRUNC(SYSDATE)) UPCOMINGSTAYS, " +
            "(SELECT NVL(AVG(TOTALPRICE),0) FROM BOOKING WHERE UPPER(BOOKINGSTATUS)<>'CANCELLED') AVGBOOKINGAMOUNT, " +
            "(SELECT NVL(AVG(CHECKOUTDATE-CHECKINDATE),0) FROM BOOKING WHERE UPPER(BOOKINGSTATUS)<>'CANCELLED') AVGBOOKEDDAYS " +
            "FROM DUAL";

        try (
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(metricsSql);
            ResultSet rs = ps.executeQuery()
        ) {
            if (rs.next()) {
                data.put("totalBookings", rs.getInt("TOTALBOOKINGS"));
                data.put("totalRevenue", rs.getDouble("TOTALREVENUE"));
                data.put("totalCancelled", rs.getInt("TOTALCANCELLED"));
                data.put("activeCustomers", rs.getInt("ACTIVECUSTOMERS"));
                data.put("activeStaff", rs.getInt("ACTIVESTAFF"));
                data.put("upcomingStays", rs.getInt("UPCOMINGSTAYS"));
                data.put("averageBookingAmount", rs.getDouble("AVGBOOKINGAMOUNT"));
                data.put("averageBookedDays", rs.getDouble("AVGBOOKEDDAYS"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        data.put("revenueByAccommodation", getTopRevenueByAccommodation());
        data.put("stayLengthByAccommodation", getTopStayLengthByAccommodation());
        data.putAll(getWeekdayWeekendShare());
        return data;
    }

    private List<Map<String, Object>> getTopRevenueByAccommodation() {
        String sql =
            "SELECT A.ACCOMMODATIONNAME LABEL, AVG(P.TOTALAMOUNT) VALUE " +
            "FROM ACCOMMODATION A " +
            "JOIN BOOKINGDETAIL BD ON BD.ACCOMMODATIONID=A.ACCOMMODATIONID " +
            "JOIN PAYMENT P ON P.BOOKINGID=BD.BOOKINGID " +
            "WHERE UPPER(P.PAYMENTSTATUS)='PAID' " +
            "GROUP BY A.ACCOMMODATIONID, A.ACCOMMODATIONNAME " +
            "ORDER BY VALUE DESC FETCH FIRST 5 ROWS ONLY";
        return getChartRows(sql);
    }

    private List<Map<String, Object>> getTopStayLengthByAccommodation() {
        String sql =
            "SELECT A.ACCOMMODATIONNAME LABEL, AVG(B.CHECKOUTDATE-B.CHECKINDATE) VALUE " +
            "FROM ACCOMMODATION A " +
            "JOIN BOOKINGDETAIL BD ON BD.ACCOMMODATIONID=A.ACCOMMODATIONID " +
            "JOIN BOOKING B ON B.BOOKINGID=BD.BOOKINGID " +
            "WHERE UPPER(B.BOOKINGSTATUS)<>'CANCELLED' " +
            "GROUP BY A.ACCOMMODATIONID, A.ACCOMMODATIONNAME " +
            "ORDER BY VALUE DESC FETCH FIRST 5 ROWS ONLY";
        return getChartRows(sql);
    }

    private List<Map<String, Object>> getChartRows(String sql) {
        List<Map<String, Object>> rows = new ArrayList<>();
        try (
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery()
        ) {
            while (rs.next()) {
                Map<String, Object> row = new HashMap<>();
                row.put("label", rs.getString("LABEL"));
                row.put("value", rs.getDouble("VALUE"));
                rows.add(row);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return rows;
    }

    private Map<String, Object> getWeekdayWeekendShare() {
        long weekdayNights = 0;
        long weekendNights = 0;
        String sql =
            "SELECT CHECKINDATE, CHECKOUTDATE FROM BOOKING " +
            "WHERE UPPER(BOOKINGSTATUS)<>'CANCELLED'";

        try (
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery()
        ) {
            while (rs.next()) {
                LocalDate date = rs.getDate("CHECKINDATE").toLocalDate();
                LocalDate checkout = rs.getDate("CHECKOUTDATE").toLocalDate();
                while (date.isBefore(checkout)) {
                    DayOfWeek day = date.getDayOfWeek();
                    if (day == DayOfWeek.SATURDAY || day == DayOfWeek.SUNDAY) {
                        weekendNights++;
                    } else {
                        weekdayNights++;
                    }
                    date = date.plusDays(1);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        Map<String, Object> result = new HashMap<>();
        result.put("weekdayNights", weekdayNights);
        result.put("weekendNights", weekendNights);
        return result;
    }
}
