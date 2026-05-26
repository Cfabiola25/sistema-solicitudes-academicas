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
 * Includes pagination and keeps the structure open for future filters.
 */
@WebServlet(name = "AdminRequestsServlet", urlPatterns = {"/admin/requests"})
public class AdminRequestsServlet extends HttpServlet {

    private final AdminDAO adminDAO = new AdminDAO();
    private static final int PAGE_SIZE = 10;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (!isAdminSession(session)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String state = clean(request.getParameter("state"));
        int page = getPage(request);
        String sort = clean(request.getParameter("sort"));
        String dir = clean(request.getParameter("dir"));

        if (sort.isEmpty()) {
            sort = "id";
        }

        if (!"asc".equalsIgnoreCase(dir) && !"desc".equalsIgnoreCase(dir)) {
            dir = "desc";
        }

        int totalRecords;

        boolean isSuper = false;
        int adminId = 0;
        if (session != null) {
            Object user = session.getAttribute("user");
            if (user instanceof model.Admin) {
                model.Admin adm = (model.Admin) user;
                isSuper = "SuperAdmin".equals(adm.getRol());
                adminId = adm.getId();
            }
        }

        if (isSuper) {
            totalRecords = adminDAO.getRequestsCount(state);
        } else {
            totalRecords = adminDAO.getRequestsCountForAdmin(state, adminId);
        }

        int totalPages = calculateTotalPages(totalRecords);

        if (page > totalPages && totalPages > 0) {
            page = totalPages;
        }

        List<Solicitud> list;

        if (isSuper) {
            list = adminDAO.getAllRequestsPaged(state, page, PAGE_SIZE, sort, dir);
        } else {
            list = adminDAO.getRequestsForAdminPaged(state, adminId, page, PAGE_SIZE, sort, dir);
        }

        request.setAttribute("list", list);
        request.setAttribute("selectedState", state);
        request.setAttribute("sort", sort);
        request.setAttribute("dir", dir.toLowerCase());
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalRecords", totalRecords);
        request.setAttribute("pageSize", PAGE_SIZE);

        request.getRequestDispatcher("/admin/requests.jsp").forward(request, response);
    }

    /**
     * Validates that the current session belongs to an administrator.
     */
    private boolean isAdminSession(HttpSession session) {
        return session != null && "admin".equals(session.getAttribute("role"));
    }

    /**
     * Gets the current page from the request.
     */
    private int getPage(HttpServletRequest request) {
        Integer page = parseInteger(request.getParameter("page"));
        return page == null || page < 1 ? 1 : page;
    }

    /**
     * Calculates the total number of pages.
     */
    private int calculateTotalPages(int totalRecords) {
        return (int) Math.ceil((double) totalRecords / PAGE_SIZE);
    }

    /**
     * Safely converts a string parameter to Integer.
     */
    private Integer parseInteger(String value) {
        if (value == null || value.trim().isEmpty()) {
            return null;
        }

        try {
            return Integer.parseInt(value.trim());
        } catch (NumberFormatException e) {
            return null;
        }
    }

    /**
     * Cleans request parameters to avoid null values and unnecessary spaces.
     */
    private String clean(String value) {
        return value == null ? "" : value.trim();
    }
}