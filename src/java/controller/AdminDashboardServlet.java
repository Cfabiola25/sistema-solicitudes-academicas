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
 * statistics across all requests, monthly approved counts,
 * expired requests, about-to-expire requests and a small list
 * of pending requests for quick access.
 */
@WebServlet(name = "AdminDashboardServlet", urlPatterns = {"/admin/dashboard"})
public class AdminDashboardServlet extends HttpServlet {

    private final AdminDAO adminDAO = new AdminDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (!isAdminSession(session)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Map<String, Integer> counts = adminDAO.getCountsByStatus();
        Map<Integer, Integer> monthly = adminDAO.getMonthlyApprovedCounts();

        int expiredCount = adminDAO.getExpiredRequestsCount();
        int aboutToExpireCount = adminDAO.getAboutToExpireRequestsCount();

        List<Solicitud> pending = adminDAO.getAllRequestsPaged("Pendiente", 1, 5);

        request.setAttribute("counts", counts);
        request.setAttribute("monthly", monthly);
        request.setAttribute("pending", pending);
        request.setAttribute("expiredCount", expiredCount);
        request.setAttribute("aboutToExpireCount", aboutToExpireCount);

        request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
    }

    /**
     * Validates that the current session belongs to an administrator.
     */
    private boolean isAdminSession(HttpSession session) {
        return session != null && "admin".equals(session.getAttribute("role"));
    }
}