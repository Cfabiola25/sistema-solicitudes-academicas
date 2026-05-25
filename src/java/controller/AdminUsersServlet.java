package controller;

import dao.AdminDAO;
import model.Admin;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

/**
 * Allows administrators to create and manage other administrator accounts.
 * The only role used by the system is 'admin'.
 */
@WebServlet(name = "AdminUsersServlet", urlPatterns = {"/admin/admin-users"})
public class AdminUsersServlet extends HttpServlet {

    private final AdminDAO adminDAO = new AdminDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (!isAdminSession(session)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        loadAdmins(request);
        request.getRequestDispatcher("/admin/admin_users.jsp").forward(request, response);
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
            createAdmin(request, response);
            return;
        }

        if ("delete".equals(action)) {
            deleteAdmin(request, response);
            return;
        }

        response.sendRedirect(request.getContextPath() + "/admin/admin-users");
    }

    /**
     * Creates a new admin account.
     */
    private void createAdmin(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String nombre = clean(request.getParameter("nombre"));
        String email = clean(request.getParameter("email")).toLowerCase();
        String password = clean(request.getParameter("password"));

        if (nombre.isEmpty() || email.isEmpty() || password.isEmpty()) {
            forwardWithError(request, response, "Todos los campos son obligatorios.");
            return;
        }

        if (adminDAO.adminEmailExists(email)) {
            forwardWithError(request, response, "Ya existe un administrador registrado con ese correo.");
            return;
        }

        Admin admin = new Admin();
        admin.setNombre(nombre);
        admin.setEmail(email);
        admin.setPassword(util.PasswordHasher.secureHash(password));
        admin.setRol("admin");

        boolean created = adminDAO.createAdmin(admin);

        if (!created) {
            forwardWithError(request, response, "No fue posible crear el administrador.");
            return;
        }

        response.sendRedirect(request.getContextPath() + "/admin/admin-users");
    }

    /**
     * Deletes an admin account.
     */
    private void deleteAdmin(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        Integer id = parseInteger(request.getParameter("id"));

        if (id != null && id > 0) {
            adminDAO.deleteAdmin(id);
        }

        response.sendRedirect(request.getContextPath() + "/admin/admin-users");
    }

    /**
     * Loads all administrators.
     */
    private void loadAdmins(HttpServletRequest request) {
        List<Admin> admins = adminDAO.getAllAdmins();
        request.setAttribute("admins", admins);
    }

    /**
     * Sends the user back to the administrator management view with an error.
     */
    private void forwardWithError(HttpServletRequest request, HttpServletResponse response, String error)
            throws ServletException, IOException {

        request.setAttribute("error", error);
        loadAdmins(request);
        request.getRequestDispatcher("/admin/admin_users.jsp").forward(request, response);
    }

    /**
     * Validates admin session.
     */
    private boolean isAdminSession(HttpSession session) {
        return session != null && "admin".equals(session.getAttribute("role"));
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
     * Cleans request values.
     */
    private String clean(String value) {
        return value == null ? "" : value.trim();
    }
}