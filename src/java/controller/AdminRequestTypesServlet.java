package controller;

import dao.TipoSolicitudDAO;
import model.TipoSolicitud;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

/**
 * Servlet for administrators to manage request types and response times (SLA).
 */
@WebServlet(name = "AdminRequestTypesServlet", urlPatterns = {"/admin/request-types"})
public class AdminRequestTypesServlet extends HttpServlet {

    private final TipoSolicitudDAO tipoDAO = new TipoSolicitudDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (!isAdminSession(session)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        loadRequestTypes(request);
        request.getRequestDispatcher("/admin/request_types.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (!isAdminSession(session)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = clean(request.getParameter("action"));
        boolean success = false;

        try {
            if ("create".equals(action)) {
                success = createRequestType(request);
            } else if ("update".equals(action)) {
                success = updateRequestType(request);
            } else if ("delete".equals(action)) {
                success = deleteRequestType(request);
            }
        } catch (Exception e) {
            request.setAttribute("error", "Error al procesar la operación: " + e.getMessage());
            loadRequestTypes(request);
            request.getRequestDispatcher("/admin/request_types.jsp").forward(request, response);
            return;
        }

        if (!success) {
            request.setAttribute("error", "No fue posible completar la operación. Verifique los datos ingresados.");
            loadRequestTypes(request);
            request.getRequestDispatcher("/admin/request_types.jsp").forward(request, response);
            return;
        }

        response.sendRedirect(request.getContextPath() + "/admin/request-types");
    }

    /**
     * Loads all request types to display them in the management view.
     */
    private void loadRequestTypes(HttpServletRequest request) {
        List<TipoSolicitud> list = tipoDAO.getAll();
        request.setAttribute("list", list);
    }

    /**
     * Creates a new request type with its SLA configuration.
     */
    private boolean createRequestType(HttpServletRequest request) {
        String nombre = clean(request.getParameter("nombre"));
        Integer tiempoRespuestaDias = parseInteger(request.getParameter("tiempoRespuestaDias"));
        String tipoTiempo = clean(request.getParameter("tipoTiempo"));

        if (!isValidRequestType(nombre, tiempoRespuestaDias, tipoTiempo)) {
            return false;
        }

        TipoSolicitud tipo = new TipoSolicitud();
        tipo.setNombre(nombre);
        tipo.setTiempoRespuestaDias(tiempoRespuestaDias);
        tipo.setTipoTiempo(tipoTiempo);

        return tipoDAO.create(tipo);
    }

    /**
     * Updates an existing request type and its SLA configuration.
     */
    private boolean updateRequestType(HttpServletRequest request) {
        Integer id = parseInteger(request.getParameter("id"));
        String nombre = clean(request.getParameter("nombre"));
        Integer tiempoRespuestaDias = parseInteger(request.getParameter("tiempoRespuestaDias"));
        String tipoTiempo = clean(request.getParameter("tipoTiempo"));

        if (id == null || id <= 0 || !isValidRequestType(nombre, tiempoRespuestaDias, tipoTiempo)) {
            return false;
        }

        TipoSolicitud tipo = new TipoSolicitud();
        tipo.setId(id);
        tipo.setNombre(nombre);
        tipo.setTiempoRespuestaDias(tiempoRespuestaDias);
        tipo.setTipoTiempo(tipoTiempo);

        return tipoDAO.update(tipo);
    }

    /**
     * Deletes a request type by ID.
     */
    private boolean deleteRequestType(HttpServletRequest request) {
        Integer id = parseInteger(request.getParameter("id"));

        if (id == null || id <= 0) {
            return false;
        }

        return tipoDAO.delete(id);
    }

    /**
     * Validates the data required for creating or updating request types.
     */
    private boolean isValidRequestType(String nombre, Integer tiempoRespuestaDias, String tipoTiempo) {
        return nombre != null
                && !nombre.isEmpty()
                && tiempoRespuestaDias != null
                && tiempoRespuestaDias > 0
                && ("habiles".equals(tipoTiempo) || "calendario".equals(tipoTiempo));
    }

    /**
     * Validates that the current session belongs to an administrator.
     */
    private boolean isAdminSession(HttpSession session) {
        return session != null && "admin".equals(session.getAttribute("role"));
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