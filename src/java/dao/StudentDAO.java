package dao;

import model.Admin;
import model.Student;
import model.Solicitud;
import model.TipoSolicitud;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.*;

public class StudentDAO {

    public Student login(String email, String password) {
        String sql = "SELECT e.*, p.nombre AS programa_nombre, s.nombre AS sede_nombre, j.nombre AS jornada_nombre " +
                "FROM estudiante e " +
                "LEFT JOIN programa_academico p ON e.programa_id = p.id " +
                "LEFT JOIN sede s ON e.sede_id = s.id " +
                "LEFT JOIN jornada j ON e.jornada_id = j.id " +
                "WHERE e.email = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, email);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String storedPassword = rs.getString("password");

                    if (util.PasswordHasher.verifyPassword(password, storedPassword)) {
                        Student student = new Student();
                        student.setId(rs.getInt("id"));
                        student.setNombre(rs.getString("nombre"));
                        student.setApellido(rs.getString("apellido"));
                        student.setEmail(rs.getString("email"));
                        student.setPassword(storedPassword);
                        student.setProgramaId((Integer) rs.getObject("programa_id"));
                        student.setSedeId((Integer) rs.getObject("sede_id"));
                        student.setJornadaId((Integer) rs.getObject("jornada_id"));
                        student.setProgramaNombre(rs.getString("programa_nombre"));
                        student.setSedeNombre(rs.getString("sede_nombre"));
                        student.setJornadaNombre(rs.getString("jornada_nombre"));
                        student.setTerminosAceptados(rs.getBoolean("terminos_aceptados"));
                        return student;
                    }
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    public Map<String, Integer> getCountsByStatus(int studentId) {
        Map<String, Integer> counts = new HashMap<>();
        String sql = "SELECT estado, COUNT(*) AS total FROM solicitud WHERE estudiante_id = ? GROUP BY estado";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, studentId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    counts.put(rs.getString("estado"), rs.getInt("total"));
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return counts;
    }

    public List<Solicitud> getRecentRequests(int studentId, int limit) {
        List<Solicitud> list = new ArrayList<>();

        String sql = "SELECT s.id, s.tipo_solicitud_id, ts.nombre AS tipo_nombre, s.descripcion, " +
                "s.fecha_solicitud, s.estado, s.fecha_limite " +
                "FROM solicitud s " +
                "INNER JOIN tipo_solicitud ts ON s.tipo_solicitud_id = ts.id " +
                "WHERE s.estudiante_id = ? " +
                "ORDER BY s.id DESC LIMIT ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, studentId);
            ps.setInt(2, limit);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapBasicSolicitud(rs));
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    public List<Solicitud> getAllRequests(int studentId, String state) {
        List<Solicitud> list = new ArrayList<>();

        StringBuilder sql = new StringBuilder();
        sql.append("SELECT s.id, s.tipo_solicitud_id, ts.nombre AS tipo_nombre, s.descripcion, ")
           .append("s.fecha_solicitud, s.estado, s.fecha_limite ")
           .append("FROM solicitud s ")
           .append("INNER JOIN tipo_solicitud ts ON s.tipo_solicitud_id = ts.id ")
           .append("WHERE s.estudiante_id = ? ");

        if (state != null && !state.trim().isEmpty()) {
            sql.append("AND s.estado = ? ");
        }

        sql.append("ORDER BY s.id DESC");

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            ps.setInt(1, studentId);

            if (state != null && !state.trim().isEmpty()) {
                ps.setString(2, state);
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapBasicSolicitud(rs));
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    public List<Solicitud> getAllRequestsPaged(int studentId, String state, int page, int pageSize) {
        List<Solicitud> list = new ArrayList<>();

        if (page <= 0) {
            page = 1;
        }

        StringBuilder sql = new StringBuilder();
        sql.append("SELECT s.id, s.tipo_solicitud_id, ts.nombre AS tipo_nombre, s.descripcion, ")
           .append("s.fecha_solicitud, s.estado, s.fecha_limite ")
           .append("FROM solicitud s ")
           .append("INNER JOIN tipo_solicitud ts ON s.tipo_solicitud_id = ts.id ")
           .append("WHERE s.estudiante_id = ? ");

        if (state != null && !state.trim().isEmpty()) {
            sql.append("AND s.estado = ? ");
        }

        sql.append("ORDER BY s.id DESC LIMIT ? OFFSET ?");

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            int index = 1;
            ps.setInt(index++, studentId);

            if (state != null && !state.trim().isEmpty()) {
                ps.setString(index++, state);
            }

            ps.setInt(index++, pageSize);
            ps.setInt(index, (page - 1) * pageSize);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapBasicSolicitud(rs));
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    public int getRequestsCount(int studentId, String state) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM solicitud WHERE estudiante_id = ? ");

        if (state != null && !state.trim().isEmpty()) {
            sql.append("AND estado = ?");
        }

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            ps.setInt(1, studentId);

            if (state != null && !state.trim().isEmpty()) {
                ps.setString(2, state);
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

    public Solicitud getById(int studentId, int requestId) {
        String sql = "SELECT s.*, ts.nombre AS tipo_nombre, " +
                "a.id AS admin_id, a.nombre AS admin_nombre, a.email AS admin_email, " +
                "resp.id AS resp_id, resp.nombre AS resp_nombre, resp.email AS resp_email " +
                "FROM solicitud s " +
                "INNER JOIN tipo_solicitud ts ON s.tipo_solicitud_id = ts.id " +
                "LEFT JOIN administrador a ON s.admin_id = a.id " +
                "LEFT JOIN administrador resp ON s.responsable_id = resp.id " +
                "WHERE s.estudiante_id = ? AND s.id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, studentId);
            ps.setInt(2, requestId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Solicitud sol = new Solicitud();
                    sol.setId(rs.getInt("id"));

                    Student student = new Student();
                    student.setId(studentId);
                    sol.setEstudiante(student);

                    sol.setTipo(new TipoSolicitud(rs.getInt("tipo_solicitud_id"), rs.getString("tipo_nombre")));
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

                    int adminId = rs.getInt("admin_id");
                    if (adminId > 0) {
                        Admin admin = new Admin();
                        admin.setId(adminId);
                        admin.setNombre(rs.getString("admin_nombre"));
                        admin.setEmail(rs.getString("admin_email"));
                        sol.setAdministrador(admin);
                    }

                    int respId = rs.getInt("resp_id");
                    if (respId > 0) {
                        Admin responsable = new Admin();
                        responsable.setId(respId);
                        responsable.setNombre(rs.getString("resp_nombre"));
                        responsable.setEmail(rs.getString("resp_email"));
                        sol.setResponsable(responsable);
                    }

                    return sol;
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    public boolean createRequest(Solicitud sol) {
        int days = 5;
        String type = "habiles";

        String selectSql = "SELECT tiempo_respuesta_dias, tipo_tiempo FROM tipo_solicitud WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(selectSql)) {

            ps.setInt(1, sol.getTipo().getId());

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    days = rs.getInt("tiempo_respuesta_dias");
                    type = rs.getString("tipo_tiempo");
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        LocalDateTime deadline = util.SLACalculator.calculateDeadline(LocalDateTime.now(), days, type);

        String sql = "INSERT INTO solicitud " +
                "(estudiante_id, tipo_solicitud_id, descripcion, documento, fecha_limite) " +
                "VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, sol.getEstudiante().getId());
            ps.setInt(2, sol.getTipo().getId());
            ps.setString(3, sol.getDescripcion());
            ps.setString(4, sol.getDocumento());
            ps.setTimestamp(5, Timestamp.valueOf(deadline));

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    public boolean updateRequest(Solicitud sol) {
        String sql = "UPDATE solicitud " +
                "SET descripcion = ?, documento = ? " +
                "WHERE id = ? AND estudiante_id = ? AND estado IN ('Enviada', 'Pendiente')";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, sol.getDescripcion());
            ps.setString(2, sol.getDocumento());
            ps.setInt(3, sol.getId());
            ps.setInt(4, sol.getEstudiante().getId());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    public boolean createStudent(Student student) {
        String sql = "INSERT INTO estudiante " +
                "(nombre, apellido, email, password, programa_id, sede_id, jornada_id, terminos_aceptados) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, student.getNombre());
            ps.setString(2, student.getApellido());
            ps.setString(3, student.getEmail());
            ps.setString(4, student.getPassword());
            ps.setInt(5, student.getProgramaId());
            ps.setInt(6, student.getSedeId());
            ps.setInt(7, student.getJornadaId());
            ps.setInt(8, student.isTerminosAceptados() ? 1 : 0);

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    public boolean emailExists(String email) {
        String sqlStudent = "SELECT id FROM estudiante WHERE email = ?";
        String sqlAdmin = "SELECT id FROM administrador WHERE email = ?";

        try (Connection conn = DBConnection.getConnection()) {

            try (PreparedStatement ps = conn.prepareStatement(sqlStudent)) {
                ps.setString(1, email);

                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        return true;
                    }
                }
            }

            try (PreparedStatement ps = conn.prepareStatement(sqlAdmin)) {
                ps.setString(1, email);

                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        return true;
                    }
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    public boolean updatePasswordResetToken(String email, String token, LocalDateTime expiration) {
        String sql = "UPDATE estudiante SET recuperacion_token = ?, token_expiracion = ? WHERE email = ?";

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
        String sql = "SELECT email FROM estudiante WHERE recuperacion_token = ? AND token_expiracion > NOW()";

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
        String sql = "UPDATE estudiante " +
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

    public boolean cancelRequest(int studentId, int requestId) {
        String sql = "UPDATE solicitud " +
                "SET estado = 'Anulada', " +
                "fecha_respuesta = NOW(), " +
                "comentario_respuesta = 'Solicitud anulada por el estudiante.' " +
                "WHERE id = ? AND estudiante_id = ? AND estado IN ('Enviada', 'Pendiente')";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, requestId);
            ps.setInt(2, studentId);

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    public boolean updatePasswordByAdmin(int studentId, String hashedPassword) {
        String sql = "UPDATE estudiante SET password = ? WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, hashedPassword);
            ps.setInt(2, studentId);

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    private Solicitud mapBasicSolicitud(ResultSet rs) throws SQLException {
        Solicitud sol = new Solicitud();

        sol.setId(rs.getInt("id"));
        sol.setTipo(new TipoSolicitud(rs.getInt("tipo_solicitud_id"), rs.getString("tipo_nombre")));
        sol.setDescripcion(rs.getString("descripcion"));
        sol.setEstado(rs.getString("estado"));

        Timestamp fechaSolicitud = rs.getTimestamp("fecha_solicitud");
        sol.setFechaSolicitud(fechaSolicitud != null ? fechaSolicitud.toLocalDateTime() : null);

        Timestamp fechaLimite = rs.getTimestamp("fecha_limite");
        sol.setFechaLimite(fechaLimite != null ? fechaLimite.toLocalDateTime() : null);

        return sol;
    }
}