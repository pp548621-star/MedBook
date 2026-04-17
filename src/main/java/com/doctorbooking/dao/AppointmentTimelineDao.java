package com.doctorbooking.dao;

import com.doctorbooking.model.AppointmentTimeline;
import com.doctorbooking.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class AppointmentTimelineDao {

    public boolean addTimelineEntry(int appointmentId, String status, String notes) {
        boolean success = false;
        String query = "INSERT INTO appointment_timeline (appointment_id, status, notes) VALUES (?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, appointmentId);
            ps.setString(2, status);
            ps.setString(3, notes);
            if (ps.executeUpdate() > 0) success = true;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return success;
    }

    public List<AppointmentTimeline> getTimelineByAppointmentId(int appointmentId) {
        List<AppointmentTimeline> list = new ArrayList<>();
        String query = "SELECT * FROM appointment_timeline WHERE appointment_id = ? ORDER BY created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, appointmentId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                AppointmentTimeline at = new AppointmentTimeline();
                at.setId(rs.getInt("id"));
                at.setAppointmentId(rs.getInt("appointment_id"));
                at.setStatus(rs.getString("status"));
                at.setNotes(rs.getString("notes"));
                at.setCreatedAt(rs.getString("created_at"));
                list.add(at);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}
