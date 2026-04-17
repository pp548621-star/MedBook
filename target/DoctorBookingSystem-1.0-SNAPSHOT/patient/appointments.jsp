<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.doctorbooking.dao.AppointmentDao" %>
<%@ page import="com.doctorbooking.model.Appointment" %>
<%@ page import="com.doctorbooking.model.User" %>
<%@ page import="java.util.List" %>
<%
    if(session.getAttribute("userObj") == null || !"patient".equals(((User)session.getAttribute("userObj")).getRole())) {
        response.sendRedirect("../login.jsp");
        return;
    }
    User u = (User) session.getAttribute("userObj");
    AppointmentDao dao = new AppointmentDao();
    List<Appointment> list = dao.getAppointmentsByPatient(u.getId());
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Appointments - MedBook</title>
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
            <h1><i class="fa-solid fa-calendar-check" style="color: var(--primary);"></i> My Appointments</h1>
            <div class="header-actions">
                <a href="doctors.jsp" class="btn btn-primary">
                    <i class="fa-solid fa-plus"></i> Book New
                </a>
            </div>
        </header>
        
        <div class="content-area">
            <div class="content-card">
                <div class="table-container">
                    <table class="table">
                        <thead>
                            <tr>
                                <th>Doctor</th>
                                <th>Specialization</th>
                                <th>Date & Time</th>
                                <th>Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for(Appointment a : list) { %>
                            <tr>
                                <td>
                                    <strong>Dr. <%= a.getDoctorName() %></strong>
                                </td>
                                <td><%= a.getDoctorSpecialization() %></td>
                                <td>
                                    <div><i class="fa-regular fa-calendar" style="color: var(--primary);"></i> <%= a.getAppointmentDate() %></div>
                                    <div style="font-size: 0.875rem; color: var(--text-muted); margin-top: 4px;">
                                        <i class="fa-regular fa-clock"></i> <%= a.getAppointmentTime() %>
                                    </div>
                                </td>
                                <td>
                                    <% if("pending".equals(a.getStatus())) { %>
                                        <span class="badge badge-pending"><i class="fa-solid fa-clock"></i> Pending</span>
                                    <% } else if("confirmed".equals(a.getStatus())) { %>
                                        <span class="badge badge-confirmed"><i class="fa-solid fa-check"></i> Confirmed</span>
                                    <% } else if("rejected".equals(a.getStatus()) || "cancelled".equals(a.getStatus())) { %>
                                        <span class="badge badge-cancelled"><i class="fa-solid fa-xmark"></i> Cancelled</span>
                                    <% } else { %>
                                        <span class="badge badge-completed"><i class="fa-solid fa-check-double"></i> Completed</span>
                                    <% } %>
                                </td>
                                </td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
                
                <% if(list.isEmpty()) { %>
                <div class="empty-state">
                    <i class="fa-solid fa-calendar-xmark"></i>
                    <h3>No Appointments Yet</h3>
                    <p>You haven't booked any appointments. Start by finding a doctor.</p>
                    <a href="doctors.jsp" class="btn btn-primary" style="margin-top: 16px;">
                        <i class="fa-solid fa-user-doctor"></i> Find a Doctor
                    </a>
                </div>
                <% } %>
            </div>
        </div>
    </main>
</div>

</body>
</html>
