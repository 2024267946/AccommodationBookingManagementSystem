package controller;

import dao.StaffDAO;
import dao.GuestDAO;
import model.Staff;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(urlPatterns = {
        "/owner/dashboard",
        "/staff/create-staff",
        "/staff/view-staff",
        "/staff/update",
        "/staff/archive-staff",
        "/staff/view-guest",
        "/staff/archive-guest"
})
public class StaffServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private StaffDAO staffDAO = new StaffDAO();
    private GuestDAO guestDAO = new GuestDAO();

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String path = request.getServletPath();

        switch (path) {
            case "/owner/dashboard":
                request.setAttribute("staffList", staffDAO.getAllStaff());
                request.setAttribute("guestList", guestDAO.getAllGuest());
                request.getRequestDispatcher("/Owner/OwnerDashboard.jsp").forward(request, response);
                break;

            case "/staff/create-staff":
                request.getRequestDispatcher("/Owner/createStaff.jsp").forward(request, response);
                break;

            case "/staff/view-staff":
                request.setAttribute("staffList", staffDAO.getAllStaff());
                request.getRequestDispatcher("/Owner/viewStaff.jsp").forward(request, response);
                break;

            case "/staff/update":
                String staffID = request.getParameter("staffID");
                Staff staff = staffDAO.getStaffByID(staffID);
                request.setAttribute("staff", staff);
                request.getRequestDispatcher("/Owner/updateStaff.jsp").forward(request, response);
                break;

            case "/staff/archive-staff":
                String deleteStaffID = request.getParameter("staffID");
                boolean staffDeleted = staffDAO.deleteStaff(deleteStaffID);

                if (!staffDeleted) {
                    request.getSession().setAttribute("errorMessage",
                            "Cannot delete this staff because the record is used in another table.");
                }

                response.sendRedirect(request.getContextPath() + "/staff/view-staff");
                break;

            case "/staff/view-guest":
                request.setAttribute("guestList", guestDAO.getAllGuest());
                request.getRequestDispatcher("/Owner/viewGuest.jsp").forward(request, response);
                break;

            case "/staff/archive-guest":
                String guestID = request.getParameter("guestID");
                boolean guestDeleted = guestDAO.deleteGuest(guestID);

                if (!guestDeleted) {
                    request.getSession().setAttribute("errorMessage",
                            "Cannot delete this guest because the record is used in another table.");
                }

                response.sendRedirect(request.getContextPath() + "/staff/view-guest");
                break;
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String path = request.getServletPath();

        if (path.equals("/staff/create-staff")) {

            Staff staff = new Staff();

            staff.setStaffName(request.getParameter("staffName"));
            staff.setStaffPassword(request.getParameter("staffPassword"));
            staff.setStaffEmail(request.getParameter("staffEmail"));
            staff.setStaffPhoneNumber(request.getParameter("staffPhoneNumber"));
            staff.setStaffRoles(request.getParameter("staffRoles"));

            staffDAO.addStaff(staff);

            response.sendRedirect(request.getContextPath() + "/staff/view-staff");

        } else if (path.equals("/staff/update")) {

            Staff staff = new Staff();

            staff.setStaffId(request.getParameter("staffID"));
            staff.setStaffName(request.getParameter("staffName"));
            staff.setStaffPassword(request.getParameter("staffPassword"));
            staff.setStaffEmail(request.getParameter("staffEmail"));
            staff.setStaffPhoneNumber(request.getParameter("staffPhoneNumber"));
            staff.setStaffRoles(request.getParameter("staffRoles"));

            staffDAO.updateStaff(staff);

            response.sendRedirect(request.getContextPath() + "/staff/view-staff");
        }
    }
}