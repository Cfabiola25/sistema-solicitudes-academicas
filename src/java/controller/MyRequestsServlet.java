package controller;

import dao.StudentDAO;
import dao.TipoSolicitudDAO;
import model.Solicitud;
import model.Student;
import model.TipoSolicitud;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

/**
 * Displays the list of requests submitted by the current student.
 * Supports optional filtering by status using the 'state'
 * request parameter and includes pagination.
 */
@WebServlet(name = "MyRequestsServlet", urlPatterns = {"/student/requests"})
public class MyRequestsServlet extends HttpServlet {

    private final StudentDAO studentDAO = new StudentDAO();
    private final TipoSolicitudDAO tipoDAO = new TipoSolicitudDAO();

    private static final int PAGE_SIZE = 10;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (!isStudentSession(session)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Student student = (Student) session.getAttribute("user");

        if (student == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String state = clean(request.getParameter("state"));
        int page = getPage(request);

        int totalRecords = studentDAO.getRequestsCount(student.getId(), state);
        int totalPages = calculateTotalPages(totalRecords);

        if (page > totalPages && totalPages > 0) {
            page = totalPages;
        }

        List<Solicitud> list = studentDAO.getAllRequestsPaged(student.getId(), state, page, PAGE_SIZE);
        List<TipoSolicitud> tipos = tipoDAO.getAll();

        request.setAttribute("list", list);
        request.setAttribute("selectedState", state);
        request.setAttribute("tipos", tipos);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalRecords", totalRecords);
        request.setAttribute("pageSize", PAGE_SIZE);

        request.getRequestDispatcher("/student/my_requests.jsp").forward(request, response);
    }

    /**
     * Validates that the current session belongs to a student.
     */
    private boolean isStudentSession(HttpSession session) {
        return session != null && "student".equals(session.getAttribute("role"));
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