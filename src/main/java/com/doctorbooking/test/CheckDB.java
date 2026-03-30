package com.doctorbooking.test;

import com.doctorbooking.util.DBConnection;
import com.doctorbooking.util.PasswordUtil;
import java.sql.*;

public class CheckDB {
    public static void main(String[] args) {
        System.out.println("Checking database state...");
        try (Connection conn = DBConnection.getConnection()) {
            if (conn == null) {
                System.out.println("FAILED: Could not connect to database. Check your credentials in DBConnection.java");
                return;
            }
            System.out.println("SUCCESS: Connected to database.");
            
            String query = "SELECT name, email, role, status, password FROM users WHERE email = 'admin@admin.com'";
            try (PreparedStatement ps = conn.prepareStatement(query)) {
                ResultSet rs = ps.executeQuery();
                if (rs.next()) {
                    System.out.println("Admin found:");
                    System.out.println(" - Name: " + rs.getString("name"));
                    System.out.println(" - Role: " + rs.getString("role"));
                    System.out.println(" - Status: " + rs.getString("status"));
                    
                    String hashedInput = PasswordUtil.hashPassword("admin123");
                    String dbPass = rs.getString("password");
                    
                    if (hashedInput.equals(dbPass)) {
                        System.out.println(" - Password Match: YES (Hashed)");
                    } else if ("admin123".equals(dbPass)) {
                        System.out.println(" - Password Match: NO (DB has plain text 'admin123', should be hashed)");
                    } else {
                        System.out.println(" - Password Match: NO (Unknown mismatch)");
                    }
                } else {
                    System.out.println("FAILED: Admin user not found with email 'admin@admin.com'");
                }
            } catch (SQLException e) {
                if (e.getMessage().contains("Unknown column 'status'")) {
                    System.out.println("FAILED: Missing schema update. Column 'status' does not exist in 'users' table.");
                } else {
                    System.out.println("Error: " + e.getMessage());
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
