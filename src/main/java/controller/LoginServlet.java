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
    private void register(
            HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {

        Guest guest = new Guest();

        guest.setGuestName(
                request.getParameter("name"));

        guest.setGuestEmail(
                request.getParameter("email"));

        guest.setGuestPhoneNumber(
                request.getParameter("phone"));

        guest.setGuestPassword(
                request.getParameter("password"));

        boolean success =
                userDAO.registerGuest(guest);

        if(success) {

            response.sendRedirect(
                "login.jsp");

        } else {

            response.sendRedirect(
                    "register.jsp?error=1");
        }
    }
    private void login(
            HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {

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

                    response.sendRedirect(
                            "ownerDashboard.jsp");
                    break;

                case "STAFF":

                    response.sendRedirect(
                            "staffDashboard.jsp");
                    break;

                case "GUEST":

                    response.sendRedirect(
                            "guestDashboard.jsp");
                    break;
            }

        } else {

            response.sendRedirect(
                    "login.jsp?error=1");
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

        response.sendRedirect(
                "index.jsp");
    }
}