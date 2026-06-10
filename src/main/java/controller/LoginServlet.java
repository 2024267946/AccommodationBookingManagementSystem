package controller;

import model.User;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

// Notice these are now "jakarta" instead of "javax"
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private List<User> mockDatabase;

    @Override
    public void init() throws ServletException {
        mockDatabase = new ArrayList<>();
        mockDatabase.add(new User("O-001", "Encik Ridzuan", "owner@dgrimbun.com", "password", "owner", "012-3456789"));
        mockDatabase.add(new User("S-001", "Staff Member", "staff@dgrimbun.com", "password", "staff", "013-3456789"));
        mockDatabase.add(new User("G-001", "Guest User", "guest@dgrimbun.com", "password", "guest", "011-1111111"));
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        
        User authenticatedUser = null;

        for (User user : mockDatabase) {
            if (user.getEmail().equals(email) && user.getPassword().equals(password)) {
                authenticatedUser = user;
                break;
            }
        }

        if (authenticatedUser != null) {
            HttpSession session = request.getSession();
            session.setAttribute("currentUser", authenticatedUser);
            
            if ("owner".equals(authenticatedUser.getRole()) || "staff".equals(authenticatedUser.getRole())) {
                response.sendRedirect("dashboard.jsp"); 
            } else {
                response.sendRedirect("index.jsp"); 
            }
        } else {
            request.setAttribute("errorMessage", "Invalid email or password. Please try again.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}