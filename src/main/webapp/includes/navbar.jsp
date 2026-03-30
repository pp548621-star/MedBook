<!-- Navbar -->
<nav class="navbar">
    <div class="navbar-container">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/index.jsp">
            <i class="fa-solid fa-heart-pulse"></i>
            MedBook
        </a>
        <ul class="navbar-nav">
            <c:if test="${empty userObj}">
                <li><a class="nav-link ${pageContext.request.requestURI.endsWith('index.jsp') ? 'active' : ''}" href="${pageContext.request.contextPath}/index.jsp">Home</a></li>
                <li><a class="nav-link ${pageContext.request.requestURI.endsWith('login.jsp') ? 'active' : ''}" href="${pageContext.request.contextPath}/login.jsp">Login</a></li>
                <li><a class="btn btn-primary" href="${pageContext.request.contextPath}/register.jsp">Get Started</a></li>
            </c:if>
            <c:if test="${not empty userObj}">
                <li><span style="color: var(--text-muted); font-weight: 500;">Welcome, <strong style="color: var(--text-dark);">${userObj.name}</strong></span></li>
                <li><a class="btn btn-outline" href="${pageContext.request.contextPath}/auth?action=logout"><i class="fa-solid fa-sign-out-alt"></i> Logout</a></li>
            </c:if>
        </ul>
    </div>
</nav>

<!-- Alert Messages -->
<c:if test="${not empty succMsg}">
    <div style="max-width: 1280px; margin: 20px auto; padding: 0 24px;">
        <div class="alert alert-success">
            <i class="fa-solid fa-check-circle"></i> ${succMsg}
        </div>
    </div>
    <c:remove var="succMsg" scope="session"/>
</c:if>
<c:if test="${not empty errorMsg}">
    <div style="max-width: 1280px; margin: 20px auto; padding: 0 24px;">
        <div class="alert alert-danger">
            <i class="fa-solid fa-exclamation-circle"></i> ${errorMsg}
        </div>
    </div>
    <c:remove var="errorMsg" scope="session"/>
</c:if>
