package controller;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import dao.GuestDAO;
import dao.DashboardDAO;
import dao.StaffDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Staff;

@WebServlet(urlPatterns = {
    "/owner/dashboard",
    "/owner/dashboard/report",
    "/owner/view-staff",
    "/owner/view-guest",
    "/owner/create-staff",
    "/owner/archive-staff",
    "/owner/view-archived-staff",
    "/owner/restore-staff",
    "/owner/archive-guest",
    "/owner/view-archived-guest",
    "/owner/restore-guest",

    "/staff/dashboard",
    "/staff/dashboard/report",
    "/staff/view-staff",
    "/staff/view-guest",
    "/staff/update"
})
public class StaffServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private StaffDAO staffDAO;
    private GuestDAO guestDAO;
    private DashboardDAO dashboardDAO;

    @Override
    public void init() {
        staffDAO = new StaffDAO();
        guestDAO = new GuestDAO();
        dashboardDAO = new DashboardDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        String path = request.getServletPath();

        switch (path) {

            case "/owner/dashboard":
                if (!isRole(request, "OWNER")) {
                    redirectUnauthorized(request, response);
                    return;
                }

                openDashboard(request, response, "OWNER");
                break;

            case "/owner/dashboard/report":
                if (!isRole(request, "OWNER")) {
                    redirectUnauthorized(request, response);
                    return;
                }
                downloadDashboardReport(response, "OWNER");
                break;

            case "/owner/view-staff":
                if (!isRole(request, "OWNER")) {
                    redirectUnauthorized(request, response);
                    return;
                }

                request.setAttribute(
                        "staffList",
                        staffDAO.getAllStaff());

                request.setAttribute(
                        "guestList",
                        guestDAO.getAllGuest());

                request.getRequestDispatcher(
                        "/Owner/userManagement.jsp")
                       .forward(request, response);
                break;

            case "/owner/view-guest":
                if (!isRole(request, "OWNER")) {
                    redirectUnauthorized(request, response);
                    return;
                }

                request.setAttribute(
                        "staffList",
                        staffDAO.getAllStaff());

                request.setAttribute(
                        "guestList",
                        guestDAO.getAllGuest());

                request.getRequestDispatcher(
                        "/Owner/userManagement.jsp")
                       .forward(request, response);
                break;

            case "/owner/create-staff":
                if (!isRole(request, "OWNER")) {
                    redirectUnauthorized(request, response);
                    return;
                }

                request.getRequestDispatcher(
                        "/Owner/createStaff.jsp")
                       .forward(request, response);
                break;

            case "/owner/view-archived-staff":
                if (!isRole(request, "OWNER")) {
                    redirectUnauthorized(request, response);
                    return;
                }

                viewArchivedStaff(request, response);
                break;

            case "/owner/archive-staff":
                if (!isRole(request, "OWNER")) {
                    redirectUnauthorized(request, response);
                    return;
                }

                archiveStaff(request, response);
                break;

            case "/owner/view-archived-guest":
                if (!isRole(request, "OWNER")) {
                    redirectUnauthorized(request, response);
                    return;
                }

                viewArchivedGuest(request, response);
                break;

            case "/owner/archive-guest":
                if (!isRole(request, "OWNER")) {
                    redirectUnauthorized(request, response);
                    return;
                }

                archiveGuest(request, response);
                break;

            case "/staff/dashboard":
                if (!isRole(request, "STAFF")) {
                    redirectUnauthorized(request, response);
                    return;
                }

                openDashboard(request, response, "STAFF");
                break;

            case "/staff/dashboard/report":
                if (!isRole(request, "STAFF")) {
                    redirectUnauthorized(request, response);
                    return;
                }
                downloadDashboardReport(response, "STAFF");
                break;

            case "/staff/view-staff":
                if (!isRole(request, "STAFF")) {
                    redirectUnauthorized(request, response);
                    return;
                }

                request.setAttribute(
                        "staffList",
                        staffDAO.getAllStaff());

                request.getRequestDispatcher(
                        "/Staff/StaffViewStaff.jsp")
                       .forward(request, response);
                break;

            case "/staff/view-guest":
                if (!isRole(request, "STAFF")) {
                    redirectUnauthorized(request, response);
                    return;
                }

                request.setAttribute(
                        "guestList",
                        guestDAO.getAllGuest());

                request.getRequestDispatcher(
                        "/Staff/StaffViewGuest.jsp")
                       .forward(request, response);
                break;

            case "/staff/update":
                if (!isRole(request, "STAFF")) {
                    redirectUnauthorized(request, response);
                    return;
                }

                openStaffProfileUpdate(request, response);
                break;

            default:
                response.sendError(
                        HttpServletResponse.SC_NOT_FOUND);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String path = request.getServletPath();

        switch (path) {

            case "/owner/create-staff":
                if (!isRole(request, "OWNER")) {
                    redirectUnauthorized(request, response);
                    return;
                }

                createStaff(request, response);
                break;

            case "/owner/restore-staff":
                if (!isRole(request, "OWNER")) {
                    redirectUnauthorized(request, response);
                    return;
                }

                restoreStaff(request, response);
                break;

            case "/owner/restore-guest":
                if (!isRole(request, "OWNER")) {
                    redirectUnauthorized(request, response);
                    return;
                }

                restoreGuest(request, response);
                break;

            case "/staff/update":
                if (!isRole(request, "STAFF")) {
                    redirectUnauthorized(request, response);
                    return;
                }

                updateOwnStaffProfile(request, response);
                break;

            default:
                response.sendError(
                        HttpServletResponse.SC_NOT_FOUND);
                break;
        }
    }

    private void createStaff(HttpServletRequest request,
                             HttpServletResponse response)
            throws IOException {

        Staff staff = new Staff();

        staff.setStaffName(
                request.getParameter("staffName"));

        staff.setStaffPassword(
                request.getParameter("staffPassword"));

        staff.setStaffEmail(
                request.getParameter("staffEmail"));

        staff.setStaffPhoneNumber(
                request.getParameter("staffPhoneNumber"));

        staff.setStaffRoles("STAFF");
        staff.setStatus("ACTIVE");

        boolean success = staffDAO.addStaff(staff);

        if (success) {
            request.getSession().setAttribute(
                    "successMessage",
                    "Staff created successfully.");
        } else {
            request.getSession().setAttribute(
                    "errorMessage",
                    "Unable to create staff.");
        }

        response.sendRedirect(
                request.getContextPath()
                + "/owner/view-staff");
    }

    private void viewArchivedStaff(HttpServletRequest request,
                                   HttpServletResponse response)
            throws ServletException, IOException {

        List<Staff> archivedStaffList =
                staffDAO.getArchivedStaff();

        request.setAttribute(
                "archivedStaffList",
                archivedStaffList);

        request.getRequestDispatcher(
                "/Owner/ArchivedStaff.jsp")
               .forward(request, response);
    }

    private void viewArchivedGuest(HttpServletRequest request,
                                   HttpServletResponse response)
            throws ServletException, IOException {

        request.setAttribute(
                "archivedGuestList",
                guestDAO.getArchivedGuests());

        request.getRequestDispatcher(
                "/Owner/ArchivedGuest.jsp")
               .forward(request, response);
    }

    private void openStaffProfileUpdate(HttpServletRequest request,
                                        HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session =
                request.getSession(false);

        if (session == null
                || session.getAttribute("loggedStaff") == null) {

            redirectUnauthorized(request, response);
            return;
        }

        Staff loggedStaff =
                (Staff) session.getAttribute("loggedStaff");

        Staff staff =
                staffDAO.getStaffByID(
                        loggedStaff.getStaffId());

        request.setAttribute("staff", staff);

        request.getRequestDispatcher(
                "/Staff/StaffUpdateProfile.jsp")
               .forward(request, response);
    }

    private void updateOwnStaffProfile(HttpServletRequest request,
                                       HttpServletResponse response)
            throws IOException {

        HttpSession session =
                request.getSession(false);

        if (session == null
                || session.getAttribute("loggedStaff") == null) {

            redirectUnauthorized(request, response);
            return;
        }

        Staff loggedStaff =
                (Staff) session.getAttribute("loggedStaff");

        Staff staff = new Staff();

        staff.setStaffId(
                loggedStaff.getStaffId());

        staff.setStaffName(
                request.getParameter("staffName"));

        staff.setStaffPassword(
                request.getParameter("staffPassword"));

        staff.setStaffEmail(
                request.getParameter("staffEmail"));

        staff.setStaffPhoneNumber(
                request.getParameter("staffPhoneNumber"));

        staff.setStaffRoles(
                loggedStaff.getStaffRoles());

        staff.setStatus("ACTIVE");

        boolean success =
                staffDAO.updateStaff(staff);

        if (success) {
            session.setAttribute(
                    "loggedStaff",
                    staff);

            session.setAttribute(
                    "staffID",
                    staff.getStaffId());

            session.setAttribute(
                    "staffName",
                    staff.getStaffName());

            session.setAttribute(
                    "successMessage",
                    "Profile updated successfully.");
        } else {
            session.setAttribute(
                    "errorMessage",
                    "Unable to update profile.");
        }

        response.sendRedirect(
                request.getContextPath()
                + "/staff/dashboard");
    }

    private void archiveStaff(HttpServletRequest request,
                              HttpServletResponse response)
            throws IOException {

        String staffID =
                request.getParameter("staffID");

        boolean success =
                staffID != null
                && !staffID.trim().isEmpty()
                && staffDAO.archiveStaff(staffID.trim());

        if (success) {
            request.getSession().setAttribute(
                    "successMessage",
                    "Staff archived successfully.");
        } else {
            request.getSession().setAttribute(
                    "errorMessage",
                    "Unable to archive this staff.");
        }

        response.sendRedirect(
                request.getContextPath()
                + "/owner/view-staff");
    }

    private void restoreStaff(HttpServletRequest request,
                              HttpServletResponse response)
            throws IOException {

        String staffID =
                request.getParameter("staffID");

        boolean success =
                staffID != null
                && !staffID.trim().isEmpty()
                && staffDAO.restoreStaff(staffID.trim());

        if (success) {
            request.getSession().setAttribute(
                    "successMessage",
                    "Staff restored successfully.");
        } else {
            request.getSession().setAttribute(
                    "errorMessage",
                    "Unable to restore this staff.");
        }

        response.sendRedirect(
                request.getContextPath()
                + "/owner/view-archived-staff");
    }

    private void archiveGuest(HttpServletRequest request,
                              HttpServletResponse response)
            throws IOException {

        String guestID =
                request.getParameter("guestID");

        boolean success =
                guestID != null
                && !guestID.trim().isEmpty()
                && guestDAO.archiveGuest(guestID.trim());

        if (success) {
            request.getSession().setAttribute(
                    "successMessage",
                    "Guest archived successfully.");
        } else {
            request.getSession().setAttribute(
                    "errorMessage",
                    "Unable to archive this guest.");
        }

        response.sendRedirect(
                request.getContextPath()
                + "/owner/view-guest");
    }

    private void restoreGuest(HttpServletRequest request,
                              HttpServletResponse response)
            throws IOException {

        String guestID =
                request.getParameter("guestID");

        boolean success =
                guestID != null
                && !guestID.trim().isEmpty()
                && guestDAO.restoreGuest(guestID.trim());

        if (success) {
            request.getSession().setAttribute(
                    "successMessage",
                    "Guest restored successfully.");
        } else {
            request.getSession().setAttribute(
                    "errorMessage",
                    "Unable to restore this guest.");
        }

        response.sendRedirect(
                request.getContextPath()
                + "/owner/view-archived-guest");
    }

    private boolean isRole(HttpServletRequest request,
                           String requiredRole) {

        HttpSession session =
                request.getSession(false);

        if (session == null
                || session.getAttribute("role") == null) {
            return false;
        }

        String role =
                session.getAttribute("role")
                       .toString()
                       .trim();

        return requiredRole.equalsIgnoreCase(role);
    }

    private void openDashboard(
            HttpServletRequest request,
            HttpServletResponse response,
            String role)
            throws ServletException, IOException {

        request.setAttribute(
                "dashboardAnalytics",
                dashboardDAO.getDashboardAnalytics());
        request.setAttribute("dashboardRole", role);
        request.getRequestDispatcher("/dashboard.jsp")
               .forward(request, response);
    }

    private void downloadDashboardReport(HttpServletResponse response, String role)
            throws IOException {
        Map<String, Object> analytics = dashboardDAO.getDashboardAnalytics();
        byte[] pdf = createDashboardPdf(analytics, role);
        String date = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));

        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition",
                "attachment; filename=dashboard-report-" + date + ".pdf");
        response.setContentLength(pdf.length);
        response.getOutputStream().write(pdf);
    }

    @SuppressWarnings("unchecked")
    private byte[] createDashboardPdf(Map<String, Object> data, String role)
            throws IOException {
        List<String> lines = new ArrayList<>();
        lines.add("Cuti Murah Melaka - " + role + " Dashboard Report");
        lines.add("Generated: " + LocalDateTime.now().format(
                DateTimeFormatter.ofPattern("dd MMMM yyyy, hh:mm a", Locale.ENGLISH)));
        lines.add("");
        lines.add("DASHBOARD STATISTICS");
        lines.add("Total bookings: " + number(data, "totalBookings").intValue());
        lines.add("Total revenue: RM " + money(number(data, "totalRevenue").doubleValue()));
        lines.add("Total cancelled: " + number(data, "totalCancelled").intValue());
        lines.add("Active customers: " + number(data, "activeCustomers").intValue());
        lines.add("Active staff: " + number(data, "activeStaff").intValue());
        lines.add("Upcoming stays: " + number(data, "upcomingStays").intValue());
        lines.add("Average booking amount: RM "
                + money(number(data, "averageBookingAmount").doubleValue()));
        lines.add("Average days booked: "
                + String.format(Locale.US, "%.1f nights", number(data, "averageBookedDays").doubleValue()));
        lines.add("");
        lines.add("TOP 5 HIGHEST AVERAGE REVENUE");
        appendRanking(lines, (List<Map<String, Object>>) data.get("revenueByAccommodation"), "RM ");
        lines.add("");
        lines.add("TOP 5 LONGEST AVERAGE BOOKED DAYS");
        appendRanking(lines, (List<Map<String, Object>>) data.get("stayLengthByAccommodation"), "");
        lines.add("");
        long weekdays = number(data, "weekdayNights").longValue();
        long weekends = number(data, "weekendNights").longValue();
        long totalNights = weekdays + weekends;
        double weekdayPercent = totalNights == 0 ? 0 : weekdays * 100.0 / totalNights;
        double weekendPercent = totalNights == 0 ? 0 : weekends * 100.0 / totalNights;
        lines.add("WEEKDAY VS WEEKEND");
        lines.add(String.format(Locale.US, "Weekdays: %d nights (%.1f%%)", weekdays, weekdayPercent));
        lines.add(String.format(Locale.US, "Weekends: %d nights (%.1f%%)", weekends, weekendPercent));

        return buildSimplePdf(lines);
    }

    private Number number(Map<String, Object> data, String key) {
        Object value = data.get(key);
        return value instanceof Number ? (Number) value : 0;
    }

    private String money(double value) {
        return String.format(Locale.US, "%,.2f", value);
    }

    private void appendRanking(List<String> lines, List<Map<String, Object>> rows, String prefix) {
        if (rows == null || rows.isEmpty()) {
            lines.add("No data available.");
            return;
        }
        int rank = 1;
        for (Map<String, Object> row : rows) {
            double value = row.get("value") instanceof Number
                    ? ((Number) row.get("value")).doubleValue() : 0;
            String suffix = prefix.isEmpty() ? " nights" : "";
            lines.add(rank++ + ". " + row.get("label") + " - " + prefix
                    + String.format(Locale.US, "%,.2f", value) + suffix);
        }
    }

    private byte[] buildSimplePdf(List<String> lines) throws IOException {
        StringBuilder content = new StringBuilder("BT\n/F1 18 Tf\n50 790 Td\n");
        for (int i = 0; i < lines.size(); i++) {
            if (i == 1) content.append("/F1 10 Tf\n");
            if ("DASHBOARD STATISTICS".equals(lines.get(i))
                    || lines.get(i).startsWith("TOP 5")
                    || "WEEKDAY VS WEEKEND".equals(lines.get(i))) {
                content.append("/F1 13 Tf\n");
            }
            content.append('(').append(escapePdf(lines.get(i))).append(") Tj\n0 -20 Td\n");
            if (i > 1 && ("DASHBOARD STATISTICS".equals(lines.get(i))
                    || lines.get(i).startsWith("TOP 5")
                    || "WEEKDAY VS WEEKEND".equals(lines.get(i)))) {
                content.append("/F1 10 Tf\n");
            }
        }
        content.append("ET\n");

        List<byte[]> objects = new ArrayList<>();
        objects.add("<< /Type /Catalog /Pages 2 0 R >>".getBytes(StandardCharsets.US_ASCII));
        objects.add("<< /Type /Pages /Kids [3 0 R] /Count 1 >>".getBytes(StandardCharsets.US_ASCII));
        objects.add(("<< /Type /Page /Parent 2 0 R /MediaBox [0 0 595 842] "
                + "/Resources << /Font << /F1 5 0 R >> >> /Contents 4 0 R >>")
                .getBytes(StandardCharsets.US_ASCII));
        byte[] stream = content.toString().getBytes(StandardCharsets.US_ASCII);
        ByteArrayOutputStream streamObject = new ByteArrayOutputStream();
        streamObject.write(("<< /Length " + stream.length + " >>\nstream\n")
                .getBytes(StandardCharsets.US_ASCII));
        streamObject.write(stream);
        streamObject.write("endstream".getBytes(StandardCharsets.US_ASCII));
        objects.add(streamObject.toByteArray());
        objects.add("<< /Type /Font /Subtype /Type1 /BaseFont /Helvetica >>"
                .getBytes(StandardCharsets.US_ASCII));

        ByteArrayOutputStream pdf = new ByteArrayOutputStream();
        pdf.write("%PDF-1.4\n".getBytes(StandardCharsets.US_ASCII));
        List<Integer> offsets = new ArrayList<>();
        for (int i = 0; i < objects.size(); i++) {
            offsets.add(pdf.size());
            pdf.write(((i + 1) + " 0 obj\n").getBytes(StandardCharsets.US_ASCII));
            pdf.write(objects.get(i));
            pdf.write("\nendobj\n".getBytes(StandardCharsets.US_ASCII));
        }
        int xref = pdf.size();
        pdf.write(("xref\n0 " + (objects.size() + 1) + "\n")
                .getBytes(StandardCharsets.US_ASCII));
        pdf.write("0000000000 65535 f \n".getBytes(StandardCharsets.US_ASCII));
        for (Integer offset : offsets) {
            pdf.write(String.format(Locale.US, "%010d 00000 n \n", offset)
                    .getBytes(StandardCharsets.US_ASCII));
        }
        pdf.write(("trailer\n<< /Size " + (objects.size() + 1)
                + " /Root 1 0 R >>\nstartxref\n" + xref + "\n%%EOF")
                .getBytes(StandardCharsets.US_ASCII));
        return pdf.toByteArray();
    }

    private String escapePdf(String value) {
        String ascii = value == null ? "" : value.replaceAll("[^\\x20-\\x7E]", "?");
        return ascii.replace("\\", "\\\\").replace("(", "\\(").replace(")", "\\)");
    }

    private void redirectUnauthorized(
            HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {

        response.sendRedirect(
                request.getContextPath()
                + "/login.jsp?error=unauthorized");
    }
}
