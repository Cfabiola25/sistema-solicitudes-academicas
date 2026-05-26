package dao;

import model.Admin;
import model.TipoSolicitud;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;

/**
 * DAO for CRUD operations on the TipoSolicitud table.
 */
public class TipoSolicitudDAO {

    /**
     * Returns all available request types ordered by their name, including SLA parameters.
     */
    public List<TipoSolicitud> getAll() {
        List<TipoSolicitud> list = new ArrayList<>();
        String sql = "SELECT id, nombre, tiempo_respuesta_dias, tipo_tiempo FROM tipo_solicitud ORDER BY nombre";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(new TipoSolicitud(
                    rs.getInt("id"), 
                    fixText(rs.getString("nombre")),
                    rs.getInt("tiempo_respuesta_dias"),
                    rs.getString("tipo_tiempo")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Finds a request type by its ID.
     */
    public TipoSolicitud getById(int id) {
        String sql = "SELECT id, nombre, tiempo_respuesta_dias, tipo_tiempo FROM tipo_solicitud WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new TipoSolicitud(
                        rs.getInt("id"), 
                        fixText(rs.getString("nombre")),
                        rs.getInt("tiempo_respuesta_dias"),
                        rs.getString("tipo_tiempo")
                    );
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Creates a new request type.
     */
    public boolean create(TipoSolicitud t) {
        return create(t, Collections.emptyList());
    }

    /**
     * Creates a new request type and assigns one or more default responsible admins.
     */
    public boolean create(TipoSolicitud t, List<Integer> adminIds) {
        String sql = "INSERT INTO tipo_solicitud (nombre, tiempo_respuesta_dias, tipo_tiempo) VALUES (?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            conn.setAutoCommit(false);

            ps.setString(1, t.getNombre());
            ps.setInt(2, t.getTiempoRespuestaDias());
            ps.setString(3, t.getTipoTiempo());

            if (ps.executeUpdate() <= 0) {
                conn.rollback();
                return false;
            }

            int tipoId;
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (!keys.next()) {
                    conn.rollback();
                    return false;
                }
                tipoId = keys.getInt(1);
            }

            if (!saveResponsables(conn, tipoId, adminIds)) {
                conn.rollback();
                return false;
            }

            conn.commit();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    private String fixText(String value) {
        if (value == null || (!value.contains("Ã") && !value.contains("Â"))) {
            return value;
        }

        String repaired = new String(value.getBytes(StandardCharsets.ISO_8859_1), StandardCharsets.UTF_8);
        return repaired.isEmpty() ? value : repaired;
    }

    /**
     * Returns the responsible admins assigned to each request type.
     */
    public Map<Integer, List<Admin>> getResponsablesByTipoSolicitud() {
        Map<Integer, List<Admin>> responsablesPorTipo = new HashMap<>();
        String sql = "SELECT tr.tipo_solicitud_id, a.id, a.nombre, a.email, a.rol " +
                "FROM tipo_solicitud_responsable tr " +
                "INNER JOIN administrador a ON tr.admin_id = a.id " +
                "ORDER BY tr.tipo_solicitud_id, a.nombre";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                int tipoId = rs.getInt("tipo_solicitud_id");

                Admin admin = new Admin();
                admin.setId(rs.getInt("id"));
                admin.setNombre(rs.getString("nombre"));
                admin.setEmail(rs.getString("email"));
                admin.setRol(rs.getString("rol"));

                responsablesPorTipo.computeIfAbsent(tipoId, key -> new ArrayList<>()).add(admin);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return responsablesPorTipo;
    }

    /**
     * Updates an existing request type.
     */
    public boolean update(TipoSolicitud t) {
        return update(t, Collections.emptyList());
    }

    /**
     * Updates an existing request type and its responsible admins.
     */
    public boolean update(TipoSolicitud t, List<Integer> adminIds) {
        String sql = "UPDATE tipo_solicitud SET nombre = ?, tiempo_respuesta_dias = ?, tipo_tiempo = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            conn.setAutoCommit(false);

            ps.setString(1, t.getNombre());
            ps.setInt(2, t.getTiempoRespuestaDias());
            ps.setString(3, t.getTipoTiempo());
            ps.setInt(4, t.getId());

            if (ps.executeUpdate() <= 0) {
                conn.rollback();
                return false;
            }

            if (!saveResponsables(conn, t.getId(), adminIds)) {
                conn.rollback();
                return false;
            }

            conn.commit();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Deletes a request type by its ID.
     */

    private boolean saveResponsables(Connection conn, int tipoSolicitudId, List<Integer> adminIds) throws SQLException {
        String deleteSql = "DELETE FROM tipo_solicitud_responsable WHERE tipo_solicitud_id = ?";
        String insertSql = "INSERT INTO tipo_solicitud_responsable (tipo_solicitud_id, admin_id) VALUES (?, ?)";

        try (PreparedStatement deletePs = conn.prepareStatement(deleteSql)) {
            deletePs.setInt(1, tipoSolicitudId);
            deletePs.executeUpdate();
        }

        if (adminIds == null || adminIds.isEmpty()) {
            return true;
        }

        LinkedHashSet<Integer> uniqueAdminIds = new LinkedHashSet<>();
        for (Integer adminId : adminIds) {
            if (adminId != null && adminId > 0) {
                uniqueAdminIds.add(adminId);
            }
        }

        if (uniqueAdminIds.isEmpty()) {
            return true;
        }

        try (PreparedStatement insertPs = conn.prepareStatement(insertSql)) {
            for (Integer adminId : uniqueAdminIds) {
                insertPs.setInt(1, tipoSolicitudId);
                insertPs.setInt(2, adminId);
                insertPs.addBatch();
            }

            insertPs.executeBatch();
        }

        return true;
    }
    public boolean delete(int id) {
        String sql = "DELETE FROM tipo_solicitud WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}