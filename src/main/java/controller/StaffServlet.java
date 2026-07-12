package controller;

import java.io.IOException;
import java.util.List;

import dao.GuestDAO;
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
    "/staff/view-staff",
    "/staff/view-guest",
    "/staff/update"
})
public class StaffServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private StaffDAO staffDAO;
    private GuestDAO guestDAO;

    @Override
    public void init() {
        staffDAO = new StaffDAO();
        guestDAO = new GuestDAO();
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

                request.setAttribute("staffList", staffDAO.getAllStaff());
                request.setAttribute("guestList", guestDAO.getAllGuest());

                request.setAttribute(
                        "archivedStaffCount",
                        staffDAO.getArchivedStaffCount());

                request.setAttribute(
                        "archivedGuestCount",
                        guestDAO.getArchivedGuestCount());

                request.setAttribute(
                        "archivedStaffList",
                        staffDAO.getArchivedStaff());

                request.setAttribute(
                        "archivedGuestList",
                        guestDAO.getArchivedGuests());

                request.getRequestDispatcher("/Owner/dashboard.jsp")
                       .forward(request, response);
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

                request.setAttribute(
                        "totalGuest",
                        guestDAO.getTotalGuest());

                request.setAttribute(
                        "totalStaff",
                        staffDAO.getTotalStaff());

                request.getRequestDispatcher(
                        "/Staff/StaffDashboard.jsp")
                       .forward(request, response);
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

    private void redirectUnauthorized(
            HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {

        response.sendRedirect(
                request.getContextPath()
                + "/login.jsp?error=unauthorized");
    }
}
