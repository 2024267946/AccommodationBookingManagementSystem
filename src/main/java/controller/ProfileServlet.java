package controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import model.Profile;
import dao.ProfileDAO;

@WebServlet(urlPatterns = {
    "/profile",
    "/profile/update-profile"
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
        
        if (path.equals("/profile")) {
            displayProfile(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String path = request.getServletPath();
        
        if (path.equals("/profile/update-profile")) {
            executeProfileUpdate(request, response);
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

        // Pull active logged-in parameters from context
        String email = (String) session.getAttribute("email"); 
        String role = (String) session.getAttribute("role");

        // Temporary test driver seed if your LoginServlet hasn't saved the email attribute to session yet
        if (email == null) {
            email = "jane@email.com"; // Default matching profile.jsp template layout
        }

        Profile userProfile = profileDAO.getProfileByEmail(email, role);
        request.setAttribute("profile", userProfile);
        
        // Forward target contextual data to front view layout
        request.getRequestDispatcher("/profile.jsp").forward(request, response);
    }

    private void executeProfileUpdate(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("role") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        int userId = Integer.parseInt(request.getParameter("userId"));
        String name = request.getParameter("fullName");
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String role = (String) session.getAttribute("role");

        Profile updatedProfile = new Profile();
        updatedProfile.setId(userId);
        updatedProfile.setName(name);
        updatedProfile.setPhone(phone);
        updatedProfile.setEmail(email);
        updatedProfile.setPassword(password);
        updatedProfile.setRole(role);

        boolean success = profileDAO.updateProfile(updatedProfile);

        if (success) {
            // Update email inside session state context if changed
            session.setAttribute("email", email);
            response.sendRedirect(request.getContextPath() + "/profile");
        } else {
            response.sendRedirect(request.getContextPath() + "/editAccount.jsp?error=updatefailed");
        }
    }
}