<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Account - MedBook</title>
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
                <h2>Create an Account</h2>
                <p>Join MedBook to manage your healthcare appointments</p>
            </div>
            
            <% String msg = request.getParameter("msg"); %>
            <% if ("error".equals(msg)) { %>
                <div class="alert alert-danger">
                    <i class="fa-solid fa-circle-exclamation"></i>
                    Something went wrong. Email might already exist!
                </div>
            <% } %>
            
            <form action="auth" method="post" enctype="multipart/form-data">
                <input type="hidden" name="action" value="register">
                
                <div class="form-group">
                    <label class="form-label">Full Name</label>
                    <div class="input-group">
                        <span class="input-group-text"><i class="fa-solid fa-user"></i></span>
                        <input type="text" class="form-control" name="name" required placeholder="John Doe">
                    </div>
                </div>
                
                <div class="form-group">
                    <label class="form-label">Email Address</label>
                    <div class="input-group">
                        <span class="input-group-text"><i class="fa-solid fa-envelope"></i></span>
                        <input type="email" class="form-control" name="email" required placeholder="example@email.com">
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
                    <label class="form-label">Register As</label>
                    <div class="input-group">
                        <span class="input-group-text"><i class="fa-solid fa-user-tag"></i></span>
                        <select class="form-control" name="role" id="roleSelect" required onchange="toggleCertificateUpload()">
                            <option value="patient">Patient (User)</option>
                            <option value="doctor">Doctor</option>
                        </select>
                    </div>
                </div>

                <div class="form-group" id="certificateGroup" style="display: none;">
                    <label class="form-label">Doctor Certificate (Proof)</label>
                    <div class="input-group">
                        <span class="input-group-text"><i class="fa-solid fa-file-medical"></i></span>
                        <input type="file" class="form-control" name="certificate" id="certificateInput" accept=".pdf,.jpg,.jpeg,.png">
                    </div>
                    <small style="color: var(--text-muted);">Upload your medical license or degree (PDF/Image)</small>
                </div>
                
                <button type="submit" class="btn btn-primary w-100" style="margin-top: 8px;">
                    <i class="fa-solid fa-user-plus"></i> Create Account
                </button>
            </form>
            
            <div class="auth-footer">
                <p>Already have an account? <a href="login.jsp">Sign In</a></p>
            </div>
        </div>
    </div>
</div>

<script>
function toggleCertificateUpload() {
    const role = document.getElementById('roleSelect').value;
    const certGroup = document.getElementById('certificateGroup');
    const certInput = document.getElementById('certificateInput');
    
    if (role === 'doctor') {
        certGroup.style.display = 'block';
        certInput.setAttribute('required', 'required');
    } else {
        certGroup.style.display = 'none';
        certInput.removeAttribute('required');
    }
}
</script>

</body>
</html>
