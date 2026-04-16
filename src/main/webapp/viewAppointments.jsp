<%@ page import="java.util.*,dao.*,model.*" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    AppointmentDAO dao = new AppointmentDAO(DBConnect.getConn());
    List<Appointment> list = dao.getUserAppointments(user.getId());
%>

<!DOCTYPE html>
<html>
<head>
    <title>My Appointments</title>
    <link rel="stylesheet" href="appoint.css">
    <script src="app.js" defer></script>
</head>
<body>

<h2 class="page-title">My Appointments</h2>

<div class="appointment-wrapper">
    <div class="appointment-row">

    <% if (list == null || list.isEmpty()) { %>
        <p style="text-align:center;">No appointments booked yet.</p>
    <% } else { %>

        <% for (Appointment a : list) { %>

        <%
            // ---- TIME FORMAT SAFE ----
            String time24 = a.getTime();
            if (time24 != null && time24.length() >= 5)
                time24 = time24.substring(0, 5);

            String[] parts = time24.split(":");
            int hour = Integer.parseInt(parts[0]);
            String minute = parts[1];

            String ampm = "AM";
            int displayHour = hour;

            if (hour == 0) {
                displayHour = 12;
            } else if (hour == 12) {
                ampm = "PM";
            } else if (hour > 12) {
                displayHour = hour - 12;
                ampm = "PM";
            }

            String dateTime = a.getDate() + "T" + time24;
        %>

        <div class="appointment-card"
             data-datetime="<%= dateTime %>"
             data-id="<%= a.getId() %>">

            <h3>Dr. <%= a.getDoctorName() %></h3>

            <p>
                <b>Disease:</b>
                <%= a.getDiseaseName() != null ? a.getDiseaseName() : "N/A" %>
            </p>

            <p>
                <b>Date & Time:</b>
                <%= a.getDate() %> at
                <%= displayHour %>:<%= minute %> <%= ampm %>
            </p>

            <span class="status scheduled">
                <%= a.getStatus() != null ? a.getStatus() : "Scheduled" %>
            </span>

            <div class="timer">Loading...</div>

            <button class="video-btn"
                    disabled
                    onclick="location.href='telemedicine.jsp'">
                Video Call Locked
            </button>

            <%
                ConsultationReportDAO rdao =
                    new ConsultationReportDAO(DBConnect.getConn());
                ConsultationReport r =
                    rdao.getByAppointmentId(a.getId());
            %>

            <% if (r != null) { %>
                <button class="review-btn"
                        onclick="location.href='viewReport.jsp?appointmentId=<%= a.getId() %>'">
                    View Report
                </button>
            <% } %>

        </div>

        <% } %> <%-- end for --%>
    <% } %> <%-- end else --%>

    </div>
</div>

</body>
</html>
