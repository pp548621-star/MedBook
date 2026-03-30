<aside class="sidebar">
    <div class="sidebar-header">
        <a href="${pageContext.request.contextPath}/index.jsp" class="sidebar-brand">
            <i class="fa-solid fa-heart-pulse"></i>
            MedBook
        </a>
    </div>
    
    <div class="sidebar-user">
        <div class="user-avatar" style="overflow: hidden; display: flex; align-items: center; justify-content: center;">
            <c:choose>
                <c:when test="${not empty userObj.photo}">
                    <img src="${pageContext.request.contextPath}/uploads/profiles/${userObj.photo}" alt="Avatar" style="width: 100%; height: 100%; object-fit: cover;">
                </c:when>
                <c:otherwise>
                    <i class="fa-solid fa-user"></i>
                </c:otherwise>
            </c:choose>
        </div>
        <div class="user-info">
            <h4>${userObj.name}</h4>
            <p>Patient</p>
        </div>
    </div>
    
    <ul class="sidebar-nav">
        <li>
            <a href="dashboard.jsp" class="${pageContext.request.requestURI.endsWith('dashboard.jsp') ? 'active' : ''}">
                <i class="fa-solid fa-house"></i>
                Dashboard
            </a>
        </li>
        <li>
            <a href="doctors.jsp" class="${pageContext.request.requestURI.endsWith('doctors.jsp') ? 'active' : ''}">
                <i class="fa-solid fa-user-doctor"></i>
                Find Doctors
            </a>
        </li>
        <li>
            <a href="appointments.jsp" class="${pageContext.request.requestURI.endsWith('appointments.jsp') ? 'active' : ''}">
                <i class="fa-solid fa-calendar-check"></i>
                My Appointments
            </a>
        </li>
        <li>
            <a href="profile.jsp" class="${pageContext.request.requestURI.endsWith('profile.jsp') ? 'active' : ''}">
                <i class="fa-solid fa-user-gear"></i>
                My Profile
            </a>
        </li>
    </ul>
    
    <div class="sidebar-footer">
        <a href="${pageContext.request.contextPath}/auth?action=logout" class="btn btn-outline">
            <i class="fa-solid fa-right-from-bracket"></i> Logout
        </a>
    </div>
</aside>
