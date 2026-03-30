<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.doctorbooking.dao.SpecializationDao" %>
<%@ page import="com.doctorbooking.model.Specialization" %>
<%@ page import="com.doctorbooking.model.User" %>
<%@ page import="java.util.List" %>
<%
    if(session.getAttribute("userObj") == null || !"admin".equals(((User)session.getAttribute("userObj")).getRole())) {
        response.sendRedirect("../login.jsp");
        return;
    }
    SpecializationDao specDao = new SpecializationDao();
    List<Specialization> specs = specDao.getAllSpecializations();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Doctor - MedBook</title>
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
            <h1><i class="fa-solid fa-user-plus" style="color: var(--primary);"></i> Add Doctor</h1>
            <div class="header-actions">
                <a href="doctors.jsp" class="btn btn-outline">
                    <i class="fa-solid fa-arrow-left"></i> Back to Doctors
                </a>
            </div>
        </header>
        
        <div class="content-area">
            <div class="appointment-form">
                <div class="content-card">
                    <div class="content-card-body">
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
                        
                        <form action="../admin" method="post">
                            <input type="hidden" name="action" value="addDoctor">
                            
                            <div class="form-group">
                                <label class="form-label">Full Name</label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="fa-solid fa-user"></i></span>
                                    <input type="text" class="form-control" name="name" required placeholder="Dr. John Doe">
                                </div>
                            </div>
                            
                            <div class="form-group">
                                <label class="form-label">Email Address</label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="fa-solid fa-envelope"></i></span>
                                    <input type="email" class="form-control" name="email" required placeholder="doctor@example.com">
                                </div>
                            </div>
                            
                            <div class="form-group">
                                <label class="form-label">Password</label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="fa-solid fa-lock"></i></span>
                                    <input type="password" class="form-control" name="password" required placeholder="Create a password">
                                </div>
                            </div>
                            
                            <div class="form-group">
                                <label class="form-label">Specialization</label>
                                <select class="form-select" name="specializationId" required>
                                    <option value="">Select Specialization</option>
                                    <% for(Specialization s : specs) { %>
                                    <option value="<%= s.getId() %>"><%= s.getName() %></option>
                                    <% } %>
                                </select>
                            </div>
                            
                            <div class="form-group">
                                <label class="form-label">Consultation Fee ($)</label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="fa-solid fa-dollar-sign"></i></span>
                                    <input type="number" class="form-control" name="fees" required placeholder="100" min="0" step="0.01">
                                </div>
                            </div>
                            
                            <div style="display: flex; gap: 12px; margin-top: 8px;">
                                <a href="doctors.jsp" class="btn btn-outline" style="flex: 1;">Cancel</a>
                                <button type="submit" class="btn btn-primary" style="flex: 1;">
                                    <i class="fa-solid fa-plus"></i> Add Doctor
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </main>
</div>

</body>
</html>
