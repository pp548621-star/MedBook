package com.doctorbooking.controller;

import com.doctorbooking.dao.SpecializationDao;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/specialization")
public class SpecializationServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("add".equals(action)) {
            String name = request.getParameter("name");
            SpecializationDao dao = new SpecializationDao();
            if (dao.addSpecialization(name)) {
                request.getSession().setAttribute("succMsg", "Specialization added successfully");
            } else {
                request.getSession().setAttribute("errorMsg", "Failed to add specialization");
            }
            response.sendRedirect("admin/specializations.jsp");
        } else if ("update".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            String name = request.getParameter("name");
            SpecializationDao dao = new SpecializationDao();
            com.doctorbooking.model.Specialization spec = new com.doctorbooking.model.Specialization(id, name);
            if (dao.updateSpecialization(spec)) {
                request.getSession().setAttribute("succMsg", "Specialization updated successfully");
            } else {
                request.getSession().setAttribute("errorMsg", "Failed to update specialization");
            }
            response.sendRedirect("admin/specializations.jsp");
        } else if ("delete".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            SpecializationDao dao = new SpecializationDao();
            if (dao.deleteSpecialization(id)) {
                request.getSession().setAttribute("succMsg", "Specialization deleted successfully");
            } else {
                request.getSession().setAttribute("errorMsg", "Cannot delete specialization: It may have doctors assigned to it.");
            }
            response.sendRedirect("admin/specializations.jsp");
        }
    }
}
