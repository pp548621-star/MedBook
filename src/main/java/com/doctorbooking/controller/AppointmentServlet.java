package com.doctorbooking.controller;

import com.doctorbooking.dao.AppointmentDao;
import com.doctorbooking.model.Appointment;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/appointment")
public class AppointmentServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("book".equals(action)) {
            bookAppointment(request, response);
        } else if ("updateStatus".equals(action)) {
            updateStatus(request, response);
        }
    }

    private void bookAppointment(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int patientId = Integer.parseInt(request.getParameter("patientId"));
        int doctorId = Integer.parseInt(request.getParameter("doctorId"));
        String date = request.getParameter("appointmentDate");
        String time = request.getParameter("appointmentTime");

        Appointment appt = new Appointment();
        appt.setPatientId(patientId);
        appt.setDoctorId(doctorId);
        appt.setAppointmentDate(date);
        appt.setAppointmentTime(time);

        AppointmentDao dao = new AppointmentDao();
        if (dao.addAppointment(appt)) {
            request.getSession().setAttribute("succMsg", "Appointment booked successfully");
            response.sendRedirect("patient/appointments.jsp");
        } else {
            request.getSession().setAttribute("errorMsg", "Failed to book appointment");
            response.sendRedirect("patient/bookAppointment.jsp?docId=" + doctorId);
        }
    }

    private void updateStatus(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        String status = request.getParameter("status");
        String role = request.getParameter("role");

        AppointmentDao dao = new AppointmentDao();
        boolean result = dao.updateStatus(id, status);
        
        if (result) {
            request.getSession().setAttribute("succMsg", "Status updated successfully");
        } else {
            request.getSession().setAttribute("errorMsg", "Failed to update status");
        }
        
        if ("admin".equals(role)) {
            response.sendRedirect("admin/appointments.jsp");
        } else if ("doctor".equals(role)) {
            response.sendRedirect("doctor/appointments.jsp");
        } else {
            response.sendRedirect("patient/appointments.jsp");
        }
    }
}
