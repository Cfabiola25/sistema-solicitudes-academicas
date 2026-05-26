package controller;

import dao.StudentDAO;
import model.Solicitud;
import model.Student;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;

/**
 * Servlet allowing students to modify their pending requests.
 * Only requests in Enviada or Pendiente status can be edited.
 */
@WebServlet(name = "EditRequestServlet", urlPatterns = {"/student/edit-request"})
@MultipartConfig(
        maxFileSize = 1024 * 1024 * 5,
        maxRequestSize = 1024 * 1024 * 10
)
public class EditRequestServlet extends HttpServlet {

    private final StudentDAO studentDAO = new StudentDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (!isStudentSession(session)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Student student = (Student) session.getAttribute("user");
        Integer requestId = parseInteger(request.getParameter("id"));

        if (student == null || requestId == null) {
            response.sendRedirect(request.getContextPath() + "/student/requests");
            return;
        }

        Solicitud solicitud = studentDAO.getById(student.getId(), requestId);

        if (solicitud == null || !isEditable(solicitud.getEstado())) {
            response.sendRedirect(request.getContextPath() + "/student/requests");
            return;
        }

        request.setAttribute("solicitud", solicitud);
        request.getRequestDispatcher("/student/edit_request.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);

        if (!isStudentSession(session)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Student student = (Student) session.getAttribute("user");
        Integer requestId = parseInteger(request.getParameter("id"));
        String descripcion = clean(request.getParameter("descripcion"));

        if (student == null || requestId == null || descripcion.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/student/requests");
            return;
        }

        Solicitud solicitud = studentDAO.getById(student.getId(), requestId);

        if (solicitud == null || !isEditable(solicitud.getEstado())) {
            response.sendRedirect(request.getContextPath() + "/student/requests");
            return;
        }

        String documentoPath = saveUploadedFile(request);

        if (documentoPath != null) {
            solicitud.setDocumento(documentoPath);
        }

        solicitud.setDescripcion(descripcion);

        boolean updated = studentDAO.updateRequest(solicitud);

        if (updated) {
            response.sendRedirect(request.getContextPath() + "/student/request-detail?id=" + requestId);
            return;
        }

        request.setAttribute("error", "Error al guardar los cambios en la solicitud.");
        request.setAttribute("solicitud", solicitud);
        request.getRequestDispatcher("/student/edit_request.jsp").forward(request, response);
    }

    /**
     * Saves the uploaded document and returns its relative path.
     * If no document is uploaded, returns null.
     */
    private String saveUploadedFile(HttpServletRequest request)
            throws IOException, ServletException {

        Part filePart = request.getPart("documento");

        if (filePart == null || filePart.getSize() <= 0) {
            return null;
        }

        String submittedName = Paths.get(filePart.getSubmittedFileName())
                .getFileName()
                .toString();

        if (submittedName == null || submittedName.trim().isEmpty()) {
            return null;
        }

        String safeFileName = buildSafeFileName(submittedName);

        String uploadsDir = getServletContext().getRealPath("/uploads");

        if (uploadsDir == null) {
            throw new ServletException("No se pudo resolver la carpeta de archivos adjuntos.");
        }

        File uploads = new File(uploadsDir);

        if (!uploads.exists()) {
            uploads.mkdirs();
        }

        File file = new File(uploads, safeFileName);
        filePart.write(file.getAbsolutePath());

        return "uploads/" + safeFileName;
    }

    /**
     * Builds a safe and unique filename to avoid overwriting uploaded files.
     */
    private String buildSafeFileName(String originalName) {
        String cleanName = originalName.replaceAll("[^a-zA-Z0-9._-]", "_");
        return System.currentTimeMillis() + "_" + cleanName;
    }

    /**
     * Allows editing only for open requests.
     */
    private boolean isEditable(String estado) {
        return "Enviada".equals(estado) || "Pendiente".equals(estado);
    }

    /**
     * Validates that the current session belongs to a student.
     */
    private boolean isStudentSession(HttpSession session) {
        return session != null && "student".equals(session.getAttribute("role"));
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