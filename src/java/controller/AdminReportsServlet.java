package controller;

import dao.AdminDAO;
import model.Solicitud;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;
import java.util.Map;

/**
 * Displays administrative reports and general request metrics.
 */
@WebServlet(name = "AdminReportsServlet", urlPatterns = {"/admin/reports"})
public class AdminReportsServlet extends HttpServlet {

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

        int total = calculateTotal(counts);
        int open = adminDAO.getOpenRequestsCount(startDate, endDate);
        int closed = adminDAO.getClosedRequestsCount(startDate, endDate);
        int createdThisMonth = adminDAO.getRequestsCreatedThisMonthCount(startDate, endDate);
        int sent = counts.getOrDefault("Enviada", 0);
        int pending = counts.getOrDefault("Pendiente", 0);
        int approved = counts.getOrDefault("Aprobada", 0);
        int rejected = counts.getOrDefault("Rechazada", 0);
        int expired = adminDAO.getExpiredRequestsCount(startDate, endDate);
        int aboutToExpire = adminDAO.getAboutToExpireRequestsCount(startDate, endDate);

        double approvalRate = total > 0 ? (approved * 100.0 / total) : 0.0;
        double averageResolutionDays = adminDAO.getAverageResolutionDays(startDate, endDate);

        List<Solicitud> recent = adminDAO.getAllRequestsPaged("", 1, 8);
        List<Solicitud> closedRecent = adminDAO.getAllRequestsPaged("Cerrada", 1, 8);
        List<Solicitud> urgent = adminDAO.getAllRequestsPaged("Vencidas", 1, 6);
        List<Object[]> topTypes = adminDAO.getTopRequestTypes(7, startDate, endDate);
        List<Object[]> topPrograms = adminDAO.getTopPrograms(7, startDate, endDate);

        request.setAttribute("startDate", startDate);
        request.setAttribute("endDate", endDate);
        request.setAttribute("counts", counts);
        request.setAttribute("monthlyCreated", monthlyCreated);
        request.setAttribute("monthly", monthly);
        request.setAttribute("recent", recent);
        request.setAttribute("closedRecent", closedRecent);
        request.setAttribute("urgent", urgent);
        request.setAttribute("total", total);
        request.setAttribute("open", open);
        request.setAttribute("closed", closed);
        request.setAttribute("createdThisMonth", createdThisMonth);
        request.setAttribute("sent", sent);
        request.setAttribute("pending", pending);
        request.setAttribute("approved", approved);
        request.setAttribute("rejected", rejected);
        request.setAttribute("expired", expired);
        request.setAttribute("aboutToExpire", aboutToExpire);
        request.setAttribute("approvalRate", approvalRate);
        request.setAttribute("averageResolutionDays", averageResolutionDays);
        request.setAttribute("topTypes", topTypes);
        request.setAttribute("topPrograms", topPrograms);

        request.getRequestDispatcher("/admin/reports.jsp").forward(request, response);
    }

    /**
     * Calculates the total number of requests using status counters.
     */
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