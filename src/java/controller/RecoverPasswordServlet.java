package controller;

import dao.AdminDAO;
import dao.StudentDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

/**
 * Handles password recovery/reset using a validation token.
 */
@WebServlet(name = "RecoverPasswordServlet", urlPatterns = {"/recover-password"})
public class RecoverPasswordServlet extends HttpServlet {

    private final StudentDAO studentDAO = new StudentDAO();
    private final AdminDAO adminDAO = new AdminDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String token = clean(request.getParameter("token"));
        String role = clean(request.getParameter("role"));

        if (token.isEmpty() || !isValidRole(role) || !isValidToken(token, role)) {
            request.setAttribute("error", "El enlace de recuperación es inválido o ha expirado.");
            request.getRequestDispatcher("/forgot_password.jsp").forward(request, response);
            return;
        }

        request.setAttribute("token", token);
        request.setAttribute("role", role);
        request.getRequestDispatcher("/recover_password.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String token = clean(request.getParameter("token"));
        String role = clean(request.getParameter("role"));
        String password = clean(request.getParameter("password"));
        String confirmPassword = clean(request.getParameter("confirmPassword"));

        if (token.isEmpty() || !isValidRole(role) || !isValidToken(token, role)) {
            request.setAttribute("error", "El enlace de recuperación es inválido o ha expirado.");
            request.getRequestDispatcher("/forgot_password.jsp").forward(request, response);
            return;
        }

        if (password.isEmpty() || confirmPassword.isEmpty()) {
            forwardWithError(request, response, token, role, "Por favor completa ambos campos de contraseña.");
            return;
        }

        if (!password.equals(confirmPassword)) {
            forwardWithError(request, response, token, role, "Las contraseñas ingresadas no coinciden.");
            return;
        }

        String hashedNewPassword = util.PasswordHasher.secureHash(password);
        boolean success = false;

        if ("student".equals(role)) {
            success = studentDAO.resetPassword(token, hashedNewPassword);
        } else if ("admin".equals(role)) {
            success = adminDAO.resetPassword(token, hashedNewPassword);
        }

        if (success) {
            request.setAttribute("success", "Tu contraseña ha sido restablecida exitosamente. Inicia sesión con tus nuevas credenciales.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        request.setAttribute("error", "No se pudo restablecer la contraseña. El token podría haber expirado.");
        request.getRequestDispatcher("/forgot_password.jsp").forward(request, response);
    }

    /**
     * Sends the user back to the password recovery form preserving token and role.
     */
    private void forwardWithError(HttpServletRequest request, HttpServletResponse response, String token, String role, String error)
            throws ServletException, IOException {

        request.setAttribute("token", token);
        request.setAttribute("role", role);
        request.setAttribute("error", error);
        request.getRequestDispatcher("/recover_password.jsp").forward(request, response);
    }

    /**
     * Checks token validity according to role.
     */
    private boolean isValidToken(String token, String role) {
        if ("student".equals(role)) {
            return studentDAO.verifyResetToken(token) != null;
        }

        if ("admin".equals(role)) {
            return adminDAO.verifyResetToken(token) != null;
        }

        return false;
    }

    /**
     * Validates accepted role values.
     */
    private boolean isValidRole(String role) {
        return "student".equals(role) || "admin".equals(role);
    }

    /**
     * Cleans request parameters to avoid null values and unnecessary spaces.
     */
    private String clean(String value) {
        return value == null ? "" : value.trim();
    }
}