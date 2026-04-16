<!DOCTYPE html>
<html>
<head>
    <title>Hospital Appointment System</title>

    <!-- Google Icons -->
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">

    <link rel="stylesheet" href="index.css">
</head>
<body>

<div class="page">

    <!-- LEFT : IMAGE SLIDER + CONTENT -->
    <div class="left">

       

        <!-- OVERLAY CONTENT -->
        <div class="left-content">
            <h1 class="logo">HospitalCare</h1>

            <h2 class="headline">
                Quality Healthcare,<br>
                <span>Easy Appointments</span>
            </h2>

            <div class="features">
                <div class="feature-card">
                    <span class="material-icons">event_available</span>
                    <h4>Easy Booking</h4>
                    <p>Book appointments instantly</p>
                </div>

                <div class="feature-card">
                    <span class="material-icons">medical_services</span>
                    <h4>Expert Doctors</h4>
                    <p>Consult trusted specialists</p>
                </div>
            </div>
        </div>
    </div>

    <!-- RIGHT : LOGIN -->
    <div class="right">
        <div class="login-card">
            <h2>Login / Register</h2>
            <p>Continue to manage your appointments</p>

            <a href="login.jsp" class="btn primary">
                <span class="material-icons">person</span> User Login
            </a>

            <a href="register.jsp" class="btn outline">
                <span class="material-icons">person_add</span> User Register
            </a>

            <a href="doctorLogin.jsp" class="btn primary">
                <span class="material-icons">medical_services</span> Doctor Login
            </a>

            <a href="doctorRegister.jsp" class="btn outline">
                <span class="material-icons">local_hospital</span> Doctor Register
            </a>
        </div>
    </div>

</div>

</body>
</html>
