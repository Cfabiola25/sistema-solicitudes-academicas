package dao;

import model.Jornada;
import model.ProgramaAcademico;
import model.Sede;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO to retrieve lookup values for academic programs, campuses, and shifts.
 */
public class LookupDAO {

    public List<Sede> getAllSedes() {
        List<Sede> list = new ArrayList<>();
        String sql = "SELECT id, nombre FROM sede ORDER BY nombre";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(new Sede(rs.getInt("id"), rs.getString("nombre")));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Jornada> getAllJornadas() {
        List<Jornada> list = new ArrayList<>();
        String sql = "SELECT id, nombre FROM jornada ORDER BY nombre";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(new Jornada(rs.getInt("id"), rs.getString("nombre")));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<ProgramaAcademico> getAllProgramas() {
        List<ProgramaAcademico> list = new ArrayList<>();
        String sql = "SELECT id, codigo, nombre FROM programa_academico ORDER BY nombre";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(new ProgramaAcademico(rs.getInt("id"), rs.getString("codigo"), rs.getString("nombre")));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}
