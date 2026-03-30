<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.doctorbooking.dao.DoctorDao" %>
<%@ page import="com.doctorbooking.dao.UserDao" %>
<%@ page import="com.doctorbooking.dao.AppointmentDao" %>
<%@ page import="com.doctorbooking.model.User" %>
<%@ page import="com.doctorbooking.model.Doctor" %>
<%@ page import="java.util.List" %>
<%@ page import="com.doctorbooking.model.Appointment" %>
<%
    if(session.getAttribute("userObj") == null || !"admin".equals(((User)session.getAttribute("userObj")).getRole())) {
        response.sendRedirect("../login.jsp");
        return;
    }
    UserDao userDao = new UserDao();
    DoctorDao doctorDao = new DoctorDao();
    AppointmentDao appointmentDao = new AppointmentDao();
    
    int totalDoctors = doctorDao.getTotalDoctors();
    int totalPatients = userDao.getTotalPatients();
    int totalAppointments = appointmentDao.getTotalAppointments();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - MedBook</title>
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
            <h1><i class="fa-solid fa-shield-halved" style="color: var(--primary);"></i> Admin Dashboard</h1>
            <div class="header-actions">
                <span style="color: var(--text-muted);"><i class="fa-solid fa-user-shield"></i> Administrator</span>
            </div>
        </header>
        
        <div class="content-area">
            <% if("success".equals(request.getParameter("msg"))) { %>
                <div class="alert alert-success">
                    <i class="fa-solid fa-circle-check"></i>
                    Login successful! Welcome back.
                </div>
            <% } %>

            <% String succMsg = (String)session.getAttribute("succMsg"); %>
            <% if(succMsg != null) { %>
                <div class="alert alert-success">
                    <i class="fa-solid fa-circle-check"></i>
                    <%= succMsg %>
                </div>
                <% session.removeAttribute("succMsg"); %>
            <% } %>

            <% String errorMsg = (String)session.getAttribute("errorMsg"); %>
            <% if(errorMsg != null) { %>
                <div class="alert alert-danger">
                    <i class="fa-solid fa-circle-exclamation"></i>
                    <%= errorMsg %>
                </div>
                <% session.removeAttribute("errorMsg"); %>
            <% } %>

            <!-- Stats Grid -->
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-icon primary">
                        <i class="fa-solid fa-user-doctor"></i>
                    </div>
                    <div class="stat-content">
                        <h3><%= totalDoctors %></h3>
                        <p>Total Doctors</p>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon info">
                        <i class="fa-solid fa-users"></i>
                    </div>
                    <div class="stat-content">
                        <h3><%= totalPatients %></h3>
                        <p>Total Patients</p>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon success">
                        <i class="fa-solid fa-calendar-check"></i>
                    </div>
                    <div class="stat-content">
                        <h3><%= totalAppointments %></h3>
                        <p>Total Appointments</p>
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
                                <h4 style="margin-bottom: 8px;">Manage Doctors</h4>
                                <p style="margin: 0; font-size: 0.9rem;">View and add new doctors</p>
                            </div>
                        </a>
                        <a href="specializations.jsp" style="text-decoration: none;">
                            <div class="card" style="padding: 24px; text-align: center;">
                                <div style="width: 60px; height: 60px; background: var(--info-light); border-radius: 12px; display: flex; align-items: center; justify-content: center; margin: 0 auto 16px;">
                                    <i class="fa-solid fa-stethoscope" style="font-size: 1.5rem; color: var(--info);"></i>
                                </div>
                                <h4 style="margin-bottom: 8px;">Specializations</h4>
                                <p style="margin: 0; font-size: 0.9rem;">Manage doctor specializations</p>
                            </div>
                        </a>
                    </div>
                </div>
            </div>

            <!-- Doctor Verification -->
            <div class="content-card mt-5">
                <div class="content-card-header d-flex justify-content-between align-items-center">
                    <h3><i class="fa-solid fa-user-check" style="color: var(--warning);"></i> Pending Doctor Approvals</h3>
                </div>
                <div class="content-card-body">
                    <% List<User> pendingDoctors = userDao.getPendingDoctors(); %>
                    <% if(pendingDoctors.isEmpty()) { %>
                        <div class="empty-state">
                            <i class="fa-solid fa-check-circle" style="color: var(--success);"></i>
                            <h3>No Pending Requests</h3>
                            <p>All doctor registration requests have been processed.</p>
                        </div>
                    <% } else { %>
                    <div class="table-container">
                        <table class="table">
                            <thead>
                                <tr>
                                    <th>Name</th>
                                    <th>Email</th>
                                    <th>Certificate</th>
                                    <th>Registered Date</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for(User d : pendingDoctors) { %>
                                <tr>
                                    <td><strong><%= d.getName() %></strong></td>
                                    <td><%= d.getEmail() %></td>
                                    <td>
                                        <% if(d.getCertificate() != null && !d.getCertificate().isEmpty()) { %>
                                            <a href="${pageContext.request.contextPath}/uploads/certificates/<%= d.getCertificate() %>" target="_blank" class="btn btn-outline btn-sm">
                                                <i class="fa-solid fa-file-pdf"></i> View Certificate
                                            </a>
                                        <% } else { %>
                                            <span class="text-muted">No Certificate</span>
                                        <% } %>
                                    </td>
                                    <td><%= d.getCreatedAt() %></td>
                                    <td>
                                        <div style="display: flex; gap: 8px;">
                                            <form action="${pageContext.request.contextPath}/admin" method="post">
                                                <input type="hidden" name="action" value="approveDoctor">
                                                <input type="hidden" name="userId" value="<%= d.getId() %>">
                                                <button type="submit" class="btn btn-success btn-sm">
                                                    <i class="fa-solid fa-check"></i> Approve
                                                </button>
                                            </form>
                                            <form action="${pageContext.request.contextPath}/admin" method="post">
                                                <input type="hidden" name="action" value="rejectDoctor">
                                                <input type="hidden" name="userId" value="<%= d.getId() %>">
                                                <button type="submit" class="btn btn-outline btn-sm" style="border-color: var(--danger); color: var(--danger);">
                                                    <i class="fa-solid fa-xmark"></i> Reject
                                                </button>
                                            </form>
                                        </div>
                                    </td>
                                </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                    <% } %>
                </div>
            </div>
        </div>
    </main>
</div>

</body>
</html>
