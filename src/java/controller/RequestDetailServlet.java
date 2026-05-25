package controller;

import dao.SolicitudMensajeDAO;
import dao.StudentDAO;
import model.Solicitud;
import model.Student;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;

/**
 * Shows detailed information about a specific request for a student.
 * Allows the student to send text messages and optional attached files.
 */
@WebServlet(name = "RequestDetailServlet", urlPatterns = {"/student/request-detail"})
@MultipartConfig(
        maxFileSize = 1024 * 1024 * 5,
        maxRequestSize = 1024 * 1024 * 10
)
public class RequestDetailServlet extends HttpServlet {

    private final StudentDAO studentDAO = new StudentDAO();
    private final SolicitudMensajeDAO mensajeDAO = new SolicitudMensajeDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (!isStudentSession(session)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Student student = (Student) session.getAttribute("user");
        Integer id = parseInteger(request.getParameter("id"));

        if (student == null || id == null) {
            response.sendRedirect(request.getContextPath() + "/student/requests");
            return;
        }

        Solicitud solicitud = studentDAO.getById(student.getId(), id);

        if (solicitud == null) {
            response.sendRedirect(request.getContextPath() + "/student/requests");
            return;
        }

        request.setAttribute("solicitud", solicitud);
        request.setAttribute("mensajes", mensajeDAO.getBySolicitudId(solicitud.getId()));
        request.getRequestDispatcher("/student/request_detail.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (!isStudentSession(session)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Student student = (Student) session.getAttribute("user");
        Integer id = parseInteger(request.getParameter("id"));
        String mensaje = clean(request.getParameter("mensaje"));

        if (student == null || id == null) {
            response.sendRedirect(request.getContextPath() + "/student/requests");
            return;
        }

        Solicitud solicitud = studentDAO.getById(student.getId(), id);

        if (solicitud == null) {
            response.sendRedirect(request.getContextPath() + "/student/requests");
            return;
        }

        String archivoPath = saveUploadedFile(request);

        if (mensaje.isEmpty() && archivoPath == null) {
            response.sendRedirect(request.getContextPath() + "/student/request-detail?id=" + id);
            return;
        }

        mensajeDAO.addMessage(id, "student", student.getNombreCompleto(), mensaje, archivoPath);

        response.sendRedirect(request.getContextPath() + "/student/request-detail?id=" + id);
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

    private boolean isStudentSession(HttpSession session) {
        return session != null && "student".equals(session.getAttribute("role"));
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