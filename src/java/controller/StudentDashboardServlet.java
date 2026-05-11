package controller;

import dao.StudentDAO;
import model.Solicitud;
import model.Student;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.Map;

/**
 * Controller for the student dashboard view. It aggregates the
 * student's request counts and recent submissions for display.
 */
@WebServlet(name = "StudentDashboardServlet", urlPatterns = {"/student/dashboard"})
public class StudentDashboardServlet extends HttpServlet {
    private StudentDAO studentDAO = new StudentDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"student".equals(session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        Student student = (Student) session.getAttribute("user");
        Map<String, Integer> counts = studentDAO.getCountsByStatus(student.getId());
        List<Solicitud> recent = studentDAO.getRecentRequests(student.getId(), 5);
        request.setAttribute("counts", counts);
        request.setAttribute("recent", recent);
        request.getRequestDispatcher("/student/dashboard.jsp").forward(request, response);
    }
}