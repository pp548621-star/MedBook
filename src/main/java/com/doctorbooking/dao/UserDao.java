package com.doctorbooking.dao;

import com.doctorbooking.model.User;
import com.doctorbooking.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class UserDao {

    public boolean registerUser(User user) {
        boolean success = false;
        String query = "INSERT INTO users (name, email, password, role, status, certificate) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, user.getName());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPassword());
            ps.setString(4, user.getRole());
            ps.setString(5, user.getStatus());
            ps.setString(6, user.getCertificate());
            
            if (ps.executeUpdate() > 0) {
                success = true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return success;
    }

    public User loginUser(String email, String password, String role) {
        User user = null;
        String query = "SELECT * FROM users WHERE email = ? AND password = ? AND role = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, email);
            ps.setString(2, password);
            ps.setString(3, role);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                user = new User(rs.getInt("id"), rs.getString("name"),
                                rs.getString("email"), rs.getString("password"),
                                rs.getString("role"), rs.getString("status"),
                                rs.getString("certificate"));
                user.setPhoto(rs.getString("photo"));
                user.setCreatedAt(rs.getString("created_at"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return user;
    }

    public List<User> getPendingDoctors() {
        List<User> list = new ArrayList<>();
        String query = "SELECT * FROM users WHERE role = 'doctor' AND status = 'PENDING'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                User user = new User(rs.getInt("id"), rs.getString("name"),
                                     rs.getString("email"), "", rs.getString("role"), rs.getString("status"),
                                     rs.getString("certificate"));
                user.setPhoto(rs.getString("photo"));
                user.setCreatedAt(rs.getString("created_at"));
                list.add(user);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean updateUserStatus(int userId, String status) {
        boolean success = false;
        String query = "UPDATE users SET status = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, status);
            ps.setInt(2, userId);
            if (ps.executeUpdate() > 0) success = true;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return success;
    }

    public List<User> getAllPatients() {
        List<User> patients = new ArrayList<>();
        String query = "SELECT * FROM users WHERE role = 'patient'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                User user = new User(rs.getInt("id"), rs.getString("name"),
                                     rs.getString("email"), "", rs.getString("role"), rs.getString("status"),
                                     rs.getString("certificate"));
                user.setPhoto(rs.getString("photo"));
                user.setCreatedAt(rs.getString("created_at"));
                patients.add(user);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return patients;
    }
    
    public int getTotalPatients() {
        int count = 0;
        String query = "SELECT COUNT(*) FROM users WHERE role = 'patient'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ResultSet rs = ps.executeQuery();
            if (rs.next()) count = rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return count;
    }

    public boolean updateUserName(int userId, String name) {
        boolean success = false;
        String query = "UPDATE users SET name = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, name);
            ps.setInt(2, userId);
            if (ps.executeUpdate() > 0) success = true;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return success;
    }

    public boolean updateUserPhoto(int userId, String photo) {
        boolean success = false;
        String query = "UPDATE users SET photo = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, photo);
            ps.setInt(2, userId);
            if (ps.executeUpdate() > 0) success = true;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return success;
    }

    public boolean deleteUser(int id) {
        boolean success = false;
        String query = "DELETE FROM users WHERE id = ?";
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
