<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sign In - MedBook</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>

<div class="auth-page">
    <div class="auth-container">
        <div class="auth-card">
            <div class="auth-header">
                <a href="index.jsp" class="logo">
                    <i class="fa-solid fa-heart-pulse"></i>
                    MedBook
                </a>
                <h2>Welcome Back</h2>
                <p>Sign in to manage your appointments</p>
            </div>
            
            <% String msg = request.getParameter("msg"); %>
            <% if ("invalid".equals(msg)) { %>
                <div class="alert alert-danger">
                    <i class="fa-solid fa-circle-exclamation"></i>
                    Invalid email, password or role!
                </div>
            <% } else if ("pending".equals(msg)) { %>
                <div class="alert alert-warning">
                    <i class="fa-solid fa-clock"></i>
                    Your account is waiting for admin approval.
                </div>
            <% } else if ("rejected".equals(msg)) { %>
                <div class="alert alert-danger">
                    <i class="fa-solid fa-circle-xmark"></i>
                    Your account has been rejected by the admin.
                </div>
            <% } else if ("registered".equals(msg)) { %>
                <div class="alert alert-success">
                    <i class="fa-solid fa-circle-check"></i>
                    Registration successful! Please sign in.
                </div>
            <% } else if ("registered_doctor".equals(msg)) { %>
                <div class="alert alert-success">
                    <i class="fa-solid fa-circle-check"></i>
                    Registration successful! Waiting for admin approval.
                </div>
            <% } else if ("loggedout".equals(msg)) { %>
                <div class="alert alert-warning">
                    <i class="fa-solid fa-circle-info"></i>
                    You have been logged out.
                </div>
            <% } %>
            
            <form action="auth" method="post">
                <input type="hidden" name="action" value="login">
                
                <div class="form-group">
                    <label class="form-label">Email Address</label>
                    <div class="input-group">
                        <span class="input-group-text"><i class="fa-solid fa-envelope"></i></span>
                        <input type="email" class="form-control" name="email" required placeholder="Enter your email">
                    </div>
                </div>
                
                <div class="form-group">
                    <label class="form-label">Password</label>
                    <div class="input-group">
                        <span class="input-group-text"><i class="fa-solid fa-lock"></i></span>
                        <input type="password" class="form-control" name="password" required placeholder="Enter your password">
                    </div>
                </div>

                <div class="form-group">
                    <label class="form-label">Sign In As</label>
                    <div class="input-group">
                        <span class="input-group-text"><i class="fa-solid fa-user-tag"></i></span>
                        <select class="form-control" name="role" required>
                            <option value="patient">Patient (User)</option>
                            <option value="doctor">Doctor</option>
                            <option value="admin">Admin</option>
                        </select>
                    </div>
                </div>
                
                <button type="submit" class="btn btn-primary w-100" style="margin-top: 8px;">
                    <i class="fa-solid fa-sign-in-alt"></i> Sign In
                </button>
            </form>
            
            <div class="auth-footer">
                <p>Don't have an account? <a href="register.jsp">Create One</a></p>
            </div>
        </div>
    </div>
</div>

</body>
</html>
