package com.doctorbooking.controller;

import com.doctorbooking.dao.UserDao;
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

@WebServlet("/auth")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2, // 2MB
    maxFileSize = 1024 * 1024 * 10,      // 10MB
    maxRequestSize = 1024 * 1024 * 50   // 50MB
)
public class AuthServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("login".equals(action)) {
            login(request, response);
        } else if ("register".equals(action)) {
            register(request, response);
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("logout".equals(action)) {
            HttpSession session = request.getSession();
            session.invalidate();
            response.sendRedirect("login.jsp?msg=loggedout");
        }
    }

    private void login(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String role = request.getParameter("role");
        
        UserDao userDao = new UserDao();
        User user = userDao.loginUser(email, password, role);
        
        if (user != null) {
            // Check status for doctors
            if ("doctor".equals(user.getRole())) {
                if ("PENDING".equals(user.getStatus())) {
                    response.sendRedirect("login.jsp?msg=pending");
                    return;
                } else if ("REJECTED".equals(user.getStatus())) {
                    response.sendRedirect("login.jsp?msg=rejected");
                    return;
                }
            }

            HttpSession session = request.getSession();
            session.setAttribute("userObj", user);
            
            if ("admin".equals(user.getRole())) {
                response.sendRedirect("admin/dashboard.jsp?msg=success");
            } else if ("doctor".equals(user.getRole())) {
                response.sendRedirect("doctor/dashboard.jsp?msg=success");
            } else {
                response.sendRedirect("patient/dashboard.jsp?msg=success");
            }
        } else {
            response.sendRedirect("login.jsp?msg=invalid");
        }
    }

    private void register(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String role = request.getParameter("role");

        // Role Tampering Protection
        if (!"patient".equals(role) && !"doctor".equals(role)) {
            response.sendRedirect("register.jsp?msg=invalid_role");
            return;
        }
        
        User user = new User();
        user.setName(name);
        user.setEmail(email);
        user.setPassword(password); // Plain text
        user.setRole(role);
        
        // Handle certificate upload for doctors
        if ("doctor".equals(role)) {
            user.setStatus("PENDING");
            Part part = request.getPart("certificate");
            
            if (part != null && part.getSize() > 0) {
                String fileName = getFileName(part);
                // unique name to avoid overwrite
                String uniqueName = System.currentTimeMillis() + "_" + fileName;
                
                String uploadPath = getServletContext().getRealPath("/") + "uploads" + File.separator + "certificates";
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) uploadDir.mkdirs();
                
                part.write(uploadPath + File.separator + uniqueName);
                user.setCertificate(uniqueName);
            }
        } else {
            user.setStatus("ACTIVE");
        }
        
        UserDao userDao = new UserDao();
        if (userDao.registerUser(user)) {
            if ("doctor".equals(role)) {
                response.sendRedirect("login.jsp?msg=registered_doctor");
            } else {
                response.sendRedirect("login.jsp?msg=registered");
            }
        } else {
            response.sendRedirect("register.jsp?msg=error");
        }
    }

    private String getFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        String[] tokens = contentDisp.split(";");
        for (String token : tokens) {
            if (token.trim().startsWith("filename")) {
                return token.substring(token.indexOf("=") + 2, token.length() - 1);
            }
        }
        return "";
    }
}
