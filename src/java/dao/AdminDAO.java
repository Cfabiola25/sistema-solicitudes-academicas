package dao;

import model.Admin;
import model.Solicitud;
import model.Student;
import model.TipoSolicitud;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Data access object for administrator related operations. It
 * includes authentication, global counts of requests, monthly
 * summaries and CRUD operations on requests from the
 * administrator perspective.
 */
public class AdminDAO {

    /**
     * Authenticates an administrator by email and password. Returns
     * the Admin object if credentials match; otherwise null.
     */
    public Admin login(String email, String password) {
        String sql = "SELECT * FROM administrador WHERE email = ? AND password = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setString(2, password);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Admin admin = new Admin();
                    admin.setId(rs.getInt("id"));
                    admin.setNombre(rs.getString("nombre"));
                    admin.setEmail(rs.getString("email"));
                    admin.setPassword(rs.getString("password"));
                    return admin;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Returns counts of requests grouped by status. The result map
     * keys correspond to status names (Enviada, Pendiente,
     * Aprobada, Rechazada).
     */
    public Map<String, Integer> getCountsByStatus() {
        Map<String, Integer> counts = new HashMap<>();
        String sql = "SELECT estado, COUNT(*) AS total FROM solicitud GROUP BY estado";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                counts.put(rs.getString("estado"), rs.getInt("total"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return counts;
    }

    /**
     * Returns counts of approved requests for each month of the
     * current year. The keys of the map are month numbers (1-12)
     * and the values are totals. Months with no data will not
     * appear in the map.
     */
    public Map<Integer, Integer> getMonthlyApprovedCounts() {
        Map<Integer, Integer> counts = new HashMap<>();
        String sql = "SELECT MONTH(fecha_solicitud) AS mes, COUNT(*) AS total " +
                "FROM solicitud WHERE estado = 'Aprobada' AND YEAR(fecha_solicitud) = YEAR(CURDATE()) " +
                "GROUP BY mes";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                counts.put(rs.getInt("mes"), rs.getInt("total"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return counts;
    }

    /**
     * Retrieves all requests. Optionally filter by state if the
     * provided filter parameter is not null or empty. The results
     * include student and type details.
     */
    public List<Solicitud> getAllRequests(String filter) {
        List<Solicitud> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT s.*, ts.nombre AS tipo_nombre, e.nombre AS est_nombre, e.apellido AS est_apellido " +
                "FROM solicitud s INNER JOIN tipo_solicitud ts ON s.tipo_solicitud_id = ts.id " +
                "INNER JOIN estudiante e ON s.estudiante_id = e.id");
        if (filter != null && !filter.isEmpty()) {
            sql.append(" WHERE s.estado = ?");
        }
        sql.append(" ORDER BY s.fecha_solicitud DESC");
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            if (filter != null && !filter.isEmpty()) {
                ps.setString(1, filter);
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Solicitud sol = new Solicitud();
                    sol.setId(rs.getInt("id"));
                    Student stu = new Student();
                    stu.setId(rs.getInt("estudiante_id"));
                    stu.setNombre(rs.getString("est_nombre"));
                    stu.setApellido(rs.getString("est_apellido"));
                    sol.setEstudiante(stu);
                    sol.setTipo(new TipoSolicitud(rs.getInt("tipo_solicitud_id"), rs.getString("tipo_nombre")));
                    sol.setDescripcion(rs.getString("descripcion"));
                    Timestamp tsql = rs.getTimestamp("fecha_solicitud");
                    sol.setFechaSolicitud(tsql != null ? tsql.toLocalDateTime() : null);
                    sol.setEstado(rs.getString("estado"));
                    sol.setDocumento(rs.getString("documento"));
                    Timestamp tRes = rs.getTimestamp("fecha_respuesta");
                    sol.setFechaRespuesta(tRes != null ? tRes.toLocalDateTime() : null);
                    sol.setComentarioRespuesta(rs.getString("comentario_respuesta"));
                    list.add(sol);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Retrieves a single request with full details by its identifier.
     * Includes student, type and any administrator response.
     */
    public Solicitud getRequestById(int requestId) {
        String sql = "SELECT s.*, ts.nombre AS tipo_nombre, e.nombre AS est_nombre, e.apellido AS est_apellido, " +
                "a.id AS admin_id, a.nombre AS admin_nombre, a.email AS admin_email " +
                "FROM solicitud s " +
                "INNER JOIN tipo_solicitud ts ON s.tipo_solicitud_id = ts.id " +
                "INNER JOIN estudiante e ON s.estudiante_id = e.id " +
                "LEFT JOIN administrador a ON s.admin_id = a.id " +
                "WHERE s.id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, requestId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Solicitud sol = new Solicitud();
                    sol.setId(rs.getInt("id"));
                    Student stu = new Student();
                    stu.setId(rs.getInt("estudiante_id"));
                    stu.setNombre(rs.getString("est_nombre"));
                    stu.setApellido(rs.getString("est_apellido"));
                    sol.setEstudiante(stu);
                    sol.setTipo(new TipoSolicitud(rs.getInt("tipo_solicitud_id"), rs.getString("tipo_nombre")));
                    sol.setDescripcion(rs.getString("descripcion"));
                    Timestamp tsql = rs.getTimestamp("fecha_solicitud");
                    sol.setFechaSolicitud(tsql != null ? tsql.toLocalDateTime() : null);
                    sol.setEstado(rs.getString("estado"));
                    sol.setDocumento(rs.getString("documento"));
                    Timestamp tRes = rs.getTimestamp("fecha_respuesta");
                    sol.setFechaRespuesta(tRes != null ? tRes.toLocalDateTime() : null);
                    sol.setComentarioRespuesta(rs.getString("comentario_respuesta"));
                    int adminId = rs.getInt("admin_id");
                    if (adminId > 0) {
                        Admin admin = new Admin();
                        admin.setId(adminId);
                        admin.setNombre(rs.getString("admin_nombre"));
                        admin.setEmail(rs.getString("admin_email"));
                        sol.setAdministrador(admin);
                    }
                    return sol;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Updates the status of a request. The administrator ID and a
     * commentary are stored together with the response date. Returns
     * true if the update succeeded.
     */
    public boolean updateStatus(int requestId, String newState, String comentario, int adminId) {
        String sql = "UPDATE solicitud SET estado = ?, comentario_respuesta = ?, fecha_respuesta = NOW(), admin_id = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newState);
            ps.setString(2, comentario);
            ps.setInt(3, adminId);
            ps.setInt(4, requestId);
            int affected = ps.executeUpdate();
            return affected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}