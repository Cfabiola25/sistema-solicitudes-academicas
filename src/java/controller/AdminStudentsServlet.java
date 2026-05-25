package controller;

import dao.AdminDAO;
import dao.StudentDAO;
import model.Student;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

/**
 * Controller that displays a list of all students enrolled in the system,
 * including details like academic program, shift, and campus.
 * It also allows administrators to reset student passwords without seeing the old one.
 */
@WebServlet(name = "AdminStudentsServlet", urlPatterns = {"/admin/students"})
public class AdminStudentsServlet extends HttpServlet {

    private final AdminDAO adminDAO = new AdminDAO();
    private final StudentDAO studentDAO = new StudentDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (!isAdminSession(session)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        loadStudents(request);
        request.getRequestDispatcher("/admin/students.jsp").forward(request, response);
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

        if ("resetPassword".equals(action)) {
            resetStudentPassword(request, response);
            return;
        }

        response.sendRedirect(request.getContextPath() + "/admin/students");
    }

    /**
     * Resets a student password using a new hashed password.
     */
    private void resetStudentPassword(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Integer studentId = parseInteger(request.getParameter("studentId"));
        String newPassword = clean(request.getParameter("newPassword"));

        if (studentId == null || studentId <= 0 || newPassword.isEmpty()) {
            forwardWithError(request, response, "Debes seleccionar un estudiante y escribir una nueva contraseña.");
            return;
        }

        if (newPassword.length() < 4) {
            forwardWithError(request, response, "La nueva contraseña debe tener al menos 4 caracteres.");
            return;
        }

        String hashedPassword = util.PasswordHasher.secureHash(newPassword);
        boolean updated = studentDAO.updatePasswordByAdmin(studentId, hashedPassword);

        if (!updated) {
            forwardWithError(request, response, "No fue posible restablecer la contraseña del estudiante.");
            return;
        }

        request.setAttribute("success", "Contraseña restablecida correctamente. La nueva contraseña quedó guardada de forma segura.");
        loadStudents(request);
        request.getRequestDispatcher("/admin/students.jsp").forward(request, response);
    }

    /**
     * Loads all students for the view.
     */
    private void loadStudents(HttpServletRequest request) {
        List<Student> students = adminDAO.getAllStudents();
        request.setAttribute("students", students);
    }

    /**
     * Sends the user back to students view with an error message.
     */
    private void forwardWithError(HttpServletRequest request, HttpServletResponse response, String error)
            throws ServletException, IOException {

        request.setAttribute("error", error);
        loadStudents(request);
        request.getRequestDispatcher("/admin/students.jsp").forward(request, response);
    }

    /**
     * Validates administrator session.
     */
    private boolean isAdminSession(HttpSession session) {
        return session != null && "admin".equals(session.getAttribute("role"));
    }

    /**
     * Safely converts a request parameter to Integer.
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
     * Cleans request parameters.
     */
    private String clean(String value) {
        return value == null ? "" : value.trim();
    }
}