package dao;

import model.Admin;
import model.Solicitud;
import model.Student;
import model.TipoSolicitud;

import java.sql.*;
import java.time.LocalDateTime;
import java.nio.charset.StandardCharsets;
import java.util.*;

/**
 * Data access object for administrator related operations.
 */
public class AdminDAO {

    private static final String DEFAULT_ADMIN_ROLE = "Admin";

    public Admin login(String email, String password) {
        String sql = "SELECT * FROM administrador WHERE email = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, email);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String storedPassword = rs.getString("password");

                    if (util.PasswordHasher.verifyPassword(password, storedPassword)) {
                        Admin admin = new Admin();
                        admin.setId(rs.getInt("id"));
                        admin.setNombre(rs.getString("nombre"));
                        admin.setEmail(rs.getString("email"));
                        admin.setPassword(storedPassword);
                        admin.setRol(rs.getString("rol"));
                        return admin;
                    }
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    /**
     * Creates a new administrator.
     * Role is stored using a valid database value for administrator accounts.
     */
    public boolean createAdmin(Admin admin) {
        String sql = "INSERT INTO administrador (nombre, email, password, rol) VALUES (?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, admin.getNombre());
            ps.setString(2, admin.getEmail());
            ps.setString(3, admin.getPassword());
            ps.setString(4, DEFAULT_ADMIN_ROLE);

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    /**
     * Checks if an administrator email already exists.
     */
    public boolean adminEmailExists(String email) {
        String sql = "SELECT id FROM administrador WHERE email = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, email);

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    /**
     * Gets all registered administrators.
     */
    public List<Admin> getAllAdmins() {
        List<Admin> list = new ArrayList<>();
        String sql = "SELECT id, nombre, email, rol FROM administrador ORDER BY nombre";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Admin admin = new Admin();
                admin.setId(rs.getInt("id"));
                admin.setNombre(rs.getString("nombre"));
                admin.setEmail(rs.getString("email"));
                admin.setRol(rs.getString("rol"));
                list.add(admin);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    /**
     * Deletes an administrator only if it is not assigned to requests.
     */
    public boolean deleteAdmin(int adminId) {
        String sql = "DELETE FROM administrador WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, adminId);
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

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

    public Map<Integer, Integer> getMonthlyApprovedCounts() {
        Map<Integer, Integer> counts = new HashMap<>();

        String sql = "SELECT MONTH(fecha_solicitud) AS mes, COUNT(*) AS total " +
                "FROM solicitud " +
                "WHERE estado = 'Aprobada' AND YEAR(fecha_solicitud) = YEAR(CURDATE()) " +
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

    private void applyFilterSql(StringBuilder sql, String filter, List<Object> params) {
        if (filter == null || filter.trim().isEmpty()) {
            return;
        }

        if ("En trámite".equalsIgnoreCase(filter)) {
            sql.append(" WHERE s.estado IN ('Enviada', 'Pendiente')");
        } else if ("Cerrada".equalsIgnoreCase(filter)) {
            sql.append(" WHERE s.estado IN ('Aprobada', 'Rechazada')");
        } else if ("Vencidas".equalsIgnoreCase(filter)) {
            sql.append(" WHERE s.estado IN ('Enviada', 'Pendiente') AND s.fecha_limite < NOW()");
        } else if ("PorVencer".equalsIgnoreCase(filter)) {
            sql.append(" WHERE s.estado IN ('Enviada', 'Pendiente') ")
               .append("AND s.fecha_limite >= NOW() ")
               .append("AND s.fecha_limite <= DATE_ADD(NOW(), INTERVAL 2 DAY)");
        } else {
            sql.append(" WHERE s.estado = ?");
            params.add(filter);
        }
    }

    private String fixText(String value) {
        if (value == null || (!value.contains("Ã") && !value.contains("Â"))) {
            return value;
        }

        String repaired = new String(value.getBytes(StandardCharsets.ISO_8859_1), StandardCharsets.UTF_8);
        return repaired.isEmpty() ? value : repaired;
    }

    public List<Solicitud> getAllRequests(String filter) {
        return getRequests(filter, 0, 0, false);
    }

    public List<Solicitud> getAllRequestsPaged(String filter, int page, int pageSize) {
        return getRequests(filter, page, pageSize, true);
    }

    private List<Solicitud> getRequests(String filter, int page, int pageSize, boolean paged) {
        List<Solicitud> list = new ArrayList<>();

        StringBuilder sql = new StringBuilder();
        sql.append("SELECT s.*, ")
           .append("ts.nombre AS tipo_nombre, ")
           .append("e.nombre AS est_nombre, e.apellido AS est_apellido, ")
           .append("resp.id AS resp_id, resp.nombre AS resp_nombre, resp.email AS resp_email ")
           .append("FROM solicitud s ")
           .append("INNER JOIN tipo_solicitud ts ON s.tipo_solicitud_id = ts.id ")
           .append("INNER JOIN estudiante e ON s.estudiante_id = e.id ")
           .append("LEFT JOIN administrador resp ON s.responsable_id = resp.id");

        List<Object> params = new ArrayList<>();
        applyFilterSql(sql, filter, params);

        sql.append(" ORDER BY s.id DESC");

        if (paged) {
            sql.append(" LIMIT ? OFFSET ?");
        }

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            int index = 1;

            for (Object param : params) {
                ps.setObject(index++, param);
            }

            if (paged) {
                ps.setInt(index++, pageSize);
                ps.setInt(index, (page - 1) * pageSize);
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapSolicitud(rs));
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    public int getRequestsCount(String filter) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM solicitud s");
        List<Object> params = new ArrayList<>();

        applyFilterSql(sql, filter, params);

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return 0;
    }

    public int getRequestsCountForAdmin(String filter, int adminId) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM solicitud s");
        List<Object> params = new ArrayList<>();

        applyFilterSql(sql, filter, params);

        if (params.isEmpty()) {
            sql.append(" WHERE s.responsable_id = ?");
        } else {
            sql.append(" AND s.responsable_id = ?");
        }

        params.add(adminId);

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return 0;
    }

    public List<Solicitud> getRequestsForAdminPaged(String filter, int adminId, int page, int pageSize) {
        List<Solicitud> list = new ArrayList<>();

        StringBuilder sql = new StringBuilder();
        sql.append("SELECT s.*, ")
           .append("ts.nombre AS tipo_nombre, ")
           .append("e.nombre AS est_nombre, e.apellido AS est_apellido, ")
           .append("resp.id AS resp_id, resp.nombre AS resp_nombre, resp.email AS resp_email ")
           .append("FROM solicitud s ")
           .append("INNER JOIN tipo_solicitud ts ON s.tipo_solicitud_id = ts.id ")
           .append("INNER JOIN estudiante e ON s.estudiante_id = e.id ")
           .append("LEFT JOIN administrador resp ON s.responsable_id = resp.id");

        List<Object> params = new ArrayList<>();
        applyFilterSql(sql, filter, params);

        if (params.isEmpty()) {
            sql.append(" WHERE s.responsable_id = ?");
        } else {
            sql.append(" AND s.responsable_id = ?");
        }

        sql.append(" ORDER BY s.id DESC");

        if (page > 0 && pageSize > 0) {
            sql.append(" LIMIT ? OFFSET ?");
        }

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            int index = 1;
            for (Object param : params) {
                ps.setObject(index++, param);
            }

            ps.setInt(index++, adminId);

            if (page > 0 && pageSize > 0) {
                ps.setInt(index++, pageSize);
                ps.setInt(index, (page - 1) * pageSize);
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapSolicitud(rs));
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    public Solicitud getRequestById(int requestId) {
        String sql = "SELECT s.*, " +
                "ts.nombre AS tipo_nombre, " +
                "e.nombre AS est_nombre, e.apellido AS est_apellido, " +
                "a.id AS admin_id, a.nombre AS admin_nombre, a.email AS admin_email, " +
                "resp.id AS resp_id, resp.nombre AS resp_nombre, resp.email AS resp_email " +
                "FROM solicitud s " +
                "INNER JOIN tipo_solicitud ts ON s.tipo_solicitud_id = ts.id " +
                "INNER JOIN estudiante e ON s.estudiante_id = e.id " +
                "LEFT JOIN administrador a ON s.admin_id = a.id " +
                "LEFT JOIN administrador resp ON s.responsable_id = resp.id " +
                "WHERE s.id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, requestId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Solicitud solicitud = mapSolicitud(rs);

                    int adminId = rs.getInt("admin_id");

                    if (adminId > 0) {
                        Admin admin = new Admin();
                        admin.setId(adminId);
                        admin.setNombre(rs.getString("admin_nombre"));
                        admin.setEmail(rs.getString("admin_email"));
                        admin.setRol(DEFAULT_ADMIN_ROLE);
                        solicitud.setAdministrador(admin);
                    }

                    return solicitud;
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    private Solicitud mapSolicitud(ResultSet rs) throws SQLException {
        Solicitud sol = new Solicitud();

        sol.setId(rs.getInt("id"));

        Student student = new Student();
        student.setId(rs.getInt("estudiante_id"));
        student.setNombre(rs.getString("est_nombre"));
        student.setApellido(rs.getString("est_apellido"));
        sol.setEstudiante(student);

        TipoSolicitud tipo = new TipoSolicitud(rs.getInt("tipo_solicitud_id"), fixText(rs.getString("tipo_nombre")));
        sol.setTipo(tipo);

        sol.setDescripcion(rs.getString("descripcion"));
        sol.setEstado(rs.getString("estado"));
        sol.setDocumento(rs.getString("documento"));
        sol.setComentarioRespuesta(rs.getString("comentario_respuesta"));

        Timestamp fechaSolicitud = rs.getTimestamp("fecha_solicitud");
        sol.setFechaSolicitud(fechaSolicitud != null ? fechaSolicitud.toLocalDateTime() : null);

        Timestamp fechaRespuesta = rs.getTimestamp("fecha_respuesta");
        sol.setFechaRespuesta(fechaRespuesta != null ? fechaRespuesta.toLocalDateTime() : null);

        Timestamp fechaLimite = rs.getTimestamp("fecha_limite");
        sol.setFechaLimite(fechaLimite != null ? fechaLimite.toLocalDateTime() : null);

        int respId = rs.getInt("resp_id");

        if (respId > 0) {
            Admin responsable = new Admin();
            responsable.setId(respId);
            responsable.setNombre(rs.getString("resp_nombre"));
            responsable.setEmail(rs.getString("resp_email"));
            responsable.setRol(DEFAULT_ADMIN_ROLE);
            sol.setResponsable(responsable);
        }

        return sol;
    }

    public boolean updateStatus(int requestId, String newState, String comentario, int adminId) {
        Solicitud sol = getRequestById(requestId);

        if (sol == null) {
            return false;
        }

        String sql = "UPDATE solicitud " +
                "SET estado = ?, comentario_respuesta = ?, fecha_respuesta = NOW(), admin_id = ? " +
                "WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, newState);
            ps.setString(2, comentario);
            ps.setInt(3, adminId);
            ps.setInt(4, requestId);

            int affected = ps.executeUpdate();

            if (affected > 0) {
                registerLateAuditIfNeeded(conn, sol, newState, adminId);
                return true;
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    private void registerLateAuditIfNeeded(Connection conn, Solicitud sol, String newState, int adminId)
            throws SQLException {

        if (!("Aprobada".equals(newState) || "Rechazada".equals(newState))) {
            return;
        }

        if (sol.getFechaLimite() == null || !LocalDateTime.now().isAfter(sol.getFechaLimite())) {
            return;
        }

        long diffSeconds = java.time.Duration.between(sol.getFechaLimite(), LocalDateTime.now()).getSeconds();
        long diffDays = diffSeconds / (24 * 3600);

        if (diffDays == 0 && diffSeconds > 0) {
            diffDays = 1;
        }

        if (diffDays <= 0) {
            return;
        }

        String sql = "INSERT INTO auditoria_retraso (solicitud_id, admin_id, dias_retraso) VALUES (?, ?, ?)";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, sol.getId());
            ps.setInt(2, adminId);
            ps.setInt(3, (int) diffDays);
            ps.executeUpdate();
        }
    }

    public boolean assignRequest(int requestId, int adminId) {
        String sql = "UPDATE solicitud SET responsable_id = ?, estado = 'Pendiente' WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            if (adminId > 0) {
                ps.setInt(1, adminId);
            } else {
                ps.setNull(1, Types.INTEGER);
            }

            ps.setInt(2, requestId);
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    public int getExpiredRequestsCount() {
        String sql = "SELECT COUNT(*) FROM solicitud " +
                "WHERE estado IN ('Enviada', 'Pendiente') AND fecha_limite < NOW()";

        return getSingleInt(sql);
    }

    public int getAboutToExpireRequestsCount() {
        String sql = "SELECT COUNT(*) FROM solicitud " +
                "WHERE estado IN ('Enviada', 'Pendiente') " +
                "AND fecha_limite >= NOW() " +
                "AND fecha_limite <= DATE_ADD(NOW(), INTERVAL 2 DAY)";

        return getSingleInt(sql);
    }

    private int getSingleInt(String sql) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return rs.getInt(1);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return 0;
    }

    public List<Student> getAllStudents() {
        List<Student> list = new ArrayList<>();

        String sql = "SELECT e.*, p.nombre AS prog_nombre, s.nombre AS sede_nombre, j.nombre AS jor_nombre " +
                "FROM estudiante e " +
                "LEFT JOIN programa_academico p ON e.programa_id = p.id " +
                "LEFT JOIN sede s ON e.sede_id = s.id " +
                "LEFT JOIN jornada j ON e.jornada_id = j.id " +
                "ORDER BY e.apellido, e.nombre";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Student student = new Student();
                student.setId(rs.getInt("id"));
                student.setNombre(rs.getString("nombre"));
                student.setApellido(rs.getString("apellido"));
                student.setEmail(rs.getString("email"));
                student.setPassword(rs.getString("password"));
                student.setProgramaId(readNullableInteger(rs, "programa_id"));
                student.setSedeId(readNullableInteger(rs, "sede_id"));
                student.setJornadaId(readNullableInteger(rs, "jornada_id"));
                student.setProgramaNombre(rs.getString("prog_nombre"));
                student.setSedeNombre(rs.getString("sede_nombre"));
                student.setJornadaNombre(rs.getString("jor_nombre"));
                list.add(student);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    private Integer readNullableInteger(ResultSet rs, String columnLabel) throws SQLException {
        int value = rs.getInt(columnLabel);
        return rs.wasNull() ? null : value;
    }

    public boolean updatePasswordResetToken(String email, String token, LocalDateTime expiration) {
        String sql = "UPDATE administrador SET recuperacion_token = ?, token_expiracion = ? WHERE email = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, token);
            ps.setTimestamp(2, Timestamp.valueOf(expiration));
            ps.setString(3, email);

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    public String verifyResetToken(String token) {
        String sql = "SELECT email FROM administrador WHERE recuperacion_token = ? AND token_expiracion > NOW()";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, token);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("email");
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    public boolean resetPassword(String token, String hashedNewPassword) {
        String sql = "UPDATE administrador " +
                "SET password = ?, recuperacion_token = NULL, token_expiracion = NULL " +
                "WHERE recuperacion_token = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, hashedNewPassword);
            ps.setString(2, token);

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }
}