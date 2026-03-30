<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.doctorbooking.dao.AvailabilityDao" %>
<%@ page import="com.doctorbooking.dao.DoctorDao" %>
<%@ page import="com.doctorbooking.model.Availability" %>
<%@ page import="com.doctorbooking.model.Doctor" %>
<%@ page import="com.doctorbooking.model.User" %>
<%@ page import="java.util.List" %>

<%
    User u = (User) session.getAttribute("userObj");
    if (u == null || !"doctor".equals(u.getRole())) {
        response.sendRedirect("../login.jsp");
        return;
    }

    DoctorDao docDao = new DoctorDao();
    Doctor doc = docDao.getDoctorByUserId(u.getId());
    
    if (doc == null) {
        response.sendRedirect("dashboard.jsp?msg=setup_profile_first");
        return;
    }

    AvailabilityDao avDao = new AvailabilityDao();
    List<Availability> list = avDao.getAvailabilityByDoctorId(doc.getId());
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Availability Slots - MedBook</title>
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
            <h1><i class="fa-solid fa-clock-rotate-left" style="color: var(--primary);"></i> Availability Slots</h1>
            <div class="header-actions">
                <span class="user-badge"><i class="fa-solid fa-calendar"></i> Define Working Hours</span>
            </div>
        </header>

        <div class="content-area">
            <% String msg = request.getParameter("msg"); %>
            <% if ("added".equals(msg)) { %>
                <div class="alert alert-success"><i class="fa-solid fa-circle-check"></i> Slot added successfully!</div>
            <% } else if ("deleted".equals(msg)) { %>
                <div class="alert alert-success"><i class="fa-solid fa-circle-check"></i> Slot deleted!</div>
            <% } else if ("error".equals(msg)) { %>
                <div class="alert alert-danger"><i class="fa-solid fa-circle-exclamation"></i> Error while saving.</div>
            <% } %>

            <div style="display: grid; grid-template-columns: 1fr 2fr; gap: 30px;">
                <!-- Add Slot Form -->
                <div class="content-card">
                    <div class="content-card-header">
                        <h3>Add Working Slot</h3>
                    </div>
                    <div class="content-card-body">
                        <form action="${pageContext.request.contextPath}/doctor/availability" method="post">
                            <input type="hidden" name="action" value="add">
                            
                            <div class="form-group">
                                <label class="form-label">Day of Week</label>
                                <select name="dayOfWeek" class="form-control" required>
                                    <option value="Monday">Monday</option>
                                    <option value="Tuesday">Tuesday</option>
                                    <option value="Wednesday">Wednesday</option>
                                    <option value="Thursday">Thursday</option>
                                    <option value="Friday">Friday</option>
                                    <option value="Saturday">Saturday</option>
                                    <option value="Sunday">Sunday</option>
                                </select>
                            </div>
                            
                            <div class="form-group">
                                <label class="form-label">Start Time</label>
                                <input type="time" name="startTime" class="form-control" required>
                            </div>

                            <div class="form-group">
                                <label class="form-label">End Time</label>
                                <input type="time" name="endTime" class="form-control" required>
                            </div>

                            <button type="submit" class="btn btn-primary" style="width: 100%; margin-top: 20px;">
                                <i class="fa-solid fa-plus"></i> Add Slot
                            </button>
                        </form>
                    </div>
                </div>

                <!-- Existing Slots Table -->
                <div class="content-card">
                    <div class="content-card-header">
                        <h3>Current Availability</h3>
                    </div>
                    <div class="content-card-body">
                        <% if(list.isEmpty()) { %>
                            <div class="empty-state">
                                <i class="fa-solid fa-calendar-xmark"></i>
                                <h3>No Slots Defined</h3>
                                <p>You haven't added any working hours yet.</p>
                            </div>
                        <% } else { %>
                        <div class="table-container">
                            <table class="table">
                                <thead>
                                    <tr>
                                        <th>Day</th>
                                        <th>Time Range</th>
                                        <th>Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% for(Availability av : list) { %>
                                    <tr>
                                        <td><strong><%= av.getDayOfWeek() %></strong></td>
                                        <td><%= av.getStartTime() %> - <%= av.getEndTime() %></td>
                                        <td>
                                            <form action="${pageContext.request.contextPath}/doctor/availability" method="post">
                                                <input type="hidden" name="action" value="delete">
                                                <input type="hidden" name="id" value="<%= av.getId() %>">
                                                <button type="submit" class="btn btn-sm btn-danger">
                                                    <i class="fa-solid fa-trash"></i>
                                                </button>
                                            </form>
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
        </div>
    </main>
</div>

</body>
</html>
