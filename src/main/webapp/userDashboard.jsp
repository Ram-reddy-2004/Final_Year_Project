<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="model.User" %>
<%
User u = (User) session.getAttribute("user");
if (u == null) response.sendRedirect("login.jsp");
%>

<!DOCTYPE html>
<html>
<head>
<title>User Dashboard</title>
<link rel="stylesheet" href="style.css">
</head>
<body>

<div class="page">
<div class="container">

<h2>Welcome, <%= u.getName() %></h2>
<p>Your digital healthcare dashboard</p>

<button onclick="location.href='bookAppointment.jsp'">Book Appointment</button><br><br>
<button onclick="location.href='viewAppointments.jsp'">View Appointments</button><br><br>
<button onclick="location.href='telemedicine.jsp'">Telemedicine</button>

</div>
</div>

</body>
</html>