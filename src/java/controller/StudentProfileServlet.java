package controller;

import model.Student;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

/**
 * Shows the profile information of the logged-in student.
 */
@WebServlet(name = "StudentProfileServlet", urlPatterns = {"/student/profile"})
public class StudentProfileServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || !"student".equals(session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Student student = (Student) session.getAttribute("user");

        if (student == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        request.setAttribute("student", student);
        request.getRequestDispatcher("/student/profile.jsp").forward(request, response);
    }
}