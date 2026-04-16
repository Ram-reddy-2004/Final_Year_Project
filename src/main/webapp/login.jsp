<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
    String error = (String) session.getAttribute("loginError");
    if (error != null) {
%>
<script>
    alert("<%= error %>");
</script>
<%
        session.removeAttribute("loginError"); // 🔥 VERY IMPORTANT
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>User Login</title>
    <link rel="stylesheet" href="style.css">
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
    <script src="app.js"></script>
    
    
    <style>
        /* Center container */
        body {
            margin: 0;
            height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            background: #EBF4DD;
            font-family: 'Poppins', sans-serif;
        }

        .login-container {
            width: 380px;
            background: #ffffff;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 15px 30px rgba(0,0,0,0.15);
        }

        h2 {
            text-align: center;
            color:#5A7863;
            margin-bottom: 20px;
        }

        .field {
            position: relative;
            margin-bottom: 18px;
        }

        .field i {
            position: absolute;
            top: 12px;
            left: 10px;
            color: #5A7863;
        }

        .field input {
            width: 100%;
            padding: 12px 12px 12px 40px;
            border-radius: 8px;
            border: 1px solid #ccc;
            font-size: 14px;
            transition: 0.3s;
        }

        .field input.error {
            border: 2px solid red;
        }

        .tooltip {
            display: none;
            font-size: 12px;
            color: red;
            margin-top: 4px;
        }

        button {
            width: 100%;
            padding: 12px;
            background: #3B4953;
            border: none;
            color: white;
            font-size: 15px;
            border-radius: 8px;
            cursor: pointer;
        }

        button:hover {
            background: #084298;
        }
        .login-error {
		    margin-top: 12px;
		    padding: 10px;
		    background-color: #fff3cd;
		    color: #856404;
		    border-radius: 8px;
		    font-size: 14px;
		    text-align: center;
		}

		.register-link {
		    display: inline-block;
		    margin-left: 6px;
		    color: #2f6f67;
		    font-weight: 600;
		    text-decoration: none;
		}
		
		.register-link:hover {
		    text-decoration: underline;
		}
        
    </style>

    <!-- JS -->
    <script>
        function validateLogin() {
            let email = document.getElementById("email");
            let password = document.getElementById("password");

            let emailTip = document.getElementById("emailTip");
            let passTip = document.getElementById("passTip");

            let valid = true;

            // Email validation
            if (email.value.trim() === "") {
                email.classList.add("error");
                emailTip.style.display = "block";
                valid = false;
            } else {
                email.classList.remove("error");
                emailTip.style.display = "none";
            }

            // Password validation
            if (password.value.trim() === "") {
                password.classList.add("error");
                passTip.style.display = "block";
                valid = false;
            } else {
                password.classList.remove("error");
                passTip.style.display = "none";
            }

            if (!valid) {
                alert("⚠️ Please fill all required fields");
            }

            return valid; // false stops navigation
        }
    </script>
</head>
<body>

<div class="login-container">
    <h2>User Login</h2>

    <form action="UserLoginServlet" method="post" onsubmit="return validateLogin();">

        <div class="field">
            <i class="material-icons">email</i>
            <input type="email" id="email" name="email" placeholder="Email">
            <div class="tooltip" id="emailTip">Email is required</div>
        </div>

        <div class="field">
            <i class="material-icons">lock</i>
            <input type="password" id="password" name="password" placeholder="Password">
            <div class="tooltip" id="passTip">Password is required</div>
        </div>

        <button type="submit">Login</button>
    </form>
    <%
    String errormsg = request.getParameter("error");
%>

<% if ("invalid".equals(errormsg)) { %>
    <div class="login-error">
        ❌ Invalid email or password
    </div>
<% } %>

<% if ("no_user".equals(errormsg)) { %>
    <div class="login-error">
        ⚠ No user found.
        <a href="register.jsp" class="register-link">
            Create a new account
        </a>
    </div>
<% } %>
    
</div>

</script>


</body>

</html>
