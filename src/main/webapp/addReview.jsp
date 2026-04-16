
<%@ page import="dao.*,model.*" %> 
<%
int appointmentId = Integer.parseInt(request.getParameter("appointmentId"));

AppointmentDAO adao = new AppointmentDAO(DBConnect.getConn());
Appointment a = adao.getAppointmentById(appointmentId);

if (a == null) {
    out.println("Invalid appointment");
    return;
}

/* Convert time to AM/PM */
String time24 = a.getTime();
String time12 = time24;

try {
    String[] parts = time24.split(":");
    int hour = Integer.parseInt(parts[0]);
    String min = parts[1];
    String ampm = (hour >= 12) ? "PM" : "AM";
    hour = hour % 12;
    if (hour == 0) hour = 12;
    time12 = hour + ":" + min + " " + ampm;
} catch(Exception e) {}
%>

<!DOCTYPE html>
<html>
<head>
<title>Add Review</title>

<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet">
<link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">

<link rel="stylesheet" href="review.css">
</head>
<body>

<div class="container">
<h2>Consultation Review</h2>

<!-- SHOW FORM ONLY WHEN NOT SUCCESS -->
<% if (!"1".equals(request.getParameter("success"))) { %>

<form action="saveReview.jsp" method="post">

<input type="hidden" name="appointmentId" value="<%= appointmentId %>">

<label>Patient</label>
<input value="<%= a.getPatientName() %>" readonly>

<label>Age</label>
<input value="<%= a.getAge() %>" readonly>

<label>Disease</label>
<input value="<%= a.getDiseaseName() %>" readonly>

<label>Date & Time</label>
<input value="<%= a.getDate() %> at <%= time12 %>" readonly>

<label>Consult in Hospital?</label>
<select name="consult">
    <option value="Yes">Yes</option>
    <option value="No">No</option>
</select>

<label>Medicines (comma separated)</label>
<textarea name="medicines"></textarea>

<label>Suggestions</label>
<textarea name="suggestions"></textarea>

<button type="submit">Submit Review</button>

</form>

<% } %>

<!-- SUCCESS MESSAGE + REFILL -->
<% if ("1".equals(request.getParameter("success"))) { %>

<div class="success-box">
    <span class="material-icons success-icon">check_circle</span>
    <h3>Review Submitted</h3>
    <p>The consultation report has been saved successfully.</p>

    <!-- REFILL FORM BUTTON -->
    <a href="addReview.jsp?appointmentId=<%= appointmentId %>" class="refill-btn">
        Add Another Review
    </a>
</div>

<% } %>

</div>
<div class="back-wrapper">
    <a href="doctorDashboard.jsp" class="back-btn">
        Back to Dashboard
    </a>
</div>


</body>
</html>
