<%@ page import="dao.*,model.*" %>
<%
int appointmentId = Integer.parseInt(request.getParameter("appointmentId"));

ConsultationReport r = new ConsultationReport();
r.setAppointmentId(appointmentId);
r.setConsultInHospital(request.getParameter("consult"));
r.setMedicines(request.getParameter("medicines"));
r.setSuggestions(request.getParameter("suggestions"));

ConsultationReportDAO dao =
    new ConsultationReportDAO(DBConnect.getConn());

dao.saveReport(r);

response.sendRedirect("addReview.jsp?appointmentId=" +
    appointmentId + "&success=1");
%>
