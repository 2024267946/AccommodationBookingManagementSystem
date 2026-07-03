package controller;

import java.io.IOException;

import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import model.Guest;

@WebServlet(urlPatterns = {
        "/auth/login",
        "/auth/register",
        "/auth/logout"
})
public class LoginServlet extends HttpServlet {

    private UserDAO userDAO;

    public void init() {

        userDAO = new UserDAO();
    }
    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        String path =
                request.getServletPath();

        switch(path) {

            case "/auth/login":
                login(request,response);
                break;

            case "/auth/register":
                register(request,response);
                break;
        }
    }
    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        String path =
                request.getServletPath();

        if(path.equals("/auth/logout")) {

            logout(request,response);
        }
    }
    private void register(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException{

        Guest guest = new Guest();

        guest.setGuestName(
                request.getParameter("name"));

        guest.setGuestEmail(
                request.getParameter("email"));

        guest.setGuestPhoneNumber(
                request.getParameter("phone"));

        
        
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Password and Confirm Password do not match.");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        guest.setGuestPassword(password);
        

        boolean success = userDAO.registerGuest(guest);

        System.out.println("Register Success = " + success);

        if (success) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
        } else {
            response.sendRedirect(request.getContextPath() + "/register.jsp?error=1");
        }
    }
    private void login(
        HttpServletRequest request,
        HttpServletResponse response)
        throws ServletException, IOException {
        String email =
                request.getParameter("email");

        String password =
                request.getParameter("password");

        String role =
                userDAO.login(email,password);

        if(role != null) {

            HttpSession session =
                    request.getSession();

            session.setAttribute(
                    "role",
                    role);

            switch(role) {

                case "OWNER":

                	response.sendRedirect(request.getContextPath() + "/ownerDashboard.jsp");
                    break;

                case "STAFF":

                	response.sendRedirect(request.getContextPath() + "/staffDashboard.jsp");
                    break;

                case "GUEST":

                	response.sendRedirect(request.getContextPath() + "/homestays.jsp");

                    break;
            }

        } else {

        	request.setAttribute("error", "Invalid email or password.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }
    private void logout(
            HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {

        HttpSession session =
                request.getSession(false);

        if(session != null) {

            session.invalidate();
        }

        response.sendRedirect(request.getContextPath() + "/index.jsp");
    }
}