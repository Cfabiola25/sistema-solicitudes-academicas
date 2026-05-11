package controller;

import dao.StudentDAO;
import dao.TipoSolicitudDAO;
import model.Solicitud;
import model.Student;
import model.TipoSolicitud;

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
import java.util.List;

@WebServlet(name = "NewRequestServlet", urlPatterns = {"/student/new-request"})
@MultipartConfig
public class NewRequestServlet extends HttpServlet {

    private final TipoSolicitudDAO tipoDAO = new TipoSolicitudDAO();
    private final StudentDAO studentDAO = new StudentDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || !"student".equals(session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        List<TipoSolicitud> tipos = tipoDAO.getAll();
        request.setAttribute("tipos", tipos);
        request.getRequestDispatcher("/student/new_request.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || !"student".equals(session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        Student student = (Student) session.getAttribute("user");

        int tipoId = Integer.parseInt(request.getParameter("tipo"));
        String descripcion = request.getParameter("descripcion");

        String documentoPath = null;

        Part filePart = request.getPart("documento");

        if (filePart != null && filePart.getSize() > 0) {

            String fileName = Paths.get(filePart.getSubmittedFileName())
                    .getFileName()
                    .toString();

            String uploadsDir = getServletContext().getRealPath("") + File.separator + "uploads";

            File uploads = new File(uploadsDir);

            if (!uploads.exists()) {
                uploads.mkdirs();
            }

            File file = new File(uploads, fileName);

            filePart.write(file.getAbsolutePath());

            documentoPath = "uploads/" + fileName;
        }

        TipoSolicitud tipo = new TipoSolicitud();
        tipo.setId(tipoId);

        Solicitud solicitud = new Solicitud();
        solicitud.setEstudiante(student);
        solicitud.setTipo(tipo);
        solicitud.setDescripcion(descripcion);
        solicitud.setDocumento(documentoPath);

        studentDAO.createRequest(solicitud);

        response.sendRedirect(request.getContextPath() + "/student/requests");
    }
}