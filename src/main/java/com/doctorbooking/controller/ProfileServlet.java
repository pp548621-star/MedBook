package com.doctorbooking.controller;

import com.doctorbooking.dao.DoctorDao;
import com.doctorbooking.dao.UserDao;
import com.doctorbooking.model.Doctor;
import com.doctorbooking.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;
import java.io.File;
import java.io.IOException;

@WebServlet("/profile")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 1, // 1MB
    maxFileSize = 1024 * 1024 * 10,      // 10MB
    maxRequestSize = 1024 * 1024 * 50   // 50MB
)
public class ProfileServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("updatePatient".equals(action)) {
            updatePatientProfile(request, response);
        } else if ("updateDoctor".equals(action)) {
            updateDoctorProfile(request, response);
        }
    }

    private void updatePatientProfile(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        int userId = Integer.parseInt(request.getParameter("userId"));
        String name = request.getParameter("name");
        
        UserDao userDao = new UserDao();
        boolean nameUpdate = userDao.updateUserName(userId, name);
        
        // Handle photo upload
        Part part = request.getPart("photo");
        String photoName = null;
        if (part != null && part.getSize() > 0) {
            photoName = savePhoto(request, part);
            userDao.updateUserPhoto(userId, photoName);
        }

        if (nameUpdate) {
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("userObj");
            user.setName(name);
            if (photoName != null) user.setPhoto(photoName);
            session.setAttribute("userObj", user);
            
            response.sendRedirect("patient/profile.jsp?msg=profile_updated");
        } else {
            response.sendRedirect("patient/profile.jsp?msg=error");
        }
    }

    private void updateDoctorProfile(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        int userId = Integer.parseInt(request.getParameter("userId"));
        String name = request.getParameter("name");
        int specializationId = Integer.parseInt(request.getParameter("specializationId"));
        double fees = Double.parseDouble(request.getParameter("fees"));
        int experience = Integer.parseInt(request.getParameter("experience"));
        
        UserDao userDao = new UserDao();
        DoctorDao doctorDao = new DoctorDao();
        
        boolean userUpdate = userDao.updateUserName(userId, name);
        
        // Handle photo upload
        Part part = request.getPart("photo");
        String photoName = null;
        if (part != null && part.getSize() > 0) {
            photoName = savePhoto(request, part);
            userDao.updateUserPhoto(userId, photoName);
        }

        Doctor doc = new Doctor();
        doc.setUserId(userId);
        doc.setSpecializationId(specializationId);
        doc.setFees(fees);
        doc.setExperience(experience);
        
        boolean doctorUpdate = false;
        if (doctorDao.getDoctorByUserId(userId) == null) {
            doctorUpdate = doctorDao.addDoctor(doc);
        } else {
            doctorUpdate = doctorDao.updateDoctorByUserId(doc);
        }
        
        if (userUpdate && doctorUpdate) {
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("userObj");
            user.setName(name);
            if (photoName != null) user.setPhoto(photoName);
            session.setAttribute("userObj", user);
            
            response.sendRedirect("doctor/profile.jsp?msg=profile_updated");
        } else {
            response.sendRedirect("doctor/profile.jsp?msg=error");
        }
    }

    private String savePhoto(HttpServletRequest request, Part part) throws IOException {
        String fileName = getFileName(part);
        String uniqueName = System.currentTimeMillis() + "_" + fileName;
        String uploadPath = getServletContext().getRealPath("/") + "uploads" + File.separator + "profiles";
        
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) uploadDir.mkdirs();
        
        part.write(uploadPath + File.separator + uniqueName);
        return uniqueName;
    }

    private String getFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        String[] tokens = contentDisp.split(";");
        for (String token : tokens) {
            if (token.trim().startsWith("filename")) {
                return token.substring(token.indexOf("=") + 2, token.length() - 1);
            }
        }
        return "default.png";
    }
}
