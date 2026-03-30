package com.doctorbooking.controller;

import com.doctorbooking.dao.AvailabilityDao;
import com.doctorbooking.dao.DoctorDao;
import com.doctorbooking.model.Availability;
import com.doctorbooking.model.Doctor;
import com.doctorbooking.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/doctor/availability")
public class AvailabilityServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("add".equals(action)) {
            addAvailability(request, response);
        } else if ("delete".equals(action)) {
            deleteAvailability(request, response);
        }
    }

    private void addAvailability(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession();
        User u = (User) session.getAttribute("userObj");
        
        if (u == null || !"doctor".equals(u.getRole())) {
            response.sendRedirect("../login.jsp");
            return;
        }

        String day = request.getParameter("dayOfWeek");
        String startTime = request.getParameter("startTime");
        String endTime = request.getParameter("endTime");

        DoctorDao doctorDao = new DoctorDao();
        Doctor doc = doctorDao.getDoctorByUserId(u.getId());

        if (doc != null) {
            Availability av = new Availability();
            av.setDoctorId(doc.getId());
            av.setDayOfWeek(day);
            av.setStartTime(startTime);
            av.setEndTime(endTime);

            AvailabilityDao avDao = new AvailabilityDao();
            if (avDao.addAvailability(av)) {
                response.sendRedirect("availability.jsp?msg=added");
            } else {
                response.sendRedirect("availability.jsp?msg=error");
            }
        }
    }

    private void deleteAvailability(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        AvailabilityDao avDao = new AvailabilityDao();
        if (avDao.deleteAvailability(id)) {
            response.sendRedirect("availability.jsp?msg=deleted");
        } else {
            response.sendRedirect("availability.jsp?msg=error");
        }
    }
}
