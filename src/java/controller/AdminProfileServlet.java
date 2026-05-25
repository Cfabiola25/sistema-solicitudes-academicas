package controller;

import model.Admin;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

/**
 * Shows the profile information of the logged-in administrator.
 */
@WebServlet(name = "AdminProfileServlet", urlPatterns = {"/admin/profile"})
public class AdminProfileServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Admin admin = (Admin) session.getAttribute("user");

        if (admin == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        request.setAttribute("admin", admin);
        request.getRequestDispatcher("/admin/profile.jsp").forward(request, response);
    }
}