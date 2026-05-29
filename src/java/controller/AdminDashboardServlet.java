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

        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");

        Map<String, Integer> counts = adminDAO.getCountsByStatus(startDate, endDate);
        Map<Integer, Integer> monthlyCreated = adminDAO.getMonthlyRequestCounts(startDate, endDate);
        Map<Integer, Integer> monthly = adminDAO.getMonthlyApprovedCounts(startDate, endDate);

        // For total requests we could pass date filters too, but let's assume we modify getRequestsCount 
        // to not take dates for now, or we can just calculate it from the counts map like in AdminReportsServlet.
        int total = calculateTotal(counts);
        int openCount = adminDAO.getOpenRequestsCount(startDate, endDate);
        int closedCount = adminDAO.getClosedRequestsCount(startDate, endDate);
        int createdThisMonth = adminDAO.getRequestsCreatedThisMonthCount(startDate, endDate);
        double averageResolutionDays = adminDAO.getAverageResolutionDays(startDate, endDate);
        int expiredCount = adminDAO.getExpiredRequestsCount(startDate, endDate);
        int aboutToExpireCount = adminDAO.getAboutToExpireRequestsCount(startDate, endDate);

        List<Solicitud> pending = adminDAO.getAllRequestsPaged("Pendiente", 1, 5);
        List<Object[]> topTypes = adminDAO.getTopRequestTypes(5, startDate, endDate);
        List<Object[]> topPrograms = adminDAO.getTopPrograms(5, startDate, endDate);

        request.setAttribute("startDate", startDate);
        request.setAttribute("endDate", endDate);
        request.setAttribute("counts", counts);
        request.setAttribute("monthlyCreated", monthlyCreated);
        request.setAttribute("monthly", monthly);
        request.setAttribute("total", total);
        request.setAttribute("openCount", openCount);
        request.setAttribute("closedCount", closedCount);
        request.setAttribute("createdThisMonth", createdThisMonth);
        request.setAttribute("averageResolutionDays", averageResolutionDays);
        request.setAttribute("pending", pending);
        request.setAttribute("topTypes", topTypes);
        request.setAttribute("topPrograms", topPrograms);
        request.setAttribute("expiredCount", expiredCount);
        request.setAttribute("aboutToExpireCount", aboutToExpireCount);

        request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
    }

    private int calculateTotal(Map<String, Integer> counts) {
        int total = 0;
        if (counts != null) {
            for (Integer value : counts.values()) {
                if (value != null) {
                    total += value;
                }
            }
        }
        return total;
    }

    /**
     * Validates that the current session belongs to an administrator.
     */
    private boolean isAdminSession(HttpSession session) {
        return session != null && "admin".equals(session.getAttribute("role"));
    }
}