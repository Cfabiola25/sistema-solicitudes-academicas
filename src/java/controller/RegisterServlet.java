package controller;

import dao.LookupDAO;
import dao.StudentDAO;
import model.Student;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

/**
 * Servlet handling self-registration for students.
 * Only institutional emails ending in @fesc.edu.co are allowed.
 */
@WebServlet(name = "RegisterServlet", urlPatterns = {"/register"})
public class RegisterServlet extends HttpServlet {

    private static final String INSTITUTIONAL_DOMAIN = "@fesc.edu.co";

    private final StudentDAO studentDAO = new StudentDAO();
    private final LookupDAO lookupDAO = new LookupDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        loadLookups(request);
        request.getRequestDispatcher("/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String nombre = clean(request.getParameter("nombre"));
        String apellido = clean(request.getParameter("apellido"));
        String email = clean(request.getParameter("email")).toLowerCase();
        String password = clean(request.getParameter("password"));

        Integer programaId = parseInteger(request.getParameter("programaId"));
        Integer sedeId = parseInteger(request.getParameter("sedeId"));
        Integer jornadaId = parseInteger(request.getParameter("jornadaId"));

        boolean terminosAceptados = request.getParameter("terminosAceptados") != null;

        if (nombre.isEmpty() || apellido.isEmpty() || email.isEmpty() || password.isEmpty()) {
            forwardWithError(request, response, "Todos los campos obligatorios deben ser completados.");
            return;
        }

        if (!isInstitutionalEmail(email)) {
            forwardWithError(request, response, "Solo se permite el registro con correo institucional terminado en " + INSTITUTIONAL_DOMAIN + ".");
            return;
        }

        if (programaId == null || sedeId == null || jornadaId == null) {
            forwardWithError(request, response, "Debes seleccionar programa académico, sede y jornada.");
            return;
        }

        if (!terminosAceptados) {
            forwardWithError(request, response, "Debes aceptar los términos legales y la política de privacidad.");
            return;
        }

        if (studentDAO.emailExists(email)) {
            forwardWithError(request, response, "El correo ingresado ya se encuentra registrado.");
            return;
        }

        Student student = new Student();
        student.setNombre(nombre);
        student.setApellido(apellido);
        student.setEmail(email);
        student.setPassword(util.PasswordHasher.secureHash(password));
        student.setProgramaId(programaId);
        student.setSedeId(sedeId);
        student.setJornadaId(jornadaId);
        student.setTerminosAceptados(true);

        boolean success = studentDAO.createStudent(student);

        if (success) {
            request.setAttribute("success", "Estudiante registrado exitosamente. Ya puedes iniciar sesión.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        forwardWithError(request, response, "Ocurrió un error al registrar la cuenta. Inténtalo de nuevo.");
    }

    /**
     * Loads base lists required by the registration form.
     */
    private void loadLookups(HttpServletRequest request) {
        request.setAttribute("programas", lookupDAO.getAllProgramas());
        request.setAttribute("sedes", lookupDAO.getAllSedes());
        request.setAttribute("jornadas", lookupDAO.getAllJornadas());
    }

    /**
     * Validates that the email belongs to the institutional domain.
     */
    private boolean isInstitutionalEmail(String email) {
        return email != null && email.toLowerCase().endsWith(INSTITUTIONAL_DOMAIN);
    }

    /**
     * Sends the user back to the registration form with an error message.
     */
    private void forwardWithError(HttpServletRequest request, HttpServletResponse response, String error)
            throws ServletException, IOException {

        request.setAttribute("error", error);
        loadLookups(request);
        request.getRequestDispatcher("/register.jsp").forward(request, response);
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