package com.doctorbooking.dao;

import com.doctorbooking.model.Doctor;
import com.doctorbooking.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class DoctorDao {

    public boolean addDoctor(Doctor doctor) {
        boolean success = false;
        String query = "INSERT INTO doctors (user_id, specialization_id, fees, experience) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, doctor.getUserId());
            ps.setInt(2, doctor.getSpecializationId());
            ps.setDouble(3, doctor.getFees());
            ps.setInt(4, doctor.getExperience());
            
            if (ps.executeUpdate() > 0) success = true;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return success;
    }

    public List<Doctor> getAllDoctors() {
        List<Doctor> doctors = new ArrayList<>();
        String query = "SELECT d.id, d.user_id, d.specialization_id, d.fees, d.experience, u.name, u.email, u.photo, s.name as spec_name " +
                       "FROM doctors d " +
                       "JOIN users u ON d.user_id = u.id " +
                       "LEFT JOIN specializations s ON d.specialization_id = s.id";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Doctor doc = new Doctor();
                doc.setId(rs.getInt("id"));
                doc.setUserId(rs.getInt("user_id"));
                doc.setSpecializationId(rs.getInt("specialization_id"));
                doc.setFees(rs.getDouble("fees"));
                doc.setExperience(rs.getInt("experience"));
                doc.setName(rs.getString("name"));
                doc.setEmail(rs.getString("email"));
                doc.setPhoto(rs.getString("photo"));
                doc.setSpecializationName(rs.getString("spec_name"));
                doctors.add(doc);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return doctors;
    }

    public Doctor getDoctorByUserId(int userId) {
        Doctor doc = null;
        String query = "SELECT d.id, d.user_id, d.specialization_id, d.fees, d.experience, u.name, u.email, s.name as spec_name " +
                       "FROM doctors d " +
                       "JOIN users u ON d.user_id = u.id " +
                       "LEFT JOIN specializations s ON d.specialization_id = s.id " +
                       "WHERE d.user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                doc = new Doctor();
                doc.setId(rs.getInt("id"));
                doc.setUserId(rs.getInt("user_id"));
                doc.setSpecializationId(rs.getInt("specialization_id"));
                doc.setFees(rs.getDouble("fees"));
                doc.setExperience(rs.getInt("experience"));
                doc.setName(rs.getString("name"));
                doc.setEmail(rs.getString("email"));
                doc.setSpecializationName(rs.getString("spec_name"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return doc;
    }
    
    public Doctor getDoctorById(int id) {
        Doctor doc = null;
        String query = "SELECT d.id, d.user_id, d.specialization_id, d.fees, d.experience, u.name, u.email, u.photo, s.name as spec_name " +
                       "FROM doctors d " +
                       "JOIN users u ON d.user_id = u.id " +
                       "LEFT JOIN specializations s ON d.specialization_id = s.id " +
                       "WHERE d.id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                doc = new Doctor();
                doc.setId(rs.getInt("id"));
                doc.setUserId(rs.getInt("user_id"));
                doc.setSpecializationId(rs.getInt("specialization_id"));
                doc.setFees(rs.getDouble("fees"));
                doc.setExperience(rs.getInt("experience"));
                doc.setName(rs.getString("name"));
                doc.setEmail(rs.getString("email"));
                doc.setPhoto(rs.getString("photo"));
                doc.setSpecializationName(rs.getString("spec_name"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return doc;
    }

    public int getTotalDoctors() {
        int count = 0;
        String query = "SELECT COUNT(*) FROM doctors";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ResultSet rs = ps.executeQuery();
            if (rs.next()) count = rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return count;
    }

    public boolean updateDoctor(Doctor doctor) {
        boolean success = false;
        String query = "UPDATE doctors SET specialization_id = ?, fees = ?, experience = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, doctor.getSpecializationId());
            ps.setDouble(2, doctor.getFees());
            ps.setInt(3, doctor.getExperience());
            ps.setInt(4, doctor.getId());
            if (ps.executeUpdate() > 0) success = true;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return success;
    }

    public boolean updateDoctorByUserId(Doctor doctor) {
        boolean success = false;
        String query = "UPDATE doctors SET specialization_id = ?, fees = ?, experience = ? WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, doctor.getSpecializationId());
            ps.setDouble(2, doctor.getFees());
            ps.setInt(3, doctor.getExperience());
            ps.setInt(4, doctor.getUserId());
            if (ps.executeUpdate() > 0) success = true;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return success;
    }

    public List<Doctor> searchDoctors(String keyword, Integer specId, Integer minExp, Double maxFees) {
        List<Doctor> list = new ArrayList<>();
        StringBuilder query = new StringBuilder("SELECT d.id, d.user_id, d.specialization_id, d.fees, d.experience, u.name, u.email, u.photo, s.name as spec_name ")
                .append("FROM doctors d ")
                .append("JOIN users u ON d.user_id = u.id ")
                .append("LEFT JOIN specializations s ON d.specialization_id = s.id ")
                .append("WHERE 1=1 ");

        if (keyword != null && !keyword.trim().isEmpty()) {
            query.append("AND (u.name LIKE ? OR s.name LIKE ?) ");
        }
        if (specId != null && specId > 0) {
            query.append("AND d.specialization_id = ? ");
        }
        if (minExp != null && minExp > 0) {
            query.append("AND d.experience >= ? ");
        }
        if (maxFees != null && maxFees > 0) {
            query.append("AND d.fees <= ? ");
        }

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query.toString())) {
            
            int paramIndex = 1;
            if (keyword != null && !keyword.trim().isEmpty()) {
                String k = "%" + keyword + "%";
                ps.setString(paramIndex++, k);
                ps.setString(paramIndex++, k);
            }
            if (specId != null && specId > 0) {
                ps.setInt(paramIndex++, specId);
            }
            if (minExp != null && minExp > 0) {
                ps.setInt(paramIndex++, minExp);
            }
            if (maxFees != null && maxFees > 0) {
                ps.setDouble(paramIndex++, maxFees);
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Doctor d = new Doctor();
                d.setId(rs.getInt("id"));
                d.setUserId(rs.getInt("user_id"));
                d.setSpecializationId(rs.getInt("specialization_id"));
                d.setFees(rs.getDouble("fees"));
                d.setExperience(rs.getInt("experience"));
                d.setName(rs.getString("name"));
                d.setEmail(rs.getString("email"));
                d.setPhoto(rs.getString("photo"));
                d.setSpecializationName(rs.getString("spec_name"));
                list.add(d);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}
