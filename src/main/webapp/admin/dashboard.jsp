<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ page import="com.doctorbooking.dao.DoctorDao" %>
            <%@ page import="com.doctorbooking.dao.UserDao" %>
                <%@ page import="com.doctorbooking.dao.AppointmentDao" %>
                    <%@ page import="com.doctorbooking.model.User" %>
                        <%@ page import="com.doctorbooking.model.Doctor" %>
                            <%@ page import="java.util.List" %>
                                <%@ page import="com.doctorbooking.model.Appointment" %>
                                    <%@ page import="com.doctorbooking.dao.SpecializationDao" %>
                                        <%@ page import="com.doctorbooking.model.Specialization" %>
                                            <%@ page import="java.util.Map" %>
                                                <%@ page import="java.util.HashMap" %>
                                                    <% if(session.getAttribute("userObj")==null ||
                                                        !"admin".equals(((User)session.getAttribute("userObj")).getRole()))
                                                        { response.sendRedirect("../login.jsp"); return; } UserDao
                                                        userDao=new UserDao(); DoctorDao doctorDao=new DoctorDao();
                                                        AppointmentDao appointmentDao=new AppointmentDao(); int
                                                        totalDoctors=doctorDao.getTotalDoctors(); int
                                                        totalPatients=userDao.getTotalPatients(); int
                                                        totalAppointments=appointmentDao.getTotalAppointments();
                                                        SpecializationDao specDao=new SpecializationDao();
                                                        List<Specialization> specs = specDao.getAllSpecializations();

                                                        List<Appointment> allAppts =
                                                            appointmentDao.getAllAppointments();
                                                            int pendingAppts = 0;
                                                            int confirmedAppts = 0;
                                                            int cancelledAppts = 0;
                                                            int completedAppts = 0;
                                                            for (Appointment a : allAppts) {
                                                            if ("pending".equals(a.getStatus())) pendingAppts++;
                                                            else if ("confirmed".equals(a.getStatus()))
                                                            confirmedAppts++;
                                                            else if ("cancelled".equals(a.getStatus()) ||
                                                            "rejected".equals(a.getStatus())) cancelledAppts++;
                                                            else if ("completed".equals(a.getStatus()))
                                                            completedAppts++;
                                                            }
                                                            %>

                                                            <!DOCTYPE html>
                                                            <html lang="en">

                                                            <head>
                                                                <meta charset="UTF-8">
                                                                <meta name="viewport"
                                                                    content="width=device-width, initial-scale=1.0">
                                                                <title>Admin Dashboard - MedBook</title>
                                                                <link rel="stylesheet"
                                                                    href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
                                                                <link rel="preconnect"
                                                                    href="https://fonts.googleapis.com">
                                                                <link rel="preconnect" href="https://fonts.gstatic.com"
                                                                    crossorigin>
                                                                <link
                                                                    href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap"
                                                                    rel="stylesheet">
                                                                <link rel="stylesheet"
                                                                    href="${pageContext.request.contextPath}/assets/css/style.css">
                                                            </head>

                                                            <body>

                                                                <div class="dashboard">
                                                                    <jsp:include page="sidebar.jsp" />

                                                                    <main class="main-content">
                                                                        <header class="main-header">
                                                                            <h1><i class="fa-solid fa-shield-halved"
                                                                                    style="color: var(--primary);"></i>
                                                                                Admin Dashboard</h1>
                                                                            <div class="header-actions">
                                                                                <span
                                                                                    style="color: var(--text-muted);"><i
                                                                                        class="fa-solid fa-user-shield"></i>
                                                                                    Administrator</span>
                                                                            </div>
                                                                        </header>

                                                                        <div class="content-area">
                                                                            <% if("success".equals(request.getParameter("msg")))
                                                                                { %>
                                                                                <div class="alert alert-success">
                                                                                    <i
                                                                                        class="fa-solid fa-circle-check"></i>
                                                                                    Login successful! Welcome back.
                                                                                </div>
                                                                                <% } %>

                                                                                    <% String
                                                                                        succMsg=(String)session.getAttribute("succMsg");
                                                                                        %>
                                                                                        <% if(succMsg !=null) { %>
                                                                                            <div
                                                                                                class="alert alert-success">
                                                                                                <i
                                                                                                    class="fa-solid fa-circle-check"></i>
                                                                                                <%= succMsg %>
                                                                                            </div>
                                                                                            <% session.removeAttribute("succMsg");
                                                                                                %>
                                                                                                <% } %>

                                                                                                    <% String
                                                                                                        errorMsg=(String)session.getAttribute("errorMsg");
                                                                                                        %>
                                                                                                        <% if(errorMsg
                                                                                                            !=null) { %>
                                                                                                            <div
                                                                                                                class="alert alert-danger">
                                                                                                                <i
                                                                                                                    class="fa-solid fa-circle-exclamation"></i>
                                                                                                                <%= errorMsg
                                                                                                                    %>
                                                                                                            </div>
                                                                                                            <% session.removeAttribute("errorMsg");
                                                                                                                %>
                                                                                                                <% } %>

                                                                                                                    <!-- Stats Grid -->
                                                                                                                    <div
                                                                                                                        class="stats-grid">
                                                                                                                        <div
                                                                                                                            class="stat-card">
                                                                                                                            <div
                                                                                                                                class="stat-icon primary">
                                                                                                                                <i
                                                                                                                                    class="fa-solid fa-user-doctor"></i>
                                                                                                                            </div>
                                                                                                                            <div
                                                                                                                                class="stat-content">
                                                                                                                                <h3>
                                                                                                                                    <%= totalDoctors
                                                                                                                                        %>
                                                                                                                                </h3>
                                                                                                                                <p>Total
                                                                                                                                    Doctors
                                                                                                                                </p>
                                                                                                                            </div>
                                                                                                                        </div>
                                                                                                                        <div
                                                                                                                            class="stat-card">
                                                                                                                            <div
                                                                                                                                class="stat-icon info">
                                                                                                                                <i
                                                                                                                                    class="fa-solid fa-users"></i>
                                                                                                                            </div>
                                                                                                                            <div
                                                                                                                                class="stat-content">
                                                                                                                                <h3>
                                                                                                                                    <%= totalPatients
                                                                                                                                        %>
                                                                                                                                </h3>
                                                                                                                                <p>Total
                                                                                                                                    Patients
                                                                                                                                </p>
                                                                                                                            </div>
                                                                                                                        </div>
                                                                                                                        <div
                                                                                                                            class="stat-card">
                                                                                                                            <div
                                                                                                                                class="stat-icon success">
                                                                                                                                <i
                                                                                                                                    class="fa-solid fa-calendar-check"></i>
                                                                                                                            </div>
                                                                                                                            <div
                                                                                                                                class="stat-content">
                                                                                                                                <h3>
                                                                                                                                    <%= totalAppointments
                                                                                                                                        %>
                                                                                                                                </h3>
                                                                                                                                <p>Total
                                                                                                                                    Appointments
                                                                                                                                </p>
                                                                                                                            </div>
                                                                                                                        </div>
                                                                                                                    </div>

                                                                                                                    <!-- Analytics Dashboard -->
                                                                                                                    <div
                                                                                                                        class="content-card mt-5">
                                                                                                                        <div
                                                                                                                            class="content-card-header">
                                                                                                                            <h3><i class="fa-solid fa-chart-pie"
                                                                                                                                    style="color: var(--primary);"></i>
                                                                                                                                Platform
                                                                                                                                Analytics
                                                                                                                            </h3>
                                                                                                                        </div>
                                                                                                                        <div
                                                                                                                            class="content-card-body">
                                                                                                                            <div
                                                                                                                                style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">
                                                                                                                                <div
                                                                                                                                    style="background: var(--bg-light); padding: 15px; border-radius: 8px;">
                                                                                                                                    <canvas
                                                                                                                                        id="specializationChart"
                                                                                                                                        width="400"
                                                                                                                                        height="250"></canvas>
                                                                                                                                </div>
                                                                                                                                <div
                                                                                                                                    style="background: var(--bg-light); padding: 15px; border-radius: 8px;">
                                                                                                                                    <canvas
                                                                                                                                        id="appointmentChart"
                                                                                                                                        width="400"
                                                                                                                                        height="250"></canvas>
                                                                                                                                </div>
                                                                                                                            </div>
                                                                                                                        </div>
                                                                                                                    </div>

                                                                                                                    <!-- Quick Actions -->
                                                                                                                    <div
                                                                                                                        class="content-card">
                                                                                                                        <div
                                                                                                                            class="content-card-header">
                                                                                                                            <h3><i class="fa-solid fa-bolt"
                                                                                                                                    style="color: var(--primary);"></i>
                                                                                                                                Quick
                                                                                                                                Actions
                                                                                                                            </h3>
                                                                                                                        </div>
                                                                                                                        <div
                                                                                                                            class="content-card-body">
                                                                                                                            <div
                                                                                                                                style="display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 20px;">
                                                                                                                                <a href="doctors.jsp"
                                                                                                                                    style="text-decoration: none;">
                                                                                                                                    <div class="card"
                                                                                                                                        style="padding: 24px; text-align: center;">
                                                                                                                                        <div
                                                                                                                                            style="width: 60px; height: 60px; background: var(--primary-light); border-radius: 12px; display: flex; align-items: center; justify-content: center; margin: 0 auto 16px;">
                                                                                                                                            <i class="fa-solid fa-user-doctor"
                                                                                                                                                style="font-size: 1.5rem; color: var(--primary);"></i>
                                                                                                                                        </div>
                                                                                                                                        <h4
                                                                                                                                            style="margin-bottom: 8px;">
                                                                                                                                            Manage
                                                                                                                                            Doctors
                                                                                                                                        </h4>
                                                                                                                                        <p
                                                                                                                                            style="margin: 0; font-size: 0.9rem;">
                                                                                                                                            View
                                                                                                                                            and
                                                                                                                                            add
                                                                                                                                            new
                                                                                                                                            doctors
                                                                                                                                        </p>
                                                                                                                                    </div>
                                                                                                                                </a>
                                                                                                                                <a href="specializations.jsp"
                                                                                                                                    style="text-decoration: none;">
                                                                                                                                    <div class="card"
                                                                                                                                        style="padding: 24px; text-align: center;">
                                                                                                                                        <div
                                                                                                                                            style="width: 60px; height: 60px; background: var(--info-light); border-radius: 12px; display: flex; align-items: center; justify-content: center; margin: 0 auto 16px;">
                                                                                                                                            <i class="fa-solid fa-stethoscope"
                                                                                                                                                style="font-size: 1.5rem; color: var(--info);"></i>
                                                                                                                                        </div>
                                                                                                                                        <h4
                                                                                                                                            style="margin-bottom: 8px;">
                                                                                                                                            Specializations
                                                                                                                                        </h4>
                                                                                                                                        <p
                                                                                                                                            style="margin: 0; font-size: 0.9rem;">
                                                                                                                                            Manage
                                                                                                                                            doctor
                                                                                                                                            specializations
                                                                                                                                        </p>
                                                                                                                                    </div>
                                                                                                                                </a>
                                                                                                                            </div>
                                                                                                                        </div>
                                                                                                                    </div>

                                                                                                                    <!-- Doctor Verification -->
                                                                                                                    <div
                                                                                                                        class="content-card mt-5">
                                                                                                                        <div
                                                                                                                            class="content-card-header d-flex justify-content-between align-items-center">
                                                                                                                            <h3><i class="fa-solid fa-user-check"
                                                                                                                                    style="color: var(--warning);"></i>
                                                                                                                                Pending
                                                                                                                                Doctor
                                                                                                                                Approvals
                                                                                                                            </h3>
                                                                                                                        </div>
                                                                                                                        <div
                                                                                                                            class="content-card-body">
                                                                                                                            <%
                                                                                                                                List<User>
                                                                                                                                pendingDoctors
                                                                                                                                =
                                                                                                                                userDao.getPendingDoctors();
                                                                                                                                %>
                                                                                                                                <% if(pendingDoctors.isEmpty())
                                                                                                                                    {
                                                                                                                                    %>
                                                                                                                                    <div
                                                                                                                                        class="empty-state">
                                                                                                                                        <i class="fa-solid fa-check-circle"
                                                                                                                                            style="color: var(--success);"></i>
                                                                                                                                        <h3>No
                                                                                                                                            Pending
                                                                                                                                            Requests
                                                                                                                                        </h3>
                                                                                                                                        <p>All
                                                                                                                                            doctor
                                                                                                                                            registration
                                                                                                                                            requests
                                                                                                                                            have
                                                                                                                                            been
                                                                                                                                            processed.
                                                                                                                                        </p>
                                                                                                                                    </div>
                                                                                                                                    <% } else
                                                                                                                                        {
                                                                                                                                        %>
                                                                                                                                        <div
                                                                                                                                            class="table-container">
                                                                                                                                            <table
                                                                                                                                                class="table">
                                                                                                                                                <thead>
                                                                                                                                                    <tr>
                                                                                                                                                        <th>Name
                                                                                                                                                        </th>
                                                                                                                                                        <th>Email
                                                                                                                                                        </th>
                                                                                                                                                        <th>Certificate
                                                                                                                                                        </th>
                                                                                                                                                        <th>Registered
                                                                                                                                                            Date
                                                                                                                                                        </th>
                                                                                                                                                    </tr>
                                                                                                                                                </thead>
                                                                                                                                                <tbody>
                                                                                                                                                    <% for(User
                                                                                                                                                        d
                                                                                                                                                        :
                                                                                                                                                        pendingDoctors)
                                                                                                                                                        {
                                                                                                                                                        %>
                                                                                                                                                        <tr>
                                                                                                                                                            <td><strong>
                                                                                                                                                                    <%= d.getName()
                                                                                                                                                                        %>
                                                                                                                                                                </strong>
                                                                                                                                                            </td>
                                                                                                                                                            <td>
                                                                                                                                                                <%= d.getEmail()
                                                                                                                                                                    %>
                                                                                                                                                            </td>
                                                                                                                                                            <td>
                                                                                                                                                                <% if(d.getCertificate()
                                                                                                                                                                    !=null
                                                                                                                                                                    &&
                                                                                                                                                                    !d.getCertificate().isEmpty())
                                                                                                                                                                    {
                                                                                                                                                                    %>
                                                                                                                                                                    <a href="${pageContext.request.contextPath}/uploads/certificates/<%= d.getCertificate() %>"
                                                                                                                                                                        target="_blank"
                                                                                                                                                                        class="btn btn-outline btn-sm">
                                                                                                                                                                        <i
                                                                                                                                                                            class="fa-solid fa-file-pdf"></i>
                                                                                                                                                                        View
                                                                                                                                                                        Certificate
                                                                                                                                                                    </a>
                                                                                                                                                                    <% } else
                                                                                                                                                                        {
                                                                                                                                                                        %>
                                                                                                                                                                        <span
                                                                                                                                                                            class="text-muted">No
                                                                                                                                                                            Certificate</span>
                                                                                                                                                                        <% }
                                                                                                                                                                            %>
                                                                                                                                                            </td>
                                                                                                                                                            <td>
                                                                                                                                                                <%= d.getCreatedAt()
                                                                                                                                                                    %>
                                                                                                                                                            </td>
                                                                                                                                                            </td>
                                                                                                                                                        </tr>
                                                                                                                                                        <% }
                                                                                                                                                            %>
                                                                                                                                                </tbody>
                                                                                                                                            </table>
                                                                                                                                        </div>
                                                                                                                                        <% }
                                                                                                                                            %>
                                                                                                                        </div>
                                                                                                                    </div>
                                                                        </div>
                                                                    </main>
                                                                </div>

                                                                <!-- Include Chart.js -->
                                                                <script
                                                                    src="https://cdn.jsdelivr.net/npm/chart.js"></script>
                                                                <script>
                                                                    // Specialization Data
                                                                    var specLabels = [
        <% for (int i = 0; i < specs.size(); i++) { %>
                                                                        "<%= specs.get(i).getName() %>" <%= i < specs.size() - 1 ? "," : "" %>
        <% } %>
    ];
                                                                    var specData = [
        <% for (int i = 0; i < specs.size(); i++) { %>
            <%= specs.get(i).getDoctorCount() %><%= i < specs.size() - 1 ? "," : "" %>
        <% } %>
    ];

                                                                    var ctxSpec = document.getElementById('specializationChart').getContext('2d');
                                                                    new Chart(ctxSpec, {
                                                                        type: 'bar',
                                                                        data: {
                                                                            labels: specLabels,
                                                                            datasets: [{
                                                                                label: 'Number of Doctors',
                                                                                data: specData,
                                                                                backgroundColor: 'rgba(54, 162, 235, 0.6)',
                                                                                borderColor: 'rgba(54, 162, 235, 1)',
                                                                                borderWidth: 1
                                                                            }]
                                                                        },
                                                                        options: {
                                                                            responsive: true,
                                                                            plugins: {
                                                                                title: { display: true, text: 'Doctors by Specialization' }
                                                                            },
                                                                            scales: {
                                                                                y: { beginAtZero: true, ticks: { stepSize: 1 } }
                                                                            }
                                                                        }
                                                                    });

                                                                    // Appointment Setup
                                                                    var ctxAppt = document.getElementById('appointmentChart').getContext('2d');
                                                                    new Chart(ctxAppt, {
                                                                        type: 'doughnut',
                                                                        data: {
                                                                            labels: ['Pending', 'Confirmed', 'Completed', 'Cancelled'],
                                                                            datasets: [{
                                                                                data: [<%= pendingAppts %>, <%= confirmedAppts %>, <%= completedAppts %>, <%= cancelledAppts %>],
                                                                                backgroundColor: [
                                                                                    'rgba(255, 206, 86, 0.6)',
                                                                                    'rgba(75, 192, 192, 0.6)',
                                                                                    'rgba(54, 162, 235, 0.6)',
                                                                                    'rgba(255, 99, 132, 0.6)'
                                                                                ],
                                                                                borderWidth: 1
                                                                            }]
                                                                        },
                                                                        options: {
                                                                            responsive: true,
                                                                            plugins: {
                                                                                title: { display: true, text: 'Appointment Status Distribution' }
                                                                            }
                                                                        }
                                                                    });
                                                                </script>

                                                            </body>

                                                            </html>