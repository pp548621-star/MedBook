package com.doctorbooking.dao;

import com.doctorbooking.model.Availability;
import com.doctorbooking.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class AvailabilityDao {

    public boolean addAvailability(Availability av) {
        boolean success = false;
        String query = "INSERT INTO doctor_availability (doctor_id, day_of_week, start_time, end_time) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, av.getDoctorId());
            ps.setString(2, av.getDayOfWeek());
            ps.setString(3, av.getStartTime());
            ps.setString(4, av.getEndTime());
            if (ps.executeUpdate() > 0) success = true;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return success;
    }

    public List<Availability> getAvailabilityByDoctorId(int doctorId) {
        List<Availability> list = new ArrayList<>();
        String query = "SELECT * FROM doctor_availability WHERE doctor_id = ? ORDER BY FIELD(day_of_week, 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'), start_time";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, doctorId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Availability av = new Availability();
                av.setId(rs.getInt("id"));
                av.setDoctorId(rs.getInt("doctor_id"));
                av.setDayOfWeek(rs.getString("day_of_week"));
                av.setStartTime(rs.getString("start_time"));
                av.setEndTime(rs.getString("end_time"));
                list.add(av);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean deleteAvailability(int id) {
        boolean success = false;
        String query = "DELETE FROM doctor_availability WHERE id = ?";
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
