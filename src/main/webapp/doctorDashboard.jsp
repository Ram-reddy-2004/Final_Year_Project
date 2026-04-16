<%@ page import="java.util.*,dao.*,model.*" %>
<%
    Doctor doctor = (Doctor) session.getAttribute("doctor");
    if (doctor == null) {
        response.sendRedirect("doctorLogin.jsp");
        return;
    }
    
    ConsultationReportDAO rdao = new ConsultationReportDAO(DBConnect.getConn());


    AppointmentDAO dao = new AppointmentDAO(DBConnect.getConn());
    List<Appointment> list = dao.getDoctorAppointments(doctor.getId());
%>

<!DOCTYPE html>
<html>
<head>
    <title>Doctor Dashboard</title>
    <link rel="stylesheet" href="appoint.css">
    
<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet">
<link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
    <script src="app.js" defer></script>
</head>

<body>

<h2 class="page-title">Patient Appointments</h2>

<div class="appointment-wrapper">

    <% if (list == null || list.isEmpty()) { %>
        <p style="padding:20px; font-size:16px; color:#555;">
            <b>No appointments scheduled</b>
        </p>
    <% } else { %>

    <div class="appointment-row">

        <% for (Appointment a : list) {
            String dateTime = a.getDate() + "T" + a.getTime();
            String time24 = a.getTime();   // e.g. "14:30"
            String ampm = "AM";

            String[] parts = time24.split(":");
            int hour = Integer.parseInt(parts[0]);
            String minute = parts[1];

            int displayHour = hour;

            if (hour == 0) {
                displayHour = 12;
                ampm = "AM";
            } else if (hour == 12) {
                displayHour = 12;
                ampm = "PM";
            } else if (hour > 12) {
                displayHour = hour - 12;
                ampm = "PM";
            }
        %>

        <!-- APPOINTMENT CARD -->
        <div class="appointment-card" data-datetime="<%= dateTime %>">

            <h3>Patient: <%= a.getPatientName() %></h3>

            <p>
              <b>Date and Time:</b>
            <%= a.getDate() %> at
              <%= displayHour %>:<%= minute %> <%= ampm %>
              </p>


            <!-- STATUS (JS WILL UPDATE CLASS) -->
            <span class="status scheduled">Scheduled</span>

            <!-- TIMER (JS FILLS THIS) -->
            <div class="timer">Checking schedule...</div>
            
            <button class="video-btn"
        disabled
        onclick="location.href='telemedicine.jsp'">
    Video Call Locked
</button>
<%
    boolean reviewDone = rdao.isReviewSubmitted(a.getId());
%>

<% if (!reviewDone) { %>
    <button class="review-btn" style="display:none"
        onclick="location.href='addReview.jsp?appointmentId=<%= a.getId() %>'">
        Add Review
    </button>
<% } else { %>
    <div class="review-success">
        <span class="material-icons">check_circle</span>
        Review submitted successfully
    </div>
<% } %>






        </div>

        <% } %>

    </div>
    <% } %>

</div>

</body>
</html>
