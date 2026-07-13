package controller;

import java.io.IOException;

import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Guest;
import model.Staff;

@WebServlet(urlPatterns = {"/auth/login", "/auth/register", "/auth/logout", "/LogoutServlet"})
public class AuthenticationServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserDAO userDAO;

    @Override public void init() { userDAO = new UserDAO(); }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        if ("/auth/logout".equals(request.getServletPath())
                || "/LogoutServlet".equals(request.getServletPath())) {
            logout(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        switch (request.getServletPath()) {
            case "/auth/login": login(request, response); break;
            case "/auth/register": register(request, response); break;
            case "/auth/logout":
            case "/LogoutServlet": logout(request, response); break;
            default: response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private void register(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        Guest guest = new Guest();
        guest.setGuestName(request.getParameter("name"));
        guest.setGuestEmail(request.getParameter("email"));
        guest.setGuestPhoneNumber(request.getParameter("phone"));
        guest.setGuestPassword(request.getParameter("password"));
        response.sendRedirect(request.getContextPath()
                + (userDAO.registerGuest(guest)
                ? "/login.jsp?register=success" : "/register.jsp?error=1"));
    }

    private void login(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        if (isBlank(email) || isBlank(password)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=missing");
            return;
        }

        Guest guest = userDAO.loginGuest(email.trim(), password);
        if (guest != null) {
            HttpSession session = request.getSession(true);
            session.setAttribute("role", "GUEST");
            session.setAttribute("loggedGuest", guest);
            session.setAttribute("guestID", guest.getGuestId());
            session.setAttribute("guestName", guest.getGuestName());
            response.sendRedirect(request.getContextPath() + "/homepage.jsp");
            return;
        }

        Staff staff = userDAO.loginStaff(email.trim(), password);
        if (staff == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=1");
            return;
        }

        String role = staff.getStaffRoles();
        HttpSession session = request.getSession(true);
        session.setAttribute("role", role);
        session.setAttribute("loggedStaff", staff);
        session.setAttribute("staffID", staff.getStaffId());
        session.setAttribute("staffName", staff.getStaffName());

        if ("OWNER".equalsIgnoreCase(role)) {
            response.sendRedirect(request.getContextPath() + "/owner/dashboard");
        } else if ("STAFF".equalsIgnoreCase(role)) {
            response.sendRedirect(request.getContextPath() + "/staff/dashboard");
        } else {
            session.invalidate();
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=invalidRole");
        }
    }

    private void logout(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession(false);
        if (session != null) session.invalidate();
        response.sendRedirect(request.getContextPath() + "/index.jsp");
    }

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }
}
