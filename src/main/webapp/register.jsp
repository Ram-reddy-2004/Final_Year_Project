<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>User Register</title>
    <link rel="stylesheet" href="style.css">
    <script src="app.js"></script>
</head>
<body>

<div class="container">
    <h2>User Registration</h2>

    <form id="regForm" action="UserRegisterServlet" method="post"
          onsubmit="return validateForm('regForm')">

        <div class="field">
            <i class="material-icons">person</i>
            <input type="text" name="name" placeholder="Enter your Full Name">
            <div class="tooltip">Name required</div>
        </div>

        <div class="field">
            <i class="material-icons">email</i>
            <input type="email" name="email" placeholder="Enter yor Email">
            <div class="tooltip">Email required</div>
        </div>

        <div class="field">
            <i class="material-icons">lock</i>
            <input type="password" name="password" placeholder="Create Password">
            <div class="tooltip">Password required</div>
        </div>

        <div class="field">
            <i class="material-icons">phone</i>
            <input type="text" name="mobile" placeholder="Enter Your Mobile number">
            <div class="tooltip">Mobile required</div>
        </div>

        <button>Register</button>
    </form>
</div>

</body>
</html>

