package dao;

import model.Student;
import model.Solicitud;
import model.TipoSolicitud;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import model.Admin;

/**
 * Data access object for student related operations. It provides
 * methods to authenticate students, retrieve counts of their
 * requests by status and fetch recent or all requests.
 */
public class StudentDAO {

    /**
     * Attempts to authenticate a student with the provided email and
     * password. Returns a populated Student object if the credentials
     * are valid, otherwise returns null.
     */
    public Student login(String email, String password) {
        String sql = "SELECT * FROM estudiante WHERE email = ? AND password = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setString(2, password);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Student s = new Student();
                    s.setId(rs.getInt("id"));
                    s.setNombre(rs.getString("nombre"));
                    s.setApellido(rs.getString("apellido"));
                    s.setEmail(rs.getString("email"));
                    s.setPassword(rs.getString("password"));
                    s.setProgramaId((Integer)rs.getObject("programa_id"));
                    s.setSedeId((Integer)rs.getObject("sede_id"));
                    s.setJornadaId((Integer)rs.getObject("jornada_id"));
                    return s;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Returns a map with the number of requests per status for a
     * specific student. The keys correspond to the status names
     * (Enviada, Pendiente, Aprobada, Rechazada). If a status has
     * no requests it will not appear in the map.
     */
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

    /**
     * Retrieves the most recent requests for a student. The result
     * list is limited to the specified number of rows and ordered
     * descending by submission date.
     */
    public List<Solicitud> getRecentRequests(int studentId, int limit) {
        List<Solicitud> list = new ArrayList<>();
        String sql = "SELECT s.id, s.tipo_solicitud_id, ts.nombre AS tipo_nombre, s.descripcion, s.fecha_solicitud, s.estado " +
                "FROM solicitud s INNER JOIN tipo_solicitud ts ON s.tipo_solicitud_id = ts.id " +
                "WHERE s.estudiante_id = ? ORDER BY s.fecha_solicitud DESC LIMIT ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ps.setInt(2, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Solicitud sol = new Solicitud();
                    sol.setId(rs.getInt("id"));
                    sol.setTipo(new TipoSolicitud(rs.getInt("tipo_solicitud_id"), rs.getString("tipo_nombre")));
                    sol.setDescripcion(rs.getString("descripcion"));
                    Timestamp tsql = rs.getTimestamp("fecha_solicitud");
                    sol.setFechaSolicitud(tsql != null ? tsql.toLocalDateTime() : null);
                    sol.setEstado(rs.getString("estado"));
                    list.add(sol);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Retrieves all requests associated with a student. Results can
     * optionally be filtered by status if the state parameter is
     * not null or empty. Requests are ordered by submission date
     * descending.
     */
    public List<Solicitud> getAllRequests(int studentId, String state) {
        List<Solicitud> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT s.id, s.tipo_solicitud_id, ts.nombre AS tipo_nombre, s.descripcion, s.fecha_solicitud, s.estado " +
                "FROM solicitud s INNER JOIN tipo_solicitud ts ON s.tipo_solicitud_id = ts.id " +
                "WHERE s.estudiante_id = ?");
        if (state != null && !state.isEmpty()) {
            sql.append(" AND s.estado = ?");
        }
        sql.append(" ORDER BY s.fecha_solicitud DESC");
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            ps.setInt(1, studentId);
            if (state != null && !state.isEmpty()) {
                ps.setString(2, state);
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Solicitud sol = new Solicitud();
                    sol.setId(rs.getInt("id"));
                    sol.setTipo(new TipoSolicitud(rs.getInt("tipo_solicitud_id"), rs.getString("tipo_nombre")));
                    sol.setDescripcion(rs.getString("descripcion"));
                    Timestamp tsql = rs.getTimestamp("fecha_solicitud");
                    sol.setFechaSolicitud(tsql != null ? tsql.toLocalDateTime() : null);
                    sol.setEstado(rs.getString("estado"));
                    list.add(sol);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Retrieves a single request by its identifier for a specific student.
     * The request is returned with full details including any response
     * from an administrator. Returns null if the request does not
     * belong to the student or does not exist.
     */
    public Solicitud getById(int studentId, int requestId) {
        String sql = "SELECT s.*, ts.nombre AS tipo_nombre, a.id AS admin_id, a.nombre AS admin_nombre, a.email AS admin_email " +
                "FROM solicitud s " +
                "INNER JOIN tipo_solicitud ts ON s.tipo_solicitud_id = ts.id " +
                "LEFT JOIN administrador a ON s.admin_id = a.id " +
                "WHERE s.estudiante_id = ? AND s.id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ps.setInt(2, requestId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Solicitud sol = new Solicitud();
                    sol.setId(rs.getInt("id"));
                    // build student
                    Student stu = new Student();
                    stu.setId(studentId);
                    sol.setEstudiante(stu);
                    sol.setTipo(new TipoSolicitud(rs.getInt("tipo_solicitud_id"), rs.getString("tipo_nombre")));
                    sol.setDescripcion(rs.getString("descripcion"));
                    Timestamp tsql = rs.getTimestamp("fecha_solicitud");
                    sol.setFechaSolicitud(tsql != null ? tsql.toLocalDateTime() : null);
                    sol.setEstado(rs.getString("estado"));
                    sol.setDocumento(rs.getString("documento"));
                    Timestamp tsp = rs.getTimestamp("fecha_respuesta");
                    sol.setFechaRespuesta(tsp != null ? tsp.toLocalDateTime() : null);
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
     * Creates a new request in the database. The Solicitud object
     * must contain a valid Student (with id), TipoSolicitud (with
     * id), description and optionally a document path. The state
     * will be set to 'Enviada' by default.
     */
    public boolean createRequest(Solicitud sol) {
        String sql = "INSERT INTO solicitud (estudiante_id, tipo_solicitud_id, descripcion, documento) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, sol.getEstudiante().getId());
            ps.setInt(2, sol.getTipo().getId());
            ps.setString(3, sol.getDescripcion());
            ps.setString(4, sol.getDocumento());
            int affected = ps.executeUpdate();
            return affected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}