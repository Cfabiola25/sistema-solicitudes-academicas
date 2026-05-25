package controller;

import dao.ProgramaAcademicoDAO;
import model.ProgramaAcademico;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

/**
 * Allows administrators to create, update and delete academic programs.
 */
@WebServlet(name = "AdminProgramsServlet", urlPatterns = {"/admin/programs"})
public class AdminProgramsServlet extends HttpServlet {

    private final ProgramaAcademicoDAO programaDAO = new ProgramaAcademicoDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (!isAdminSession(session)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        loadPrograms(request);
        request.getRequestDispatcher("/admin/programs.jsp").forward(request, response);
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

        if ("create".equals(action)) {
            createProgram(request, response);
            return;
        }

        if ("update".equals(action)) {
            updateProgram(request, response);
            return;
        }

        if ("delete".equals(action)) {
            deleteProgram(request, response);
            return;
        }

        response.sendRedirect(request.getContextPath() + "/admin/programs");
    }

    private void createProgram(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String codigo = clean(request.getParameter("codigo"));
        String nombre = clean(request.getParameter("nombre"));

        if (codigo.isEmpty() || nombre.isEmpty()) {
            forwardWithError(request, response, "Código y nombre son obligatorios.");
            return;
        }

        if (programaDAO.codeExists(codigo)) {
            forwardWithError(request, response, "Ya existe un programa con ese código.");
            return;
        }

        if (programaDAO.nameExists(nombre)) {
            forwardWithError(request, response, "Ya existe un programa con ese nombre.");
            return;
        }

        ProgramaAcademico programa = new ProgramaAcademico();
        programa.setCodigo(codigo);
        programa.setNombre(nombre);

        if (!programaDAO.create(programa)) {
            forwardWithError(request, response, "No fue posible crear el programa académico.");
            return;
        }

        response.sendRedirect(request.getContextPath() + "/admin/programs");
    }

    private void updateProgram(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Integer id = parseInteger(request.getParameter("id"));
        String codigo = clean(request.getParameter("codigo"));
        String nombre = clean(request.getParameter("nombre"));

        if (id == null || id <= 0 || codigo.isEmpty() || nombre.isEmpty()) {
            forwardWithError(request, response, "Datos inválidos para actualizar el programa.");
            return;
        }

        ProgramaAcademico programa = new ProgramaAcademico();
        programa.setId(id);
        programa.setCodigo(codigo);
        programa.setNombre(nombre);

        if (!programaDAO.update(programa)) {
            forwardWithError(request, response, "No fue posible actualizar el programa académico.");
            return;
        }

        response.sendRedirect(request.getContextPath() + "/admin/programs");
    }

    private void deleteProgram(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        Integer id = parseInteger(request.getParameter("id"));

        if (id != null && id > 0) {
            programaDAO.delete(id);
        }

        response.sendRedirect(request.getContextPath() + "/admin/programs");
    }

    private void loadPrograms(HttpServletRequest request) {
        List<ProgramaAcademico> programas = programaDAO.getAll();
        request.setAttribute("programas", programas);
    }

    private void forwardWithError(HttpServletRequest request, HttpServletResponse response, String error)
            throws ServletException, IOException {

        request.setAttribute("error", error);
        loadPrograms(request);
        request.getRequestDispatcher("/admin/programs.jsp").forward(request, response);
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