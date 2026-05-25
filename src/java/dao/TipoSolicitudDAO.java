package dao;

import model.TipoSolicitud;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

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
                    rs.getString("nombre"),
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
                        rs.getString("nombre"),
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
        String sql = "INSERT INTO tipo_solicitud (nombre, tiempo_respuesta_dias, tipo_tiempo) VALUES (?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, t.getNombre());
            ps.setInt(2, t.getTiempoRespuestaDias());
            ps.setString(3, t.getTipoTiempo());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Updates an existing request type.
     */
    public boolean update(TipoSolicitud t) {
        String sql = "UPDATE tipo_solicitud SET nombre = ?, tiempo_respuesta_dias = ?, tipo_tiempo = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, t.getNombre());
            ps.setInt(2, t.getTiempoRespuestaDias());
            ps.setString(3, t.getTipoTiempo());
            ps.setInt(4, t.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Deletes a request type by its ID.
     */
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