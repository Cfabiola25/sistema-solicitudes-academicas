package dao;

import model.ProgramaAcademico;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * Data access object for academic program management.
 */
public class ProgramaAcademicoDAO {

    /**
     * Returns all academic programs ordered by name.
     */
    public List<ProgramaAcademico> getAll() {
        List<ProgramaAcademico> list = new ArrayList<>();

        String sql = "SELECT id, codigo, nombre FROM programa_academico ORDER BY nombre";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                ProgramaAcademico programa = new ProgramaAcademico();
                programa.setId(rs.getInt("id"));
                programa.setCodigo(rs.getString("codigo"));
                programa.setNombre(rs.getString("nombre"));

                list.add(programa);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    /**
     * Finds an academic program by ID.
     */
    public ProgramaAcademico getById(int id) {
        String sql = "SELECT id, codigo, nombre FROM programa_academico WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    ProgramaAcademico programa = new ProgramaAcademico();
                    programa.setId(rs.getInt("id"));
                    programa.setCodigo(rs.getString("codigo"));
                    programa.setNombre(rs.getString("nombre"));
                    return programa;
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    /**
     * Checks if the program code already exists.
     */
    public boolean codeExists(String codigo) {
        String sql = "SELECT id FROM programa_academico WHERE codigo = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, codigo);

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    /**
     * Checks if the program name already exists.
     */
    public boolean nameExists(String nombre) {
        String sql = "SELECT id FROM programa_academico WHERE nombre = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, nombre);

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    /**
     * Creates a new academic program.
     */
    public boolean create(ProgramaAcademico programa) {
        String sql = "INSERT INTO programa_academico (codigo, nombre) VALUES (?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, programa.getCodigo());
            ps.setString(2, programa.getNombre());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    /**
     * Updates an existing academic program.
     */
    public boolean update(ProgramaAcademico programa) {
        String sql = "UPDATE programa_academico SET codigo = ?, nombre = ? WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, programa.getCodigo());
            ps.setString(2, programa.getNombre());
            ps.setInt(3, programa.getId());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    /**
     * Deletes an academic program.
     * If students are linked to it, the database foreign key will block deletion.
     */
    public boolean delete(int id) {
        String sql = "DELETE FROM programa_academico WHERE id = ?";

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