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
        doc.setId(0); // Mock ID to avoid NPE
    }

    AppointmentDao dao = new AppointmentDao();
    List<Appointment> list = dao.getAppointmentsByDoctor(doc.getId());
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Appointments - MedBook</title>
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
            <h1><i class="fa-solid fa-calendar-check" style="color: var(--primary);"></i> Manage Appointments</h1>
        </header>
        
        <div class="content-area">
            <div class="content-card">
                <div class="table-container">
                    <table class="table">
                        <thead>
                            <tr>
                                <th>Patient Name</th>
                                <th>Date & Time</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for(Appointment a : list) { %>
                            <tr>
                                <td><strong><%= a.getPatientName() %></strong></td>
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
                                <td>
                                    <% if("pending".equals(a.getStatus())) { %>
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
                                    <% } else if("confirmed".equals(a.getStatus())) { %>
                                        <form action="../appointment" method="post">
                                            <input type="hidden" name="action" value="updateStatus">
                                            <input type="hidden" name="id" value="<%= a.getId() %>">
                                            <input type="hidden" name="status" value="completed">
                                            <input type="hidden" name="role" value="doctor">
                                            <button type="submit" class="btn btn-outline btn-sm" style="border-color: var(--info); color: var(--info);">
                                                <i class="fa-solid fa-flag-checkered"></i> Mark Completed
                                            </button>
                                        </form>
                                    <% } else { %>
                                        <span style="color: var(--text-light);">No Actions</span>
                                    <% } %>
                                </td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
                
                <% if(list.isEmpty()) { %>
                <div class="empty-state">
                    <i class="fa-solid fa-calendar-xmark"></i>
                    <h3>No Appointments</h3>
                    <p>You don't have any appointments yet.</p>
                </div>
                <% } %>
            </div>
        </div>
    </main>
</div>

</body>
</html>
