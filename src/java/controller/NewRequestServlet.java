package controller;

import dao.StudentDAO;
import dao.TipoSolicitudDAO;
import model.Solicitud;
import model.Student;
import model.TipoSolicitud;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.List;

/**
 * Allows a student to create a new academic request.
 * The GET method loads the request types and the POST method
 * saves the request, including an optional attached PDF document.
 */
@WebServlet(name = "NewRequestServlet", urlPatterns = {"/student/new-request"})
@MultipartConfig(
        maxFileSize = 1024 * 1024 * 20,
        maxRequestSize = 1024 * 1024 * 25
)
public class NewRequestServlet extends HttpServlet {

    private final TipoSolicitudDAO tipoDAO = new TipoSolicitudDAO();
    private final StudentDAO studentDAO = new StudentDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (!isStudentSession(session)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        loadRequestTypes(request);
        request.getRequestDispatcher("/student/new_request.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (!isStudentSession(session)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        Student student = (Student) session.getAttribute("user");

        if (student == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        Integer tipoId = parseInteger(request.getParameter("tipo"));
        String descripcion = clean(request.getParameter("descripcion"));

        if (tipoId == null || tipoId <= 0 || descripcion.isEmpty()) {
            forwardWithError(request, response, "Debe seleccionar un tipo de solicitud y escribir una descripción.");
            return;
        }

        String documentoPath;

        try {
            documentoPath = saveUploadedFile(request);
        } catch (ServletException e) {
            forwardWithError(request, response, e.getMessage());
            return;
        }

        TipoSolicitud tipo = new TipoSolicitud();
        tipo.setId(tipoId);

        Solicitud solicitud = new Solicitud();
        solicitud.setEstudiante(student);
        solicitud.setTipo(tipo);
        solicitud.setDescripcion(descripcion);
        solicitud.setDocumento(documentoPath);

        boolean created = studentDAO.createRequest(solicitud);

        if (!created) {
            forwardWithError(request, response, "No fue posible registrar la solicitud. Intente nuevamente.");
            return;
        }

        response.sendRedirect(request.getContextPath() + "/student/requests");
    }

    /**
     * Loads all available request types for the form selector.
     */
    private void loadRequestTypes(HttpServletRequest request) {
        List<TipoSolicitud> tipos = tipoDAO.getAll();
        request.setAttribute("tipos", tipos);
    }

    /**
     * Sends the user back to the form with an error message.
     */
    private void forwardWithError(HttpServletRequest request, HttpServletResponse response, String error)
            throws ServletException, IOException {

        request.setAttribute("error", error);
        loadRequestTypes(request);
        request.getRequestDispatcher("/student/new_request.jsp").forward(request, response);
    }

    /**
     * Saves the uploaded PDF document and returns its relative path.
     * If no document is uploaded, returns null.
     */
    private String saveUploadedFile(HttpServletRequest request)
            throws IOException, ServletException {

        Part filePart = request.getPart("documento");

        if (filePart == null || filePart.getSize() <= 0) {
            return null;
        }

        String contentType = filePart.getContentType();

        if (!"application/pdf".equalsIgnoreCase(contentType)) {
            throw new ServletException("Solo se permiten archivos PDF.");
        }

        String submittedName = Paths.get(filePart.getSubmittedFileName())
                .getFileName()
                .toString();

        if (submittedName == null || submittedName.trim().isEmpty()) {
            return null;
        }

        if (!submittedName.toLowerCase().endsWith(".pdf")) {
            throw new ServletException("El archivo debe tener extensión .pdf.");
        }

        String safeFileName = buildSafeFileName(submittedName);

        String uploadsDir = getServletContext().getRealPath("") + File.separator + "uploads";
        File uploads = new File(uploadsDir);

        if (!uploads.exists()) {
            uploads.mkdirs();
        }

        File file = new File(uploads, safeFileName);
        filePart.write(file.getAbsolutePath());

        return "uploads/" + safeFileName;
    }

    /**
     * Builds a safe unique filename to avoid overwriting uploaded files.
     */
    private String buildSafeFileName(String originalName) {
        String cleanName = originalName.replaceAll("[^a-zA-Z0-9._-]", "_");
        return System.currentTimeMillis() + "_" + cleanName;
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