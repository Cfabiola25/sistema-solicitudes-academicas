package controller;

import dao.AdminDAO;
import model.Admin;
import model.Solicitud;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Allows an administrator to view and respond to a specific
 * request. The GET method shows the details and the POST
 * method updates the request status and adds a comment.
 */
@WebServlet(name = "AdminRequestDetailServlet", urlPatterns = {"/admin/request-detail"})
public class AdminRequestDetailServlet extends HttpServlet {
    private AdminDAO adminDAO = new AdminDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        String idParam = request.getParameter("id");
        if (idParam == null) {
            response.sendRedirect(request.getContextPath() + "/admin/requests");
            return;
        }
        int id;
        try {
            id = Integer.parseInt(idParam);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/requests");
            return;
        }
        Solicitud solicitud = adminDAO.getRequestById(id);
        if (solicitud == null) {
            response.sendRedirect(request.getContextPath() + "/admin/requests");
            return;
        }
        request.setAttribute("solicitud", solicitud);
        request.getRequestDispatcher("/admin/request_detail.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        int id = Integer.parseInt(request.getParameter("id"));
        String newState = request.getParameter("newState");
        String comentario = request.getParameter("comentario");
        Admin admin = (Admin) session.getAttribute("user");
        if (newState != null && (newState.equals("Aprobada") || newState.equals("Rechazada"))) {
            adminDAO.updateStatus(id, newState, comentario, admin.getId());
        }
        response.sendRedirect(request.getContextPath() + "/admin/request-detail?id=" + id);
    }
}