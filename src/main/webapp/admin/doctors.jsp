<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.doctorbooking.dao.DoctorDao" %>
<%@ page import="com.doctorbooking.model.Doctor" %>
<%@ page import="com.doctorbooking.model.User" %>
<%@ page import="java.util.List" %>
<%
    if(session.getAttribute("userObj") == null || !"admin".equals(((User)session.getAttribute("userObj")).getRole())) {
        response.sendRedirect("../login.jsp");
        return;
    }
    DoctorDao dao = new DoctorDao();
    List<Doctor> list = dao.getAllDoctors();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Doctors - MedBook</title>
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
            <h1><i class="fa-solid fa-user-doctor" style="color: var(--primary);"></i> Manage Doctors</h1>
            <div class="header-actions">
                <a href="addDoctor.jsp" class="btn btn-primary">
                    <i class="fa-solid fa-plus"></i> Add Doctor
                </a>
            </div>
        </header>
        
        <div class="content-area">
            <c:if test="${not empty succMsg}">
                <div class="alert alert-success" style="margin-bottom: 20px;">
                    <i class="fa-solid fa-check-circle"></i> ${succMsg}
                </div>
                <% session.removeAttribute("succMsg"); %>
            </c:if>
            <c:if test="${not empty errorMsg}">
                <div class="alert alert-danger" style="margin-bottom: 20px;">
                    <i class="fa-solid fa-exclamation-circle"></i> ${errorMsg}
                </div>
                <% session.removeAttribute("errorMsg"); %>
            </c:if>

            <div class="content-card">
                <div class="table-container">
                    <table class="table">
                        <thead>
                            <tr>
                                <th>Doctor Name</th>
                                <th>Specialization</th>
                                <th>Consultation Fee</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for(Doctor d : list) { %>
                            <tr>
                                <td>
                                    <div style="display: flex; align-items: center; gap: 12px;">
                                        <div style="width: 40px; height: 40px; background: var(--primary-light); border-radius: 50%; display: flex; align-items: center; justify-content: center;">
                                            <i class="fa-solid fa-user-doctor" style="color: var(--primary);"></i>
                                        </div>
                                        <strong>Dr. <%= d.getName() %></strong>
                                    </div>
                                </td>
                                <td><%= d.getSpecializationName() %></td>
                                <td>₹<%= d.getFees() %></td>
                                </td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
                
                <% if(list.isEmpty()) { %>
                <div class="empty-state">
                    <i class="fa-solid fa-user-doctor"></i>
                    <h3>No Doctors Found</h3>
                    <p>Start by adding your first doctor.</p>
                    <a href="addDoctor.jsp" class="btn btn-primary" style="margin-top: 16px;">
                        <i class="fa-solid fa-plus"></i> Add Doctor
                    </a>
                </div>
                <% } %>
            </div>
        </div>
    </main>
</div>

</body>
</html>
