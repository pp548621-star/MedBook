package com.doctorbooking.controller;

import com.doctorbooking.dao.DoctorDao;
import com.doctorbooking.dao.UserDao;
import com.doctorbooking.model.Doctor;
import com.doctorbooking.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/admin")
public class AdminServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("addDoctor".equals(action)) {
            addDoctor(request, response);
        } else if ("updateDoctor".equals(action)) {
            updateDoctor(request, response);
        } else if ("deleteDoctor".equals(action)) {
            deleteDoctor(request, response);
        } else if ("approveDoctor".equals(action)) {
            approveDoctor(request, response);
        } else if ("rejectDoctor".equals(action)) {
            rejectDoctor(request, response);
        }
    }

    private void addDoctor(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        int specializationId = Integer.parseInt(request.getParameter("specializationId"));
        double fees = Double.parseDouble(request.getParameter("fees"));

        User user = new User();
        user.setName(name);
        user.setEmail(email);
        user.setPassword(password); // Plain text
        user.setRole("doctor");
        user.setStatus("APPROVED"); // Directly approved by admin

        UserDao userDao = new UserDao();
        if (userDao.registerUser(user)) {
             User createdUser = userDao.loginUser(email, password, "doctor");
             if (createdUser != null) {
                 Doctor doctor = new Doctor();
                 doctor.setUserId(createdUser.getId());
                 doctor.setSpecializationId(specializationId);
                 doctor.setFees(fees);
                 
                 DoctorDao doctorDao = new DoctorDao();
                 if (doctorDao.addDoctor(doctor)) {
                     request.getSession().setAttribute("succMsg", "Doctor added successfully");
                     response.sendRedirect("admin/doctors.jsp");
                     return;
                 }
             }
        }
        request.getSession().setAttribute("errorMsg", "Failed to add doctor");
        response.sendRedirect("admin/addDoctor.jsp");
    }

    private void approveDoctor(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int userId = Integer.parseInt(request.getParameter("userId"));
        UserDao userDao = new UserDao();
        
        if (userDao.updateUserStatus(userId, "APPROVED")) {
            DoctorDao doctorDao = new DoctorDao();
            if (doctorDao.getDoctorByUserId(userId) == null) {
                Doctor doctor = new Doctor();
                doctor.setUserId(userId);
                doctor.setSpecializationId(1);
                doctor.setFees(0.0);
                doctorDao.addDoctor(doctor);
            }
            request.getSession().setAttribute("succMsg", "Doctor account approved!");
        } else {
            request.getSession().setAttribute("errorMsg", "Failed to approve doctor.");
        }
        response.sendRedirect("admin/dashboard.jsp");
    }

    private void rejectDoctor(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int userId = Integer.parseInt(request.getParameter("userId"));
        UserDao userDao = new UserDao();
        
        if (userDao.updateUserStatus(userId, "REJECTED")) {
            request.getSession().setAttribute("succMsg", "Doctor account rejected.");
        } else {
            request.getSession().setAttribute("errorMsg", "Failed to reject doctor.");
        }
        response.sendRedirect("admin/dashboard.jsp");
    }

    private void updateDoctor(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        int userId = Integer.parseInt(request.getParameter("userId"));
        String name = request.getParameter("name");
        int specializationId = Integer.parseInt(request.getParameter("specializationId"));
        double fees = Double.parseDouble(request.getParameter("fees"));

        Doctor doc = new Doctor();
        doc.setId(id);
        doc.setUserId(userId);
        doc.setSpecializationId(specializationId);
        doc.setFees(fees);

        DoctorDao doctorDao = new DoctorDao();
        UserDao userDao = new UserDao();

        boolean updateDoc = doctorDao.updateDoctor(doc);
        boolean updateUser = userDao.updateUserName(userId, name);

        if (updateDoc && updateUser) {
            request.getSession().setAttribute("succMsg", "Doctor updated successfully");
            response.sendRedirect("admin/doctors.jsp");
        } else {
            request.getSession().setAttribute("errorMsg", "Failed to update doctor");
            response.sendRedirect("admin/doctors.jsp");
        }
    }

    private void deleteDoctor(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int userId = Integer.parseInt(request.getParameter("userId"));
        UserDao userDao = new UserDao();
        if(userDao.deleteUser(userId)) {
            request.getSession().setAttribute("succMsg", "Doctor removed successfully");
        } else {
            request.getSession().setAttribute("errorMsg", "Failed to remove doctor.");
        }
        response.sendRedirect("admin/doctors.jsp");
    }
}
