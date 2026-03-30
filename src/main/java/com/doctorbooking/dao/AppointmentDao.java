package com.doctorbooking.dao;

import com.doctorbooking.model.Appointment;
import com.doctorbooking.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class AppointmentDao {

    public boolean addAppointment(Appointment appt) {
        boolean success = false;
        String query = "INSERT INTO appointments (patient_id, doctor_id, appointment_date, appointment_time, status) " +
                       "VALUES (?, ?, ?, ?, 'pending')";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, appt.getPatientId());
            ps.setInt(2, appt.getDoctorId());
            ps.setString(3, appt.getAppointmentDate());
            ps.setString(4, appt.getAppointmentTime());
            
            if (ps.executeUpdate() > 0) success = true;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return success;
    }

    public List<Appointment> getAppointmentsByPatient(int patientId) {
        return getAppointmentsByQuery("WHERE a.patient_id = ?", patientId);
    }

    public List<Appointment> getAppointmentsByDoctor(int doctorId) {
        return getAppointmentsByQuery("WHERE a.doctor_id = ?", doctorId);
    }

    public List<Appointment> getAllAppointments() {
        return getAppointmentsByQuery("", null);
    }

    private List<Appointment> getAppointmentsByQuery(String condition, Integer param) {
        List<Appointment> list = new ArrayList<>();
        String query = "SELECT a.id, a.patient_id, a.doctor_id, a.appointment_date, a.appointment_time, a.status, a.created_at, " +
                       "u.name as patient_name, u2.name as doctor_name, s.name as doc_spec " +
                       "FROM appointments a " +
                       "JOIN users u ON a.patient_id = u.id " +
                       "JOIN doctors d ON a.doctor_id = d.id " +
                       "JOIN users u2 ON d.user_id = u2.id " +
                       "JOIN specializations s ON d.specialization_id = s.id " +
                       condition + " ORDER BY a.appointment_date DESC, a.appointment_time DESC";
                       
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            if (param != null) ps.setInt(1, param);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Appointment a = new Appointment();
                a.setId(rs.getInt("id"));
                a.setPatientId(rs.getInt("patient_id"));
                a.setDoctorId(rs.getInt("doctor_id"));
                a.setAppointmentDate(rs.getString("appointment_date"));
                a.setAppointmentTime(rs.getString("appointment_time"));
                a.setStatus(rs.getString("status"));
                a.setCreatedAt(rs.getString("created_at"));
                a.setPatientName(rs.getString("patient_name"));
                a.setDoctorName(rs.getString("doctor_name"));
                a.setDoctorSpecialization(rs.getString("doc_spec"));
                list.add(a);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean updateStatus(int id, String status) {
        boolean success = false;
        String query = "UPDATE appointments SET status = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, status);
            ps.setInt(2, id);
            if (ps.executeUpdate() > 0) success = true;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return success;
    }

    public int getTotalAppointments() {
        int count = 0;
        String query = "SELECT COUNT(*) FROM appointments";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ResultSet rs = ps.executeQuery();
            if (rs.next()) count = rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return count;
    }
    public int countBySlot(int doctorId, String date, String time) {
        int count = 0;
        String query = "SELECT COUNT(*) FROM appointments WHERE doctor_id = ? AND appointment_date = ? AND appointment_time = ? AND status != 'cancelled' AND status != 'rejected'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, doctorId);
            ps.setString(2, date);
            ps.setString(3, time);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) count = rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return count;
    }
}
