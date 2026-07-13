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
        String returnTo = safeReturnTo(request.getParameter("returnTo"));
        String name = request.getParameter("name");
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        if (isBlank(name) || isBlank(phone) || isBlank(email)
                || isBlank(password) || isBlank(confirmPassword)) {
            response.sendRedirect(request.getContextPath() + appendReturn("/register.jsp?error=missing", returnTo));
            return;
        }
        if (!password.equals(confirmPassword)) {
            response.sendRedirect(request.getContextPath() + appendReturn("/register.jsp?error=mismatch", returnTo));
            return;
        }
        if (password.length() < 6) {
            response.sendRedirect(request.getContextPath() + appendReturn("/register.jsp?error=short", returnTo));
            return;
        }
        if (userDAO.emailExists(email.trim())) {
            response.sendRedirect(request.getContextPath() + appendReturn("/register.jsp?error=emailExists", returnTo));
            return;
        }
        Guest guest = new Guest();
        guest.setGuestName(name.trim());
        guest.setGuestEmail(email.trim());
        guest.setGuestPhoneNumber(phone.trim());
        guest.setGuestPassword(password);
        response.sendRedirect(request.getContextPath()
                + (userDAO.registerGuest(guest)
                ? appendReturn("/register.jsp?register=success", returnTo)
                : appendReturn("/register.jsp?error=failed", returnTo)));
    }

    private void login(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String returnTo = safeReturnTo(request.getParameter("returnTo"));
        if (isBlank(email) || isBlank(password)) {
            response.sendRedirect(request.getContextPath() + appendReturn("/login.jsp?error=missing", returnTo));
            return;
        }

        Guest guest = userDAO.loginGuest(email.trim(), password);
        if (guest != null) {
            HttpSession session = request.getSession(true);
            session.setMaxInactiveInterval(300);
            session.setAttribute("role", "GUEST");
            session.setAttribute("loggedGuest", guest);
            session.setAttribute("guestID", guest.getGuestId());
            session.setAttribute("guestName", guest.getGuestName());
            response.sendRedirect(request.getContextPath()
                    + (returnTo == null ? "/homepage.jsp" : returnTo));
            return;
        }

        Staff staff = userDAO.loginStaff(email.trim(), password);
        if (staff == null) {
            response.sendRedirect(request.getContextPath() + appendReturn("/login.jsp?error="
                    + (userDAO.emailExists(email.trim()) ? "incorrect" : "notFound"), returnTo));
            return;
        }

        String role = staff.getStaffRoles();
        HttpSession session = request.getSession(true);
        session.setMaxInactiveInterval(300);
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

    private String safeReturnTo(String value) {
        return value != null && value.startsWith("/booking?") && !value.contains("\r")
                && !value.contains("\n") ? value : null;
    }

    private String appendReturn(String path, String returnTo) {
        return returnTo == null ? path : path + "&returnTo="
                + java.net.URLEncoder.encode(returnTo, java.nio.charset.StandardCharsets.UTF_8);
    }
}
