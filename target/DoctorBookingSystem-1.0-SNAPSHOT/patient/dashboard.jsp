<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.doctorbooking.dao.AppointmentDao" %>
<%@ page import="com.doctorbooking.model.User" %>
<%
    if(session.getAttribute("userObj") == null || !"patient".equals(((User)session.getAttribute("userObj")).getRole())) {
        response.sendRedirect("../login.jsp");
        return;
    }
    User u = (User) session.getAttribute("userObj");
    AppointmentDao dao = new AppointmentDao();
    int totalCount = dao.getAppointmentsByPatient(u.getId()).size();
    long pendingCount = dao.getAppointmentsByPatient(u.getId()).stream().filter(a -> a.getStatus().equals("pending")).count();
    long confirmedCount = dao.getAppointmentsByPatient(u.getId()).stream().filter(a -> a.getStatus().equals("confirmed")).count();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Patient Dashboard - MedBook</title>
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
            <h1>Dashboard</h1>
            <div class="header-actions">
                <a href="doctors.jsp" class="btn btn-primary">
                    <i class="fa-solid fa-plus"></i> Book Appointment
                </a>
            </div>
        </header>
        
        <div class="content-area">
            <% if("success".equals(request.getParameter("msg"))) { %>
                <div class="alert alert-success">
                    <i class="fa-solid fa-circle-check"></i>
                    Login successful! Welcome back.
                </div>
            <% } %>
            <!-- Stats Grid -->
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-icon primary">
                        <i class="fa-solid fa-calendar-check"></i>
                    </div>
                    <div class="stat-content">
                        <h3><%= totalCount %></h3>
                        <p>Total Appointments</p>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon warning">
                        <i class="fa-solid fa-clock"></i>
                    </div>
                    <div class="stat-content">
                        <h3><%= pendingCount %></h3>
                        <p>Pending</p>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon success">
                        <i class="fa-solid fa-check-circle"></i>
                    </div>
                    <div class="stat-content">
                        <h3><%= confirmedCount %></h3>
                        <p>Confirmed</p>
                    </div>
                </div>
            </div>
            
            <!-- Quick Actions -->
            <div class="content-card">
                <div class="content-card-header">
                    <h3><i class="fa-solid fa-bolt" style="color: var(--primary);"></i> Quick Actions</h3>
                </div>
                <div class="content-card-body">
                    <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 20px;">
                        <a href="doctors.jsp" style="text-decoration: none;">
                            <div class="card" style="padding: 24px; text-align: center;">
                                <div style="width: 60px; height: 60px; background: var(--primary-light); border-radius: 12px; display: flex; align-items: center; justify-content: center; margin: 0 auto 16px;">
                                    <i class="fa-solid fa-user-doctor" style="font-size: 1.5rem; color: var(--primary);"></i>
                                </div>
                                <h4 style="margin-bottom: 8px;">Find a Doctor</h4>
                                <p style="margin: 0; font-size: 0.9rem;">Browse specialists and book appointments</p>
                            </div>
                        </a>
                        <a href="appointments.jsp" style="text-decoration: none;">
                            <div class="card" style="padding: 24px; text-align: center;">
                                <div style="width: 60px; height: 60px; background: var(--info-light); border-radius: 12px; display: flex; align-items: center; justify-content: center; margin: 0 auto 16px;">
                                    <i class="fa-solid fa-calendar-check" style="font-size: 1.5rem; color: var(--info);"></i>
                                </div>
                                <h4 style="margin-bottom: 8px;">View Appointments</h4>
                                <p style="margin: 0; font-size: 0.9rem;">Check your appointment history</p>
                            </div>
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </main>
</div>

</body>
</html>
