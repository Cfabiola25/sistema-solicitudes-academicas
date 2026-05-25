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

        Map<String, Integer> counts = adminDAO.getCountsByStatus();
        Map<Integer, Integer> monthly = adminDAO.getMonthlyApprovedCounts();

        int total = calculateTotal(counts);
        int sent = counts.getOrDefault("Enviada", 0);
        int pending = counts.getOrDefault("Pendiente", 0);
        int approved = counts.getOrDefault("Aprobada", 0);
        int rejected = counts.getOrDefault("Rechazada", 0);

        double approvalRate = total > 0 ? (approved * 100.0 / total) : 0.0;

        List<Solicitud> recent = adminDAO.getAllRequestsPaged("", 1, 8);

        request.setAttribute("counts", counts);
        request.setAttribute("monthly", monthly);
        request.setAttribute("recent", recent);
        request.setAttribute("total", total);
        request.setAttribute("sent", sent);
        request.setAttribute("pending", pending);
        request.setAttribute("approved", approved);
        request.setAttribute("rejected", rejected);
        request.setAttribute("approvalRate", approvalRate);

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