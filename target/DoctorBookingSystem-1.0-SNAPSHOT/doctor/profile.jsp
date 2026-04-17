<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.doctorbooking.dao.DoctorDao" %>
<%@ page import="com.doctorbooking.dao.SpecializationDao" %>
<%@ page import="com.doctorbooking.model.Doctor" %>
<%@ page import="com.doctorbooking.model.User" %>
<%@ page import="com.doctorbooking.model.Specialization" %>
<%@ page import="java.util.List" %>

<%
    User u = (User) session.getAttribute("userObj");
    if (u == null || !"doctor".equals(u.getRole())) {
        response.sendRedirect("../login.jsp");
        return;
    }

    DoctorDao docDao = new DoctorDao();
    Doctor doc = docDao.getDoctorByUserId(u.getId());
    
    // Safety check for new doctors
    if (doc == null) {
        doc = new Doctor();
        doc.setUserId(u.getId());
        doc.setName(u.getName());
        doc.setEmail(u.getEmail());
    }

    SpecializationDao specDao = new SpecializationDao();
    List<Specialization> specializations = specDao.getAllSpecializations();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Profile - MedBook</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>

<div class="dashboard">
    <jsp:include page="sidebar.jsp" />
    
    <main class="main-content">
        <header class="main-header">
            <h1><i class="fa-solid fa-user-doctor" style="color: var(--primary);"></i> Settings & Profile</h1>
            <div class="header-actions">
                <span class="user-badge"><i class="fa-solid fa-check-circle"></i> Dr. <%= u.getName() %></span>
            </div>
        </header>
        
        <div class="content-area">
            <% String msg = request.getParameter("msg"); %>
            <% if ("profile_updated".equals(msg)) { %>
                <div class="alert alert-success" style="margin-bottom: 24px; border-left: 5px solid #28a745;">
                    <i class="fa-solid fa-circle-check"></i>
                    Profile updated successfully! All changes are now reflected.
                </div>
            <% } else if ("error".equals(msg)) { %>
                <div class="alert alert-danger" style="margin-bottom: 24px; border-left: 5px solid #dc3545;">
                    <i class="fa-solid fa-circle-exclamation"></i>
                    Error updating profile. Please ensure all fields are filled correctly!
                </div>
            <% } %>

            <div class="content-card">
                <div class="content-card-header">
                    <h3>Personal & Professional Details</h3>
                </div>
                <div class="content-card-body">
                    <form action="${pageContext.request.contextPath}/profile" method="post" style="max-width: 600px;">
                        <input type="hidden" name="action" value="updateDoctor">
                        <input type="hidden" name="userId" value="<%= u.getId() %>">
                        


                        <div class="form-group">
                            <label class="form-label">Full Name</label>
                            <input type="text" name="name" class="form-control" value="<%= u.getName() %>" required>
                        </div>
                        
                        <div class="form-group">
                            <label class="form-label">Email (Read-only)</label>
                            <input type="email" class="form-control" value="<%= u.getEmail() %>" readonly style="background-color: var(--bg-light); cursor: not-allowed;">
                        </div>

                        <div class="form-group">
                            <label class="form-label">Specialization</label>
                            <select name="specializationId" class="form-control" required>
                                <% for(Specialization s : specializations) { %>
                                    <option value="<%= s.getId() %>" <%= doc.getSpecializationId() == s.getId() ? "selected" : "" %>><%= s.getName() %></option>
                                <% } %>
                            </select>
                        </div>

                        <div class="form-group">
                            <label class="form-label">Consultation Fees (₹)</label>
                            <input type="number" name="fees" class="form-control" value="<%= doc.getFees() %>" step="0.01" required>
                        </div>

                        <div class="form-group">
                            <label class="form-label">Years of Experience</label>
                            <input type="number" name="experience" class="form-control" value="<%= doc.getExperience() %>" required>
                        </div>
                        
                        <button type="submit" class="btn btn-primary" style="margin-top: 16px;">
                            <i class="fa-solid fa-save"></i> Save Profile Changes
                        </button>
                    </form>
                </div>
            </div>
        </div>
    </main>
</div>

</body>
</html>
