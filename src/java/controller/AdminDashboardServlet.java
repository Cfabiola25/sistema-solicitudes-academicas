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
import java.util.Map;

/**
 * Controller for the administrator dashboard. It gathers
 * statistics across all requests (counts by status, monthly
 * approved counts) and displays a small list of pending
 * requests for quick access.
 */
@WebServlet(name = "AdminDashboardServlet", urlPatterns = {"/admin/dashboard"})
public class AdminDashboardServlet extends HttpServlet {
    private AdminDAO adminDAO = new AdminDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        Map<String, Integer> counts = adminDAO.getCountsByStatus();
        Map<Integer, Integer> monthly = adminDAO.getMonthlyApprovedCounts();
        List<Solicitud> pending = adminDAO.getAllRequests("Pendiente");
        if (pending.size() > 5) {
            pending = pending.subList(0, 5);
        }
        request.setAttribute("counts", counts);
        request.setAttribute("monthly", monthly);
        request.setAttribute("pending", pending);
        request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
    }
}