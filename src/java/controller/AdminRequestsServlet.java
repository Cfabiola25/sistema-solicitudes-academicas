package controller;

import dao.AdminDAO;
import model.Solicitud;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

/**
 * Displays all requests to the administrator with optional
 * filtering by status via the 'state' request parameter.
 */
@WebServlet(name = "AdminRequestsServlet", urlPatterns = {"/admin/requests"})
public class AdminRequestsServlet extends HttpServlet {
    private AdminDAO adminDAO = new AdminDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        String state = request.getParameter("state");
        List<Solicitud> list = adminDAO.getAllRequests(state);
        request.setAttribute("list", list);
        request.setAttribute("selectedState", state);
        request.getRequestDispatcher("/admin/requests.jsp").forward(request, response);
    }
}