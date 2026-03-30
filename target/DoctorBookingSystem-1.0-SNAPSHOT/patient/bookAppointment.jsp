<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.doctorbooking.dao.DoctorDao" %>
<%@ page import="com.doctorbooking.model.Doctor" %>
<%@ page import="com.doctorbooking.model.User" %>
<%
    if(session.getAttribute("userObj") == null || !"patient".equals(((User)session.getAttribute("userObj")).getRole())) {
        response.sendRedirect("../login.jsp");
        return;
    }
    int id = Integer.parseInt(request.getParameter("docId"));
    DoctorDao dao = new DoctorDao();
    Doctor d = dao.getDoctorById(id);
    
    // Fetch availability
    final com.doctorbooking.dao.AvailabilityDao avDao = new com.doctorbooking.dao.AvailabilityDao();
    final java.util.List<com.doctorbooking.model.Availability> availabilityList = avDao.getAvailabilityByDoctorId(id);
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Book Appointment - MedBook</title>
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
            <h1><i class="fa-solid fa-calendar-plus" style="color: var(--primary);"></i> Book Appointment</h1>
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
                        <div class="doctor-preview">
                            <img src="https://cdn-icons-png.flaticon.com/512/3774/3774299.png" alt="Dr. <%= d.getName() %>">
                            <div class="doctor-preview-info">
                                <h4>Dr. <%= d.getName() %></h4>
                                <p><%= d.getSpecializationName() %> | $<%= d.getFees() %> per visit</p>
                            </div>
                        </div>
                        
                        <form action="../appointment" method="post">
                            <input type="hidden" name="action" value="book">
                            <input type="hidden" name="patientId" value="${userObj.id}">
                            <input type="hidden" name="doctorId" value="<%= d.getId() %>">

                            <% if(availabilityList.isEmpty()) { %>
                                <div class="alert alert-warning">
                                    <i class="fa-solid fa-triangle-exclamation"></i> 
                                    This doctor hasn't defined their working hours. Please contact them or try another doctor.
                                </div>
                            <% } else { %>
                                <div class="form-group">
                                    <label class="form-label">Choose an Appointment Slot</label>
                                    <select class="form-select" name="slotDetails" id="slotDetails" required onchange="updateHiddenFields()">
                                        <option value="">-- Select Date & Time --</option>
                                        <%
                                            java.time.LocalDate today = java.time.LocalDate.now();
                                            java.time.format.DateTimeFormatter dateFormatter = java.time.format.DateTimeFormatter.ofPattern("EEE, MMM dd");
                                            java.time.format.DateTimeFormatter timeFormatter = java.time.format.DateTimeFormatter.ofPattern("hh:mm a");
                                            
                                            com.doctorbooking.dao.AppointmentDao apptDao = new com.doctorbooking.dao.AppointmentDao();

                                            // Deduplicate availability records by Day, Start, End
                                            java.util.Map<String, com.doctorbooking.model.Availability> uniqueAv = new java.util.LinkedHashMap<>();
                                            for(com.doctorbooking.model.Availability av : availabilityList) {
                                                String key = av.getDayOfWeek() + "|" + av.getStartTime() + "|" + av.getEndTime();
                                                uniqueAv.put(key, av);
                                            }
                                            java.util.Collection<com.doctorbooking.model.Availability> filteredAv = uniqueAv.values();

                                            boolean slotsFound = false;
                                            for (int i = 0; i < 7; i++) {
                                                java.time.LocalDate date = today.plusDays(i);
                                                String dayTitle = date.getDayOfWeek().toString().substring(0, 1) + date.getDayOfWeek().toString().substring(1).toLowerCase();
                                                
                                                for (com.doctorbooking.model.Availability av : filteredAv) {
                                                    if (av.getDayOfWeek().equalsIgnoreCase(dayTitle)) {
                                                        // Check capacity (60 per schedule)
                                                        String startTime = av.getStartTime();
                                                        int bookedCount = apptDao.countBySlot(id, date.toString(), startTime);
                                                        
                                                        if (bookedCount < 60) {
                                                            slotsFound = true;
                                                            String displayDate = date.format(dateFormatter);
                                                            java.time.LocalTime startT = java.time.LocalTime.parse(startTime);
                                                            java.time.LocalTime endT = java.time.LocalTime.parse(av.getEndTime());
                                                            String displayRange = startT.format(timeFormatter).toLowerCase() + " - " + endT.format(timeFormatter).toLowerCase();
                                                            String val = date.toString() + "|" + startTime;
                                                            %>
                                                            <option value="<%= val %>"><%= displayDate %> (<%= displayRange %>) - <%= (60 - bookedCount) %> left</option>
                                                            <%
                                                        }
                                                    }
                                                }
                                            }
                                            if(!slotsFound) {
                                                %><option value="" disabled>No slots available for the next 14 days</option><%
                                            }
                                        %>
                                    </select>
                                </div>

                                <input type="hidden" name="appointmentDate" id="finalDate">
                                <input type="hidden" name="appointmentTime" id="finalTime">

                                <button type="submit" class="btn btn-primary w-100" style="margin-top: 20px;">
                                    <i class="fa-solid fa-check-circle"></i> Confirm Booking
                                </button>
                            <% } %>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </main>
</div>

<script>
    function updateHiddenFields() {
        var select = document.getElementById("slotDetails");
        var val = select.value;
        if(val) {
            var parts = val.split("|");
            document.getElementById("finalDate").value = parts[0];
            document.getElementById("finalTime").value = parts[1];
        }
    }
</script>

</body>
</html>
