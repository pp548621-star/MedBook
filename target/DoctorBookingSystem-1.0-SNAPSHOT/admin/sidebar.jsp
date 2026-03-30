<aside class="sidebar">
    <div class="sidebar-header">
        <a href="${pageContext.request.contextPath}/index.jsp" class="sidebar-brand">
            <i class="fa-solid fa-heart-pulse"></i>
            MedBook
        </a>
    </div>
    
    <div class="sidebar-user">
        <div class="user-avatar" style="background: var(--primary-light); color: var(--primary);">
            <i class="fa-solid fa-user-shield"></i>
        </div>
        <div class="user-info">
            <h4>${userObj.name}</h4>
            <p>Administrator</p>
        </div>
    </div>
    
    <ul class="sidebar-nav">
        <li>
            <a href="dashboard.jsp" class="${pageContext.request.requestURI.endsWith('dashboard.jsp') ? 'active' : ''}">
                <i class="fa-solid fa-chart-line"></i>
                Dashboard
            </a>
        </li>
        <li>
            <a href="doctors.jsp" class="${pageContext.request.requestURI.endsWith('doctors.jsp') || pageContext.request.requestURI.endsWith('addDoctor.jsp') ? 'active' : ''}">
                <i class="fa-solid fa-user-doctor"></i>
                Manage Doctors
            </a>
        </li>
        <li>
            <a href="specializations.jsp" class="${pageContext.request.requestURI.endsWith('specializations.jsp') ? 'active' : ''}">
                <i class="fa-solid fa-stethoscope"></i>
                Specializations
            </a>
        </li>
    </ul>
    
    <div class="sidebar-footer">
        <a href="${pageContext.request.contextPath}/auth?action=logout" class="btn btn-outline">
            <i class="fa-solid fa-right-from-bracket"></i> Logout
        </a>
    </div>
</aside>
