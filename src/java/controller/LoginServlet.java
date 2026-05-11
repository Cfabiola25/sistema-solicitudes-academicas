package controller;

import dao.AdminDAO;
import dao.StudentDAO;
import model.Admin;
import model.Student;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Handles the authentication process for both students and
 * administrators. Determines the role selected by the user,
 * validates credentials and forwards to the appropriate
 * dashboard on success.
 */
@WebServlet(name = "LoginServlet", urlPatterns = {"/login"})
public class LoginServlet extends HttpServlet {
    private StudentDAO studentDAO = new StudentDAO();
    private AdminDAO adminDAO = new AdminDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String role = request.getParameter("role");

        HttpSession session = request.getSession();
        session.invalidate(); // reset any previous session
        session = request.getSession(true);

        if ("student".equals(role)) {
            Student student = studentDAO.login(email, password);
            if (student != null) {
                session.setAttribute("user", student);
                session.setAttribute("role", "student");
                response.sendRedirect(request.getContextPath() + "/student/dashboard");
                return;
            }
        } else if ("admin".equals(role)) {
            Admin admin = adminDAO.login(email, password);
            if (admin != null) {
                session.setAttribute("user", admin);
                session.setAttribute("role", "admin");
                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
                return;
            }
        }
        // invalid credentials
        request.setAttribute("error", "Credenciales inválidas. Intenta nuevamente.");
        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }
}