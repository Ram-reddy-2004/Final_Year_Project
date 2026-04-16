<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="dao.*,model.*,java.util.*" %>
<%
    DiseaseDAO ddao = new DiseaseDAO(DBConnect.getConn());
    List<Disease> diseases = ddao.getAllDiseases();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Doctor Registration</title>

    <!-- External CSS -->
    <link rel="stylesheet" href="style.css">
</head>

<body>

<div class="container">
    <h2>Doctor Registration</h2>

    <form action="DoctorRegisterServlet" method="post" onsubmit="return validateDoctorRegister()">

        <!-- Doctor Name -->
        <div class="field">
            <i class="material-icons">person</i>
            <input type="text" name="name" id="name" placeholder="Doctor Name">
            <div class="tooltip" id="nameTip">Doctor name is required</div>
        </div>

        <!-- Speciality -->
        <div class="field">
            <i class="material-icons">medical_services</i>
            <input type="text" name="speciality" id="speciality" placeholder="Speciality">
            <div class="tooltip" id="specTip">Speciality is required</div>
        </div>

        <!-- Disease -->
        <div class="field">
            <i class="material-icons">coronavirus</i>
            <select name="diseaseId" id="disease">
                <option value="">Select Disease</option>
                <% for (Disease d : diseases) { %>
                    <option value="<%= d.getId() %>">
                        <%= d.getDiseaseName() %>
                    </option>
                <% } %>
            </select>
            <div class="tooltip" id="diseaseTip">Please select disease</div>
        </div>

        <!-- Email -->
        <div class="field">
            <i class="material-icons">email</i>
            <input type="email" name="email" id="email" placeholder="Email">
            <div class="tooltip" id="emailTip">Email is required</div>
        </div>

        <!-- Password -->
        <div class="field">
            <i class="material-icons">lock</i>
            <input type="password" name="password" id="password" placeholder="Password">
            <div class="tooltip" id="passTip">Password is required</div>
        </div>

        <button type="submit" class="btn">Register Doctor</button>
    </form>
</div>

<!-- External JS -->
<script src="app.js"></script>

</body>
</html>