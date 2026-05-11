package dao;

import model.TipoSolicitud;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO for CRUD operations on the TipoSolicitud table. At this
 * stage only a read operation is required to populate the
 * dropdown on the new request form.
 */
public class TipoSolicitudDAO {

    /**
     * Returns all available request types ordered by their name.
     */
    public List<TipoSolicitud> getAll() {
        List<TipoSolicitud> list = new ArrayList<>();
        String sql = "SELECT id, nombre FROM tipo_solicitud ORDER BY nombre";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(new TipoSolicitud(rs.getInt("id"), rs.getString("nombre")));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}