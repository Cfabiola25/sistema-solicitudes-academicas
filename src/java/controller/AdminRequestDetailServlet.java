package controller;

import dao.AdminDAO;
import dao.SolicitudMensajeDAO;
import model.Admin;
import model.Solicitud;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;

/**
 * Allows an administrator to view and respond to a specific request.
 * The admin can update status, assign responsible admins, and send messages with optional files.
 */
@WebServlet(name = "AdminRequestDetailServlet", urlPatterns = {"/admin/request-detail"})
@MultipartConfig(
        maxFileSize = 1024 * 1024 * 5,
        maxRequestSize = 1024 * 1024 * 10
)
public class AdminRequestDetailServlet extends HttpServlet {

    private final AdminDAO adminDAO = new AdminDAO();
    private final SolicitudMensajeDAO mensajeDAO = new SolicitudMensajeDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (!isAdminSession(session)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Integer id = parseInteger(request.getParameter("id"));

        if (id == null) {
            response.sendRedirect(request.getContextPath() + "/admin/requests");
            return;
        }

        Solicitud solicitud = adminDAO.getRequestById(id);

        if (solicitud == null) {
            response.sendRedirect(request.getContextPath() + "/admin/requests");
            return;
        }

        request.setAttribute("solicitud", solicitud);
        request.setAttribute("mensajes", mensajeDAO.getBySolicitudId(solicitud.getId()));
        request.setAttribute("admins", adminDAO.getAllAdmins());

        request.getRequestDispatcher("/admin/request_detail.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);

        if (!isAdminSession(session)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Integer id = parseInteger(request.getParameter("id"));

        if (id == null) {
            response.sendRedirect(request.getContextPath() + "/admin/requests");
            return;
        }

        Admin admin = (Admin) session.getAttribute("user");

        if (admin == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = clean(request.getParameter("action"));
        String comentario = clean(request.getParameter("comentario"));

        if ("message".equals(action)) {
            addMessage(request, id, admin, comentario);
        } else if ("assign".equals(action)) {
            assignResponsible(request, id);
        } else {
            updateRequestStatus(request, id, admin.getId(), comentario);
        }

        response.sendRedirect(request.getContextPath() + "/admin/request-detail?id=" + id);
    }

    private void addMessage(HttpServletRequest request, int requestId, Admin admin, String comentario)
            throws IOException, ServletException {

        String archivoPath = saveUploadedFile(request);

        if (!comentario.isEmpty() || archivoPath != null) {
            Solicitud solicitud = adminDAO.getRequestById(requestId);

            if (solicitud != null && solicitud.getResponsable() == null) {
                adminDAO.assignRequest(requestId, admin.getId());
            }

            mensajeDAO.addMessage(requestId, "admin", admin.getNombre(), comentario, archivoPath);
        }
    }

    private String saveUploadedFile(HttpServletRequest request)
            throws IOException, ServletException {

        Part filePart = request.getPart("archivo");

        if (filePart == null || filePart.getSize() <= 0) {
            return null;
        }

        String submittedName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();

        if (submittedName == null || submittedName.trim().isEmpty()) {
            return null;
        }

        String safeFileName = System.currentTimeMillis() + "_" +
                submittedName.replaceAll("[^a-zA-Z0-9._-]", "_");

        String uploadsDir = getServletContext().getRealPath("") + File.separator + "uploads" + File.separator + "messages";
        File uploads = new File(uploadsDir);

        if (!uploads.exists()) {
            uploads.mkdirs();
        }

        File file = new File(uploads, safeFileName);
        filePart.write(file.getAbsolutePath());

        return "uploads/messages/" + safeFileName;
    }

    private void assignResponsible(HttpServletRequest request, int requestId) {
        Integer responsableId = parseInteger(request.getParameter("responsableId"));

        if (responsableId != null && responsableId > 0) {
            adminDAO.assignRequest(requestId, responsableId);
        }
    }

    private void updateRequestStatus(HttpServletRequest request, int requestId, int adminId, String comentario) {
        String newState = clean(request.getParameter("newState"));

        if ("Aprobada".equals(newState) || "Rechazada".equals(newState) || "Anulada".equals(newState)) {
            adminDAO.updateStatus(requestId, newState, comentario, adminId);
        }
    }

    private boolean isAdminSession(HttpSession session) {
        return session != null && "admin".equals(session.getAttribute("role"));
    }

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

    private String clean(String value) {
        return value == null ? "" : value.trim();
    }
}