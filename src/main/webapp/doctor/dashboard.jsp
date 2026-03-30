<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.doctorbooking.dao.AppointmentDao" %>
<%@ page import="com.doctorbooking.dao.DoctorDao" %>
<%@ page import="com.doctorbooking.model.User" %>
<%@ page import="com.doctorbooking.model.Doctor" %>
<%@ page import="java.util.List" %>
<%@ page import="com.doctorbooking.model.Appointment" %>
<%
    if(session.getAttribute("userObj") == null || !"doctor".equals(((User)session.getAttribute("userObj")).getRole())) {
        response.sendRedirect("../login.jsp");
        return;
    }
    User u = (User) session.getAttribute("userObj");
    DoctorDao docDao = new DoctorDao();
    Doctor doc = docDao.getDoctorByUserId(u.getId());
    
    // In case user registers as doctor but doctor details aren't in doctor table yet
    if (doc == null) {
        doc = new Doctor();
        doc.setId(0); // Mock ID
    }

    AppointmentDao dao = new AppointmentDao();
    List<Appointment> list = dao.getAppointmentsByDoctor(doc.getId());
    int total = list.size();
    long pending = list.stream().filter(a -> a.getStatus().equals("pending")).count();
    long confirmed = list.stream().filter(a -> a.getStatus().equals("confirmed")).count();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Doctor Dashboard - MedBook</title>
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
            <h1><i class="fa-solid fa-chart-line" style="color: var(--primary);"></i> Dashboard</h1>
            <div class="header-actions">
                <span style="color: var(--text-muted);"><i class="fa-regular fa-calendar"></i> <%= new java.text.SimpleDateFormat("MMM dd, yyyy").format(new java.util.Date()) %></span>
            </div>
        </header>
        
        <div class="content-area">
            <% if("success".equals(request.getParameter("msg"))) { %>
                <div class="alert alert-success">
                    <i class="fa-solid fa-circle-check"></i>
                    Login successful! Welcome to your dashboard.
                </div>
            <% } %>

            <% if(doc.getFees() <= 0 || doc.getSpecializationId() <= 0) { %>
                <div class="alert alert-warning">
                    <i class="fa-solid fa-triangle-exclamation"></i>
                    <div>
                        <strong>Action Required: Complete Your Profile</strong><br>
                        Please <a href="profile.jsp" style="color: inherit; text-decoration: underline;">set your charges, specialization, and experience</a> so patients can book appointments with you.
                    </div>
                </div>
            <% } %>
            <!-- Stats Grid -->
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-icon primary">
                        <i class="fa-solid fa-calendar-check"></i>
                    </div>
                    <div class="stat-content">
                        <h3><%= total %></h3>
                        <p>Total Appointments</p>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon warning">
                        <i class="fa-solid fa-clock"></i>
                    </div>
                    <div class="stat-content">
                        <h3><%= pending %></h3>
                        <p>Pending Requests</p>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon success">
                        <i class="fa-solid fa-check-circle"></i>
                    </div>
                    <div class="stat-content">
                        <h3><%= confirmed %></h3>
                        <p>Confirmed</p>
                    </div>
                </div>
            </div>
            
            <!-- Pending Requests -->
            <div class="content-card">
                <div class="content-card-header">
                    <h3><i class="fa-solid fa-clock" style="color: var(--warning);"></i> Pending Appointment Requests</h3>
                </div>
                <div class="content-card-body">
                    <div class="table-container">
                        <table class="table">
                            <thead>
                                <tr>
                                    <th>Patient Name</th>
                                    <th>Date & Time</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% boolean hasPending = false; %>
                                <% for(Appointment a : list) { %>
                                <% if("pending".equals(a.getStatus())) { %>
                                <% hasPending = true; %>
                                <tr>
                                    <td><strong><%= a.getPatientName() %></strong></td>
                                    <td>
                                        <div><i class="fa-regular fa-calendar" style="color: var(--primary);"></i> <%= a.getAppointmentDate() %></div>
                                        <div style="font-size: 0.875rem; color: var(--text-muted); margin-top: 4px;">
                                            <i class="fa-regular fa-clock"></i> <%= a.getAppointmentTime() %>
                                        </div>
                                    </td>
                                    <td>
                                        <div style="display: flex; gap: 8px;">
                                            <form action="../appointment" method="post">
                                                <input type="hidden" name="action" value="updateStatus">
                                                <input type="hidden" name="id" value="<%= a.getId() %>">
                                                <input type="hidden" name="status" value="confirmed">
                                                <input type="hidden" name="role" value="doctor">
                                                <button type="submit" class="btn btn-success btn-sm">
                                                    <i class="fa-solid fa-check"></i> Accept
                                                </button>
                                            </form>
                                            <form action="../appointment" method="post">
                                                <input type="hidden" name="action" value="updateStatus">
                                                <input type="hidden" name="id" value="<%= a.getId() %>">
                                                <input type="hidden" name="status" value="rejected">
                                                <input type="hidden" name="role" value="doctor">
                                                <button type="submit" class="btn btn-outline btn-sm" style="border-color: var(--danger); color: var(--danger);">
                                                    <i class="fa-solid fa-xmark"></i> Reject
                                                </button>
                                            </form>
                                        </div>
                                    </td>
                                </tr>
                                <% } %>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                    
                    <% if(!hasPending) { %>
                    <div class="empty-state">
                        <i class="fa-solid fa-check-circle" style="color: var(--success);"></i>
                        <h3>All Caught Up!</h3>
                        <p>You have no pending appointment requests.</p>
                    </div>
                    <% } %>
                </div>
            </div>
        </div>
    </main>
</div>

</body>
</html>