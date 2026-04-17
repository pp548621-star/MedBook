<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.doctorbooking.dao.AppointmentTimelineDao" %>
<%@ page import="com.doctorbooking.model.AppointmentTimeline" %>
<%@ page import="com.doctorbooking.model.User" %>
<%@ page import="java.util.List" %>
<%
    User u = (User) session.getAttribute("userObj");
    if(u == null || !"admin".equals(u.getRole())) {
        response.sendRedirect("../login.jsp");
        return;
    }

    String idStr = request.getParameter("id");
    if (idStr == null) {
        response.sendRedirect("appointments.jsp");
        return;
    }
    int appointmentId = Integer.parseInt(idStr);

    AppointmentTimelineDao dao = new AppointmentTimelineDao();
    List<AppointmentTimeline> list = dao.getTimelineByAppointmentId(appointmentId);
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Appointment Timeline - MedBook</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <style>
        .timeline-container {
            max-width: 600px;
            margin: 0 auto;
            position: relative;
        }
        .timeline-item {
            padding: 20px 0;
            border-left: 2px solid var(--primary-light);
            margin-left: 20px;
            padding-left: 30px;
            position: relative;
        }
        .timeline-item::before {
            content: '';
            position: absolute;
            width: 16px;
            height: 16px;
            background: var(--primary);
            border-radius: 50%;
            left: -9px;
            top: 24px;
        }
        .timeline-date {
            font-size: 0.85rem;
            color: var(--text-muted);
            margin-bottom: 5px;
        }
        .timeline-status {
            font-weight: 600;
            color: var(--text);
            text-transform: capitalize;
        }
        .timeline-notes {
            font-size: 0.95rem;
            color: var(--text-light);
            margin-top: 5px;
        }
    </style>
</head>
<body>

<div class="dashboard">
    <jsp:include page="sidebar.jsp" />
    
    <main class="main-content">
        <header class="main-header">
            <h1><i class="fa-solid fa-timeline" style="color: var(--primary);"></i> Appointment Timeline</h1>
            <div class="header-actions">
                <a href="appointments.jsp" class="btn btn-outline"><i class="fa-solid fa-arrow-left"></i> Back</a>
            </div>
        </header>

        <div class="content-area">
            <div class="content-card">
                <div class="content-card-header">
                    <h3>Lifecycle of Appointment #<%= appointmentId %></h3>
                </div>
                <div class="content-card-body">
                    <% if (list.isEmpty()) { %>
                        <div class="alert alert-warning"><i class="fa-solid fa-triangle-exclamation"></i> No timeline data available for this appointment.</div>
                    <% } else { %>
                        <div class="timeline-container">
                            <% for (AppointmentTimeline at : list) { %>
                                <div class="timeline-item">
                                    <div class="timeline-date"><i class="fa-solid fa-clock"></i> <%= at.getCreatedAt() %></div>
                                    <div class="timeline-status"><%= at.getStatus() %></div>
                                    <div class="timeline-notes"><%= at.getNotes() %></div>
                                </div>
                            <% } %>
                        </div>
                    <% } %>
                </div>
            </div>
        </div>
    </main>
</div>

</body>
</html>
