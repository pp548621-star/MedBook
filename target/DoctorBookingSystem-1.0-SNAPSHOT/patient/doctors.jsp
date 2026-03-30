    <%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.doctorbooking.dao.DoctorDao" %>
<%@ page import="com.doctorbooking.model.Doctor" %>
<%@ page import="com.doctorbooking.model.User" %>
<%@ page import="java.util.List" %>
<%
    if(session.getAttribute("userObj") == null || !"patient".equals(((User)session.getAttribute("userObj")).getRole())) {
        response.sendRedirect("../login.jsp");
        return;
    }
    
    String keyword = request.getParameter("keyword");
    String specIdStr = request.getParameter("specialization");
    String expStr = request.getParameter("experience");
    String maxFeesStr = request.getParameter("maxFees");
    
    Integer specId = (specIdStr != null && !specIdStr.isEmpty()) ? Integer.parseInt(specIdStr) : 0;
    Integer minExp = (expStr != null && !expStr.isEmpty()) ? Integer.parseInt(expStr) : 0;
    Double maxFees = (maxFeesStr != null && !maxFeesStr.isEmpty()) ? Double.parseDouble(maxFeesStr) : 0.0;
    
    com.doctorbooking.dao.DoctorDao dao = new com.doctorbooking.dao.DoctorDao();
    List<Doctor> list;
    
    if (keyword != null || specId > 0 || minExp > 0 || maxFees > 0) {
        list = dao.searchDoctors(keyword, specId, minExp, maxFees);
    } else {
        list = dao.getAllDoctors();
    }
    
    com.doctorbooking.dao.SpecializationDao specDao = new com.doctorbooking.dao.SpecializationDao();
    List<com.doctorbooking.model.Specialization> specializations = specDao.getAllSpecializations();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Find Doctors - MedBook</title>
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
            <h1><i class="fa-solid fa-user-doctor" style="color: var(--primary);"></i> Find Doctors</h1>
        </header>
        
        <div class="content-area">
            <div class="filter-section content-card" style="margin-bottom: 24px; padding: 20px;">
                <form action="doctors.jsp" method="get" style="display: flex; gap: 15px; flex-wrap: wrap; align-items: end;">
                    <div style="flex: 1; min-width: 150px;">
                        <label class="form-label" style="font-size: 0.85rem; margin-bottom: 4px;">Search Keyword</label>
                        <input type="text" name="keyword" class="form-control" placeholder="Doctor name..." value="<%= keyword != null ? keyword : "" %>">
                    </div>
                    <div style="flex: 1; min-width: 150px;">
                        <label class="form-label" style="font-size: 0.85rem; margin-bottom: 4px;">Specialization</label>
                        <select name="specialization" class="form-select">
                            <option value="">All Specializations</option>
                            <% for(com.doctorbooking.model.Specialization s : specializations) { %>
                                <option value="<%= s.getId() %>" <%= (specId != null && specId == s.getId()) ? "selected" : "" %>><%= s.getName() %></option>
                            <% } %>
                        </select>
                    </div>
                    <div style="flex: 1; min-width: 120px;">
                        <label class="form-label" style="font-size: 0.85rem; margin-bottom: 4px;">Min Exp (Yrs)</label>
                        <input type="number" name="experience" class="form-control" placeholder="e.g. 5" min="0" value="<%= minExp > 0 ? minExp : "" %>">
                    </div>
                    <div style="flex: 1; min-width: 120px;">
                        <label class="form-label" style="font-size: 0.85rem; margin-bottom: 4px;">Max Fee (₹)</label>
                        <input type="number" name="maxFees" class="form-control" placeholder="e.g. 1000" min="0" value="<%= maxFees > 0 ? maxFees.intValue() : "" %>">
                    </div>
                    <div style="display: flex; gap: 8px;">
                        <button type="submit" class="btn btn-primary"><i class="fa-solid fa-filter"></i> Apply</button>
                        <a href="doctors.jsp" class="btn btn-outline">Clear</a>
                    </div>
                </form>
            </div>

            <div class="doctors-grid" id="doctorList">
                <% for(Doctor d : list) { %>
                <div class="doctor-card doc-card">
                    <div class="doctor-card-header">
                        <div class="doctor-avatar">
                            <% if(d.getPhoto() != null && !d.getPhoto().isEmpty()) { %>
                                <img src="${pageContext.request.contextPath}/uploads/profiles/<%= d.getPhoto() %>" alt="Dr. <%= d.getName() %>">
                            <% } else { %>
                                <img src="https://cdn-icons-png.flaticon.com/512/3774/3774299.png" alt="Dr. <%= d.getName() %>">
                            <% } %>
                        </div>
                        <h4 class="doc-name">Dr. <%= d.getName() %></h4>
                        <p class="doc-spec"><%= d.getSpecializationName() != null ? d.getSpecializationName() : "General" %></p>
                    </div>
                    <div class="doctor-card-body">
                        <div class="doctor-info">
                            <div class="doctor-info-item">
                                <span>Consultation Fee</span>
                                <strong>₹<%= d.getFees() %></strong>
                            </div>
                            <div class="doctor-info-item">
                                <span>Experience</span>
                                <strong><%= d.getExperience() %>+ Years</strong>
                            </div>
                        </div>
                    </div>
                    <div class="doctor-card-footer">
                        <a href="bookAppointment.jsp?docId=<%= d.getId() %>" class="btn btn-primary">
                            <i class="fa-solid fa-calendar-plus"></i> Book Appointment
                        </a>
                    </div>
                </div>
                <% } %>
            </div>
            
            <% if(list.isEmpty()) { %>
            <div class="empty-state">
                <i class="fa-solid fa-user-doctor"></i>
                <h3>No Doctors Available</h3>
                <p>Please check back later for available doctors.</p>
            </div>
            <% } %>
        </div>
    </main>
</div>

</body>
</html>
