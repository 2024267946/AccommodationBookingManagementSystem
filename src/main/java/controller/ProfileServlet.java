package controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import model.Profile;
import dao.ProfileDAO;

@WebServlet(urlPatterns = {
    "/profile",
    "/profile/edit",
    "/Owner/myProfile",
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
        String userId = "GUEST".equalsIgnoreCase(role)
                ? (String) session.getAttribute("guestID")
                : (String) session.getAttribute("staffID");
        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=unauthorized");
            return;
        }
        String name = request.getParameter("fullName");
        String phone = request.getParameter("phone");
        String password = request.getParameter("password");

        Profile currentProfile = profileDAO.getProfileById(userId, role);
        if (currentProfile == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=profileNotFound");
            return;
        }

        Profile updatedProfile = new Profile();
        updatedProfile.setId(userId);
        updatedProfile.setName(name);
        updatedProfile.setPhone(phone);
        updatedProfile.setEmail(currentProfile.getEmail());
        updatedProfile.setPassword(password);
        updatedProfile.setRole(role);

        boolean success = profileDAO.updateProfile(updatedProfile);

        if (success) {
            session.setAttribute("staffName", name);
            session.setAttribute("guestName", name);
            response.sendRedirect(request.getContextPath()
                    + ("OWNER".equalsIgnoreCase(role)
                        ? "/Owner/myProfile?updateSuccess=true"
                        : "/profile?updateSuccess=true"));
        } else {
            response.sendRedirect(request.getContextPath() + "/profile/edit?error=updatefailed");
        }
    }
}
