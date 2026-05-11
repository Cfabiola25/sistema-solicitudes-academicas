package controller;

import dao.StudentDAO;
import dao.TipoSolicitudDAO;
import model.Solicitud;
import model.Student;
import model.TipoSolicitud;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

/**
 * Displays the list of requests submitted by the current student.
 * Supports optional filtering by status using the 'state'
 * request parameter.
 */
@WebServlet(name = "MyRequestsServlet", urlPatterns = {"/student/requests"})
public class MyRequestsServlet extends HttpServlet {
    private StudentDAO studentDAO = new StudentDAO();
    private TipoSolicitudDAO tipoDAO = new TipoSolicitudDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"student".equals(session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        Student student = (Student) session.getAttribute("user");
        String state = request.getParameter("state");
        List<Solicitud> list = studentDAO.getAllRequests(student.getId(), state);
        List<TipoSolicitud> tipos = tipoDAO.getAll();
        request.setAttribute("list", list);
        request.setAttribute("selectedState", state);
        request.setAttribute("tipos", tipos);
        request.getRequestDispatcher("/student/my_requests.jsp").forward(request, response);
    }
}