package com.doctorbooking.dao;

import com.doctorbooking.model.Specialization;
import com.doctorbooking.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class SpecializationDao {

    public List<Specialization> getAllSpecializations() {
        List<Specialization> list = new ArrayList<>();
        String query = "SELECT s.id, s.name, (SELECT COUNT(*) FROM doctors WHERE specialization_id = s.id) as doctor_count " +
                       "FROM specializations s ORDER BY s.name";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new Specialization(rs.getInt("id"), rs.getString("name"), rs.getInt("doctor_count")));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean addSpecialization(String name) {
        boolean success = false;
        String query = "INSERT INTO specializations (name) VALUES (?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, name);
            if (ps.executeUpdate() > 0) success = true;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return success;
    }

    public Specialization getSpecializationById(int id) {
        Specialization spec = null;
        String query = "SELECT * FROM specializations WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                spec = new Specialization(rs.getInt("id"), rs.getString("name"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return spec;
    }

    public boolean updateSpecialization(Specialization spec) {
        boolean success = false;
        String query = "UPDATE specializations SET name = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, spec.getName());
            ps.setInt(2, spec.getId());
            if (ps.executeUpdate() > 0) success = true;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return success;
    }

    public boolean deleteSpecialization(int id) {
        boolean success = false;
        String query = "DELETE FROM specializations WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, id);
            if (ps.executeUpdate() > 0) success = true;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return success;
    }
}
