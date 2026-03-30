<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.doctorbooking.dao.SpecializationDao" %>
<%@ page import="com.doctorbooking.model.Specialization" %>
<%@ page import="com.doctorbooking.model.User" %>
<%
    if(session.getAttribute("userObj") == null || !"admin".equals(((User)session.getAttribute("userObj")).getRole())) {
        response.sendRedirect("../login.jsp");
        return;
    }
    int id = Integer.parseInt(request.getParameter("id"));
    SpecializationDao specDao = new SpecializationDao();
    Specialization spec = specDao.getSpecializationById(id);
    if(spec == null) {
        response.sendRedirect("specializations.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Specialization - MedBook</title>
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
            <h1><i class="fa-solid fa-edit" style="color: var(--primary);"></i> Edit Specialization</h1>
            <div class="header-actions">
                <a href="specializations.jsp" class="btn btn-outline">
                    <i class="fa-solid fa-arrow-left"></i> Back to Specializations
                </a>
            </div>
        </header>
        
        <div class="content-area">
            <div class="appointment-form" style="max-width: 500px;">
                <div class="content-card">
                    <div class="content-card-body">
                        <form action="../specialization" method="post">
                            <input type="hidden" name="action" value="update">
                            <input type="hidden" name="id" value="<%= spec.getId() %>">
                            
                            <div class="form-group">
                                <label class="form-label">Specialization Name</label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="fa-solid fa-stethoscope"></i></span>
                                    <input type="text" class="form-control" name="name" value="<%= spec.getName() %>" required placeholder="e.g. Cardiology">
                                </div>
                            </div>
                            
                            <div style="display: flex; gap: 12px; margin-top: 8px;">
                                <a href="specializations.jsp" class="btn btn-outline" style="flex: 1;">Cancel</a>
                                <button type="submit" class="btn btn-primary" style="flex: 1;">
                                    <i class="fa-solid fa-save"></i> Save Changes
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
