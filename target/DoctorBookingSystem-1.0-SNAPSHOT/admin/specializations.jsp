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
    <title>Specializations - MedBook</title>
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
            <h1><i class="fa-solid fa-stethoscope" style="color: var(--primary);"></i> Specializations</h1>
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
                                <th>ID</th>
                                <th>Specialization Name</th>
                                <th>Doctor Count</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for(Specialization s : specs) { %>
                            <tr>
                                <td>#<%= s.getId() %></td>
                                <td><strong><%= s.getName() %></strong></td>
                                <td>
                                    <span class="badge" style="background: var(--primary-light); color: var(--primary); padding: 4px 10px; border-radius: 20px; font-size: 0.85rem; font-weight: 600;">
                                        <%= s.getDoctorCount() %> <%= s.getDoctorCount() == 1 ? "doctor" : "doctors" %>
                                    </span>
                                </td>
                                <td>
                                    <div style="display: flex; gap: 8px;">
                                        <a href="editSpecialization.jsp?id=<%= s.getId() %>" class="btn btn-sm btn-outline">
                                            <i class="fa-solid fa-edit"></i> Edit
                                        </a>
                                        <form action="../specialization" method="post" style="display: inline;" onsubmit="return confirm('Are you sure you want to remove this specialization?');">
                                            <input type="hidden" name="action" value="delete">
                                            <input type="hidden" name="id" value="<%= s.getId() %>">
                                            <button type="submit" class="btn btn-sm btn-danger">
                                                <i class="fa-solid fa-trash"></i> Remove
                                            </button>
                                        </form>
                                    </div>
                                </td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
                
                <% if(specs.isEmpty()) { %>
                <div class="empty-state">
                    <i class="fa-solid fa-stethoscope"></i>
                    <h3>No Specializations Found</h3>
                    <p>No specializations have been added yet.</p>
                </div>
                <% } %>
            </div>
        </div>
    </main>
</div>

</body>
</html>
