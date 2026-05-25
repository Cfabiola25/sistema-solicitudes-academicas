package dao;

import model.SolicitudMensaje;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class SolicitudMensajeDAO {

    public List<SolicitudMensaje> getBySolicitudId(int solicitudId) {
        List<SolicitudMensaje> list = new ArrayList<>();

        String sql = "SELECT id, solicitud_id, autor_rol, autor_nombre, mensaje, archivo, fecha_envio " +
                     "FROM solicitud_mensaje " +
                     "WHERE solicitud_id = ? " +
                     "ORDER BY fecha_envio ASC, id ASC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, solicitudId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    SolicitudMensaje mensaje = new SolicitudMensaje();

                    mensaje.setId(rs.getInt("id"));
                    mensaje.setSolicitudId(rs.getInt("solicitud_id"));
                    mensaje.setAutorRol(rs.getString("autor_rol"));
                    mensaje.setAutorNombre(rs.getString("autor_nombre"));
                    mensaje.setMensaje(rs.getString("mensaje"));
                    mensaje.setArchivo(rs.getString("archivo"));

                    Timestamp ts = rs.getTimestamp("fecha_envio");
                    mensaje.setFechaEnvio(ts != null ? ts.toLocalDateTime() : null);

                    list.add(mensaje);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    public boolean addMessage(int solicitudId, String autorRol, String autorNombre, String mensaje) {
        return addMessage(solicitudId, autorRol, autorNombre, mensaje, null);
    }

    public boolean addMessage(int solicitudId, String autorRol, String autorNombre, String mensaje, String archivo) {
        String sql = "INSERT INTO solicitud_mensaje " +
                     "(solicitud_id, autor_rol, autor_nombre, mensaje, archivo) " +
                     "VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, solicitudId);
            ps.setString(2, autorRol);
            ps.setString(3, autorNombre);
            ps.setString(4, mensaje);
            ps.setString(5, archivo);

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }
}