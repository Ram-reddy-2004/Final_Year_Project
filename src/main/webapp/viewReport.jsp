<%@ page import="dao.*,model.*" %>

<%
int appointmentId =
Integer.parseInt(request.getParameter("appointmentId"));

AppointmentDAO adao =
new AppointmentDAO(DBConnect.getConn());

ConsultationReportDAO rdao =
new ConsultationReportDAO(DBConnect.getConn());

Appointment a = adao.getAppointmentById(appointmentId);

ConsultationReport r =
rdao.getByAppointmentId(appointmentId);

/* TIME CONVERSION */

String rawTime=a.getTime();

String displayTime="";

if(rawTime!=null){

String[] parts=rawTime.split(":");

int hour=Integer.parseInt(parts[0]);

int minute=Integer.parseInt(parts[1]);

String ampm=(hour>=12)?"PM":"AM";

hour=hour%12;

if(hour==0)
hour=12;

displayTime=hour+":"+
String.format("%02d",minute)+" "+ampm;

}
%>

<!DOCTYPE html>
<html>
<head>

<title>Consultation Report</title>

<link rel="stylesheet" href="report.css">

</head>

<body>

<div class="receipt">

<div class="report-header">

<img src="images/healthcare.jpg"
class="logo">

<div class="hospital-info">

<h1>Hospital System</h1>

<p>Multi-Speciality Healthcare Center</p>

<p>Contact: +91 98765 43210</p>

</div>

</div>

<h2>Medical Consultation Report</h2>

<p><b>Doctor:</b> Dr. <%=a.getDoctorName()%></p>

<p><b>Patient:</b> <%=a.getPatientName()%></p>

<p><b>Disease:</b> <%=a.getDiseaseName()%></p>

<p><b>Appointment:</b>
<%=a.getDate()%> at <%=displayTime%>
</p>

<hr>

<p><b>Consult in Hospital:</b>
<%=r.getConsultInHospital()%>
</p>

<p><b>Medicines:</b>
<%=r.getMedicines()%>
</p>

<p><b>Suggestions:</b>
<%=r.getSuggestions()%>
</p>

<br>

<button onclick="window.print()">
Download PDF
</button>

</div>

</body>
</html>