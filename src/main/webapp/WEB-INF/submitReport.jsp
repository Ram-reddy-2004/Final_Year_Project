<%@ page import="dao.*,model.*,java.sql.*" %>

<%
int appointmentId = Integer.parseInt(request.getParameter("appointmentId"));

ConsultationReport r = new ConsultationReport();
r.setAppointmentId(appointmentId);
r.setConsultInHospital(request.getParameter("consult"));
r.setMedicines(request.getParameter("medicines"));
r.setSuggestions(request.getParameter("suggestions"));

Connection conn = DBConnect.getConn();

/* SAVE REPORT */
ConsultationReportDAO dao = new ConsultationReportDAO(conn);
dao.saveReport(r);

/* UPDATE STATUS TO COMPLETED */
PreparedStatement ps = conn.prepareStatement(
"update appointments set status='Completed' where id=?"
);

ps.setInt(1, appointmentId);
ps.executeUpdate();

/* REDIRECT BACK */
response.sendRedirect("doctorAppointments.jsp?success=1");
%>