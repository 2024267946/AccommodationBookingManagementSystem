package controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import model.Profile;
import model.Guest;
import model.Staff;
import dao.ProfileDAO;

@WebServlet(urlPatterns = {
    "/profile",
    "/profile/edit",
    "/Owner/myProfile",
    "/profile/update-profile",
    "/profile/reset-password"
})
public class ProfileServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ProfileDAO profileDAO;

    public void init() {
        profileDAO = new ProfileDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String path = request.getServletPath();
        
        if (path.equals("/profile") || path.equals("/profile/edit")
                || path.equals("/Owner/myProfile")) {
            displayProfile(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String path = request.getServletPath();
        
        if (path.equals("/profile/update-profile")) {
            executeProfileUpdate(request, response);
        } else if (path.equals("/profile/reset-password")) {
            resetPassword(request, response);
        }
    }

    private void displayProfile(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        // Safety validation fallback
        if (session == null || session.getAttribute("role") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String role = (String) session.getAttribute("role");
        String userId = "GUEST".equalsIgnoreCase(role)
                ? (String) session.getAttribute("guestID")
                : (String) session.getAttribute("staffID");
        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=unauthorized");
            return;
        }

        Profile userProfile = profileDAO.getProfileById(userId, role);
        if (userProfile == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=profileNotFound");
            return;
        }
        request.setAttribute("profile", userProfile);
        String path = request.getServletPath();
        String view = "/profile/edit".equals(path)
                ? "/editAccount.jsp"
                : ("OWNER".equalsIgnoreCase(role) ? "/Owner/myProfile.jsp" : "/profile.jsp");
        request.getRequestDispatcher(view).forward(request, response);
    }

    private void executeProfileUpdate(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("role") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String role = (String) session.getAttribute("role");
        String profilePath = "OWNER".equalsIgnoreCase(role) ? "/Owner/myProfile"
                : ("STAFF".equalsIgnoreCase(role) ? "/staff/my-profile" : "/profile");
        String userId = "GUEST".equalsIgnoreCase(role)
                ? (String) session.getAttribute("guestID")
                : (String) session.getAttribute("staffID");
        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=unauthorized");
            return;
        }
        
        String name = request.getParameter("fullName");
        String phone = request.getParameter("phone");
        String email = request.getParameter("email"); // Added: Retrieve email parameter
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        // Updated: Validate that the email field is not missing or empty
        if (name == null || name.trim().isEmpty()
                || phone == null || phone.trim().isEmpty()
                || email == null || email.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath()
                    + ("GUEST".equalsIgnoreCase(role)
                        ? "/profile/edit?error=invalidProfile"
                        : profilePath + "?error=invalidProfile"));
            return;
        }
        name = name.trim();
        phone = phone.trim();
        email = email.trim(); // Added: Trim whitespace from email

        boolean changingPassword = !isBlank(newPassword) || !isBlank(confirmPassword);
        if (changingPassword && (isBlank(newPassword) || isBlank(confirmPassword)
                || newPassword.length() < 6 || !newPassword.equals(confirmPassword))) {
            response.sendRedirect(request.getContextPath()
                    + ("GUEST".equalsIgnoreCase(role)
                        ? "/profile/edit?error=passwordMismatch"
                        : profilePath + "?error=passwordMismatch"));
            return;
        }

        Profile currentProfile = profileDAO.getProfileById(userId, role);
        if (currentProfile == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=profileNotFound");
            return;
        }

        Profile updatedProfile = new Profile();
        updatedProfile.setId(userId);
        updatedProfile.setName(name);
        updatedProfile.setPhone(phone);
        updatedProfile.setEmail(email); // Updated: Pass the new form email instead of the old one
        updatedProfile.setPassword(changingPassword ? newPassword : null);
        updatedProfile.setRole(role);

        boolean success = profileDAO.updateProfile(updatedProfile);

        if (success) {
            session.setAttribute("staffName", name);
            session.setAttribute("guestName", name);
            Object loggedGuest = session.getAttribute("loggedGuest");
            if (loggedGuest instanceof Guest) {
                ((Guest) loggedGuest).setGuestName(name);
                ((Guest) loggedGuest).setGuestPhoneNumber(phone);
                ((Guest) loggedGuest).setGuestEmail(email); // Added: Update email inside guest session object
            }
            Object loggedStaff = session.getAttribute("loggedStaff");
            if (loggedStaff instanceof Staff) {
                ((Staff) loggedStaff).setStaffName(name);
                ((Staff) loggedStaff).setStaffPhoneNumber(phone);
                ((Staff) loggedStaff).setStaffEmail(email); // Added: Update email inside staff session object
            }
            response.sendRedirect(request.getContextPath()
                    + profilePath + "?updateSuccess=true");
        } else {
            response.sendRedirect(request.getContextPath()
                    + ("GUEST".equalsIgnoreCase(role)
                        ? "/profile/edit?error=updatefailed"
                        : profilePath + "?error=updatefailed"));
        }
    }

    private void resetPassword(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("role") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=unauthorized");
            return;
        }
        String role = String.valueOf(session.getAttribute("role"));
        String userId = "GUEST".equalsIgnoreCase(role)
                ? (String) session.getAttribute("guestID") : (String) session.getAttribute("staffID");
        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=unauthorized");
            return;
        }
        String returnPath = "GUEST".equalsIgnoreCase(role) ? "/profile"
                : ("OWNER".equalsIgnoreCase(role) ? "/Owner/myProfile" : "/staff/my-profile");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");
        if (isBlank(newPassword) || isBlank(confirmPassword)) {
            response.sendRedirect(request.getContextPath() + returnPath + "?passwordError=missing");
            return;
        }
        if (newPassword.length() < 6) {
            response.sendRedirect(request.getContextPath() + returnPath + "?passwordError=short");
            return;
        }
        if (!newPassword.equals(confirmPassword)) {
            response.sendRedirect(request.getContextPath() + returnPath + "?passwordError=mismatch");
            return;
        }
        boolean success = profileDAO.resetPassword(userId, role, newPassword);
        response.sendRedirect(request.getContextPath()
                + returnPath + (success ? "?passwordUpdated=true" : "?passwordError=failed"));
    }

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }
}
