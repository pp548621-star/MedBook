<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.doctorbooking.model.User" %>

<%
    User u = (User) session.getAttribute("userObj");
    if (u == null || !"patient".equals(u.getRole())) {
        response.sendRedirect("../login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Profile - MedBook</title>
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
            <h1><i class="fa-solid fa-user-gear" style="color: var(--primary);"></i> Settings & Profile</h1>
            <div class="header-actions">
                <span class="user-badge"><i class="fa-solid fa-circle-check"></i> Welcome, <%= u.getName() %></span>
            </div>
        </header>
        
        <div class="content-area">
            <% String msg = request.getParameter("msg"); %>
            <% if ("profile_updated".equals(msg)) { %>
                <div class="alert alert-success">
                    <i class="fa-solid fa-circle-check"></i>
                    Profile updated successfully!
                </div>
            <% } %>

            <div class="content-card">
                <div class="content-card-header">
                    <h3>Personal Information</h3>
                </div>
                <div class="content-card-body">
                    <form action="${pageContext.request.contextPath}/profile" method="post" enctype="multipart/form-data" style="max-width: 600px;">
                        <input type="hidden" name="action" value="updatePatient">
                        <input type="hidden" name="userId" value="<%= u.getId() %>">
                        
                        <!-- Profile Photo Section -->
                        <div class="profile-photo-upload" style="margin-bottom: 32px; display: flex; align-items: center; gap: 24px;">
                            <div class="current-photo" style="width: 100px; height: 100px; border-radius: 50%; overflow: hidden; background: var(--bg-light); border: 2px solid var(--border-light);">
                                <% if(u.getPhoto() != null && !u.getPhoto().isEmpty()) { %>
                                    <img src="${pageContext.request.contextPath}/uploads/profiles/<%= u.getPhoto() %>" alt="Profile" style="width: 100%; height: 100%; object-fit: cover;">
                                <% } else { %>
                                    <div style="width: 100%; height: 100%; display: flex; align-items: center; justify-content: center; font-size: 2rem; color: var(--text-muted);">
                                        <i class="fa-solid fa-user"></i>
                                    </div>
                                <% } %>
                            </div>
                            <div class="upload-controls">
                                <label class="form-label" style="margin-bottom: 8px; display: block;">Change Profile Photo</label>
                                <input type="file" name="photo" class="form-control" accept="image/*">
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="form-label">Full Name</label>
                            <input type="text" name="name" class="form-control" value="<%= u.getName() %>" required>
                        </div>
                        
                        <div class="form-group">
                            <label class="form-label">Email Address (Read-only)</label>
                            <input type="email" class="form-control" value="<%= u.getEmail() %>" readonly style="background-color: var(--bg-light); cursor: not-allowed;">
                        </div>
                        
                        <button type="submit" class="btn btn-primary" style="margin-top: 16px;">
                            <i class="fa-solid fa-save"></i> Save Changes
                        </button>
                    </form>
                </div>
            </div>
        </div>
    </main>
</div>

</body>
</html>
