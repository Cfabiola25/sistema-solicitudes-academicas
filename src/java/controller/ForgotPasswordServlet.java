package controller;

import dao.AdminDAO;
import dao.StudentDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.time.LocalDateTime;
import java.util.UUID;

/**
 * Handles password reset requests.
 */
@WebServlet(name = "ForgotPasswordServlet", urlPatterns = {"/forgot-password"})
public class ForgotPasswordServlet extends HttpServlet {

    private final StudentDAO studentDAO = new StudentDAO();
    private final AdminDAO adminDAO = new AdminDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/forgot_password.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = clean(request.getParameter("email"));
        String role = clean(request.getParameter("role"));

        if (email.isEmpty() || !isValidRole(role)) {
            request.setAttribute("error", "Por favor completa el correo y selecciona un tipo de perfil válido.");
            request.getRequestDispatcher("/forgot_password.jsp").forward(request, response);
            return;
        }

        String token = UUID.randomUUID().toString();
        LocalDateTime expiration = LocalDateTime.now().plusMinutes(30);

        boolean updated = false;

        if ("student".equals(role)) {
            updated = studentDAO.updatePasswordResetToken(email, token, expiration);
        } else if ("admin".equals(role)) {
            updated = adminDAO.updatePasswordResetToken(email, token, expiration);
        }

        if (updated) {
            String resetLink = request.getScheme() + "://"
                    + request.getServerName() + ":"
                    + request.getServerPort()
                    + request.getContextPath()
                    + "/recover-password?token=" + token
                    + "&role=" + role;

            System.out.println("==================================================");
            System.out.println("[SIMULADOR DE EMAIL] Enlace de recuperación:");
            System.out.println("Correo: " + email);
            System.out.println("Rol: " + role);
            System.out.println("Expira: " + expiration);
            System.out.println(resetLink);
            System.out.println("==================================================");

            request.setAttribute("success", "Se generó el enlace de recuperación. Revisa la consola/logs del servidor.");
        } else {
            request.setAttribute("error", "El correo ingresado no pertenece a ninguna cuenta registrada como "
                    + ("student".equals(role) ? "Estudiante." : "Administrador."));
        }

        request.getRequestDispatcher("/forgot_password.jsp").forward(request, response);
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