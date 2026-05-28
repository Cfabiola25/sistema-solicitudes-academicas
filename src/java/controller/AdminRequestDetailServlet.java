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
import java.util.Locale;

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

    private static final long MAX_FILE_SIZE_BYTES = 1024L * 1024L * 5L;
    private static final String[] ALLOWED_EXTENSIONS = {"pdf", "docx", "jpg", "jpeg", "png", "webp"};
    private static final String[] ALLOWED_CONTENT_TYPES = {
            "application/pdf",
            "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
            "image/jpeg",
            "image/png",
            "image/webp"
    };

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

        Solicitud solicitud = getAuthorizedRequest(session, id);

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

        Solicitud solicitud = getAuthorizedRequest(session, id);

        if (solicitud == null) {
            response.sendRedirect(request.getContextPath() + "/admin/requests");
            return;
        }

        String action = clean(request.getParameter("action"));
        String comentario = clean(request.getParameter("comentario"));

        if ("message".equals(action)) {
            addMessage(request, solicitud, admin, comentario);
        } else if ("assign".equals(action)) {
            if (!processAssignAction(request, response, solicitud, admin)) {
                return;
            }
        } else {
            updateRequestStatus(request, solicitud, admin, comentario);
        }

        response.sendRedirect(request.getContextPath() + "/admin/request-detail?id=" + id);
    }

    private void addMessage(HttpServletRequest request, Solicitud solicitud, Admin admin, String comentario)
            throws IOException, ServletException {

        String archivoPath = saveUploadedFile(request);

        if (!comentario.isEmpty() || archivoPath != null) {
            boolean added = mensajeDAO.addMessage(solicitud.getId(), "admin", admin.getNombre(), comentario, archivoPath);

            if (added && "Enviada".equals(solicitud.getEstado())) {
                adminDAO.updateStatus(solicitud.getId(), "Pendiente", comentario, admin.getId());
            }
        }
    }

    private void assignResponsible(HttpServletRequest request, Solicitud solicitud, Admin admin) {
        if (!isSuperAdmin(admin)) {
            return;
        }

        Integer responsableId = parseInteger(request.getParameter("responsableId"));

        if (responsableId != null && responsableId > 0) {
            adminDAO.assignRequest(solicitud.getId(), responsableId);
        }
    }

    private void updateRequestStatus(HttpServletRequest request, Solicitud solicitud, Admin admin, String comentario) {
        if (!canManageRequest(admin, solicitud)) {
            return;
        }

        String newState = clean(request.getParameter("newState"));

        if ("Aprobada".equals(newState) || "Rechazada".equals(newState) || "Anulada".equals(newState)) {
            adminDAO.updateStatus(solicitud.getId(), newState, comentario, admin.getId());
        }
    }

    private Solicitud getAuthorizedRequest(HttpSession session, int requestId) {
        Admin admin = getSessionAdmin(session);

        if (admin == null) {
            return null;
        }

        boolean isSuper = "SuperAdmin".equals(admin.getRol());
        return adminDAO.getRequestByIdForAdmin(requestId, admin.getId(), isSuper);
    }

    private Admin getSessionAdmin(HttpSession session) {
        if (session == null) {
            return null;
        }

        Object user = session.getAttribute("user");
        return user instanceof Admin ? (Admin) user : null;
    }

    private boolean canManageRequest(Admin admin, Solicitud solicitud) {
        if (admin == null || solicitud == null) {
            return false;
        }

        if ("SuperAdmin".equals(admin.getRol())) {
            return true;
        }

        if (solicitud.getTipo() == null) {
            return false;
        }

        return adminDAO.isAdminAssignedToTipo(admin.getId(), solicitud.getTipo().getId());
    }

    private boolean isSuperAdmin(Admin admin) {
        return admin != null && "SuperAdmin".equals(admin.getRol());
    }

    private String saveUploadedFile(HttpServletRequest request)
            throws IOException, ServletException {

        Part filePart = request.getPart("archivo");

        if (filePart == null || filePart.getSize() <= 0) {
            return null;
        }

        if (filePart.getSize() > MAX_FILE_SIZE_BYTES) {
            throw new ServletException("El archivo supera el tamaño máximo permitido de 5 MB.");
        }

        String submittedName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();

        if (submittedName == null || submittedName.trim().isEmpty()) {
            return null;
        }

        String extension = getFileExtension(submittedName);

        if (extension == null || !isAllowedExtension(extension)) {
            throw new ServletException("Formato no permitido. Usa PDF, DOCX, JPG, JPEG, PNG o WEBP.");
        }

        String contentType = filePart.getContentType();

        if (contentType == null || !isAllowedContentType(contentType)) {
            throw new ServletException("Formato no permitido. Usa PDF, DOCX, JPG, JPEG, PNG o WEBP.");
        }

        String safeFileName = System.currentTimeMillis() + "_" +
                submittedName.replaceAll("[^a-zA-Z0-9._-]", "_");

        String uploadsDir = getServletContext().getRealPath("/uploads/messages");

        if (uploadsDir == null) {
            throw new ServletException("No se pudo resolver la carpeta de archivos adjuntos.");
        }

        File uploads = new File(uploadsDir);

        if (!uploads.exists()) {
            uploads.mkdirs();
        }

        File file = new File(uploads, safeFileName);
        filePart.write(file.getAbsolutePath());

        return "uploads/messages/" + safeFileName;
    }

    private boolean isAllowedExtension(String extension) {
        String normalized = extension.toLowerCase(Locale.ROOT);

        for (String allowed : ALLOWED_EXTENSIONS) {
            if (allowed.equals(normalized)) {
                return true;
            }
        }

        return false;
    }

    private boolean isAllowedContentType(String contentType) {
        String normalized = contentType.toLowerCase(Locale.ROOT);

        for (String allowed : ALLOWED_CONTENT_TYPES) {
            if (allowed.equals(normalized)) {
                return true;
            }
        }

        return false;
    }

    private String getFileExtension(String fileName) {
        int dotIndex = fileName.lastIndexOf('.');

        if (dotIndex < 0 || dotIndex == fileName.length() - 1) {
            return null;
        }

        return fileName.substring(dotIndex + 1);
    }

    private boolean processAssignAction(HttpServletRequest request, HttpServletResponse response,
                                         Solicitud solicitud, Admin admin)
            throws ServletException, IOException {
        if (!isSuperAdmin(admin)) {
            request.setAttribute("error", "No autorizado: sólo SuperAdmin puede reasignar solicitudes.");
            request.setAttribute("solicitud", solicitud);
            request.setAttribute("mensajes", mensajeDAO.getBySolicitudId(solicitud.getId()));
            request.setAttribute("admins", adminDAO.getAllAdmins());
            request.getRequestDispatcher("/admin/request_detail.jsp").forward(request, response);
            return false;
        }

        assignResponsible(request, solicitud, admin);
        return true;
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