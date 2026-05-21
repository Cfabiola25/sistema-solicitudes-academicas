package controller;

import dao.SolicitudMensajeDAO;
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

/**
 * Shows detailed information about a specific request for a
 * student. If the request does not belong to the logged
 * student, the user is redirected to the list page.
 */
@WebServlet(name = "RequestDetailServlet", urlPatterns = {"/student/request-detail"})
public class RequestDetailServlet extends HttpServlet {
    private StudentDAO studentDAO = new StudentDAO();
    private SolicitudMensajeDAO mensajeDAO = new SolicitudMensajeDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"student".equals(session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        Student student = (Student) session.getAttribute("user");
        String idParam = request.getParameter("id");
        if (idParam == null) {
            response.sendRedirect(request.getContextPath() + "/student/requests");
            return;
        }
        int id;
        try {
            id = Integer.parseInt(idParam);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/student/requests");
            return;
        }
        Solicitud solicitud = studentDAO.getById(student.getId(), id);
        if (solicitud == null) {
            response.sendRedirect(request.getContextPath() + "/student/requests");
            return;
        }
        request.setAttribute("solicitud", solicitud);
        request.setAttribute("mensajes", mensajeDAO.getBySolicitudId(solicitud.getId()));
        request.getRequestDispatcher("/student/request_detail.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"student".equals(session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        Student student = (Student) session.getAttribute("user");
        String idParam = request.getParameter("id");
        String mensaje = request.getParameter("mensaje");
        if (idParam == null || mensaje == null || mensaje.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/student/requests");
            return;
        }
        int id;
        try {
            id = Integer.parseInt(idParam);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/student/requests");
            return;
        }
        Solicitud solicitud = studentDAO.getById(student.getId(), id);
        if (solicitud == null) {
            response.sendRedirect(request.getContextPath() + "/student/requests");
            return;
        }
        mensajeDAO.addMessage(id, "student", student.getNombreCompleto(), mensaje.trim());
        response.sendRedirect(request.getContextPath() + "/student/request-detail?id=" + id);
    }
}