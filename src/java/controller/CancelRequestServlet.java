package controller;

import dao.StudentDAO;
import model.Student;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

/**
 * Allows a student to cancel/anull one of their own requests
 * while it is still in Enviada or Pendiente status.
 */
@WebServlet(name = "CancelRequestServlet", urlPatterns = {"/student/cancel-request"})
public class CancelRequestServlet extends HttpServlet {

    private final StudentDAO studentDAO = new StudentDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || !"student".equals(session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Student student = (Student) session.getAttribute("user");
        Integer requestId = parseInteger(request.getParameter("id"));

        if (student == null || requestId == null || requestId <= 0) {
            response.sendRedirect(request.getContextPath() + "/student/requests");
            return;
        }

        studentDAO.cancelRequest(student.getId(), requestId);

        response.sendRedirect(request.getContextPath() + "/student/requests");
    }

    /**
     * Safely converts a string parameter to Integer.
     */
    private Integer parseInteger(String value) {
        if (value == null || value.trim().isEmpty()) {
            return null;
        }

        try {
            return Integer.parseInt(value.trim());
        } catch (NumberFormatException e) {
            return null;
        }
    }
}