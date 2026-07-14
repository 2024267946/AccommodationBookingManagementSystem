package controller;

import java.io.IOException;
import dao.ProfileDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Guest;
import model.Profile;

@WebServlet(urlPatterns = {
    "/profile", "/profile/edit", "/profile/update-profile", "/profile/reset-password"
})
public class GuestServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ProfileDAO profileDAO;

    @Override
    public void init() {
        profileDAO = new ProfileDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!isGuest(request)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=unauthorized");
            return;
        }
        displayProfile(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!isGuest(request)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=unauthorized");
            return;
        }
        if ("/profile/update-profile".equals(request.getServletPath())) {
            updateProfile(request, response);
        } else if ("/profile/reset-password".equals(request.getServletPath())) {
            resetPassword(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private void displayProfile(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String guestId = (String) request.getSession(false).getAttribute("guestID");
        Profile profile = profileDAO.getProfileById(guestId, "GUEST");
        if (profile == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=profileNotFound");
            return;
        }
        request.setAttribute("profile", profile);
        request.getRequestDispatcher("/profile/edit".equals(request.getServletPath())
                ? "/editAccount.jsp" : "/profile.jsp").forward(request, response);
    }

    private void updateProfile(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession(false);
        String guestId = (String) session.getAttribute("guestID");
        String name = request.getParameter("fullName");
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");
        if (isBlank(name) || isBlank(phone) || isBlank(email)) {
            response.sendRedirect(request.getContextPath() + "/profile/edit?error=invalidProfile");
            return;
        }
        
        ProfileDAO profileDAO = new ProfileDAO();

     // Perform the global uniqueness check
     if (profileDAO.isEmailTaken(email.trim(), guestId)) {
         response.sendRedirect(request.getContextPath() + "/profile/edit?error=emailAlreadyTaken");
         return;
     }
     
        boolean changingPassword = !isBlank(newPassword) || !isBlank(confirmPassword);
        if (changingPassword && (isBlank(newPassword) || isBlank(confirmPassword)
                || newPassword.length() < 6 || !newPassword.equals(confirmPassword))) {
            response.sendRedirect(request.getContextPath() + "/profile/edit?error=passwordMismatch");
            return;
        }
        Profile profile = new Profile();
        profile.setId(guestId);
        profile.setName(name.trim());
        profile.setPhone(phone.trim());
        profile.setEmail(email.trim());
        profile.setPassword(changingPassword ? newPassword : null);
        profile.setRole("GUEST");
        if (!profileDAO.updateProfile(profile)) {
            response.sendRedirect(request.getContextPath() + "/profile/edit?error=updatefailed");
            return;
        }
        session.setAttribute("guestName", profile.getName());
        Object loggedGuest = session.getAttribute("loggedGuest");
        if (loggedGuest instanceof Guest) {
            Guest guest = (Guest) loggedGuest;
            guest.setGuestName(profile.getName());
            guest.setGuestEmail(profile.getEmail());
            guest.setGuestPhoneNumber(profile.getPhone());
        }
        response.sendRedirect(request.getContextPath() + "/profile?updateSuccess=true");
    }

    private void resetPassword(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String password = request.getParameter("newPassword");
        String confirmation = request.getParameter("confirmPassword");
        if (isBlank(password) || isBlank(confirmation) || password.length() < 6
                || !password.equals(confirmation)) {
            response.sendRedirect(request.getContextPath() + "/profile?passwordError=invalid");
            return;
        }
        String guestId = (String) request.getSession(false).getAttribute("guestID");
        boolean success = profileDAO.resetPassword(guestId, "GUEST", password);
        response.sendRedirect(request.getContextPath()
                + (success ? "/profile?passwordUpdated=true" : "/profile?passwordError=failed"));
    }

    private boolean isGuest(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return session != null && "GUEST".equalsIgnoreCase(String.valueOf(session.getAttribute("role")))
                && session.getAttribute("guestID") != null;
    }

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }
}
