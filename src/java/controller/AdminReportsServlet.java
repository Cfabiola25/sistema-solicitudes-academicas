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

@WebServlet(name = "AdminReportsServlet", urlPatterns = {"/admin/reports"})
public class AdminReportsServlet extends HttpServlet {
    private final AdminDAO adminDAO = new AdminDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Map<String, Integer> counts = adminDAO.getCountsByStatus();
        Map<Integer, Integer> monthly = adminDAO.getMonthlyApprovedCounts();
        List<Solicitud> allRequests = adminDAO.getAllRequests(null);
        int total = 0;
        for (Integer value : counts.values()) {
            total += value;
        }

        int approved = counts.getOrDefault("Aprobada", 0);
        int pending = counts.getOrDefault("Pendiente", 0);
        int rejected = counts.getOrDefault("Rechazada", 0);
        double approvalRate = total > 0 ? (approved * 100.0 / total) : 0.0;

        List<Solicitud> recent = allRequests.size() > 8 ? allRequests.subList(0, 8) : allRequests;

        request.setAttribute("counts", counts);
        request.setAttribute("monthly", monthly);
        request.setAttribute("recent", recent);
        request.setAttribute("total", total);
        request.setAttribute("approved", approved);
        request.setAttribute("pending", pending);
        request.setAttribute("rejected", rejected);
        request.setAttribute("approvalRate", approvalRate);
        request.getRequestDispatcher("/admin/reports.jsp").forward(request, response);
    }
}
