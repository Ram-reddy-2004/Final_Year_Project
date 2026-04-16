<%@ page import="java.util.*,dao.*,model.*" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    DiseaseDAO ddao = new DiseaseDAO(DBConnect.getConn());
    List<Disease> diseases = ddao.getAllDiseases();

    String slotError = request.getParameter("slotError");
    String docName = request.getParameter("doctor");
    String errTime = request.getParameter("time");
%>

<!DOCTYPE html>
<html>
<head>
    <title>Book Appointment</title>
    <link rel="stylesheet" href="book.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
</head>

<body>

<div class="page-wrapper">

    <h2 class="page-title">Book Appointment</h2>

    <form class="form-card" action="BookAppointmentServlet" method="post">

        <input type="hidden" name="userId" value="<%= user.getId() %>">

        <!-- Disease -->
        <div class="form-group">
            <label>Disease</label>
            <select name="diseaseId" id="diseaseSelect" required
                    onchange="loadDoctors(this.value)">
                <option value="">Select Disease</option>
                <% for (Disease d : diseases) { %>
                    <option value="<%= d.getId() %>"><%= d.getDiseaseName() %></option>
                <% } %>
            </select>
        </div>

        <!-- Age -->
        <div class="form-group">
            <label>Age</label>
            <input type="number" name="age" min="1" max="120" required>
        </div>

        <!-- Gender -->
        <div class="form-group">
            <label>Gender</label>
            <select name="gender" required>
                <option value="">Select Gender</option>
                <option value="Male">Male</option>
                <option value="Female">Female</option>
                <option value="Other">Other</option>
            </select>
        </div>

        <!-- Doctor -->
        <div class="form-group">
            <label>Doctor</label>
            <select name="doctorId" id="doctorSelect" required
                    onchange="loadSlots()">
                <option value="">Select Doctor</option>
            </select>
        </div>

        <!-- Date -->
        <div class="form-group">
            <label>Appointment Date</label>

            <div class="calendar-wrapper">

                <div class="calendar-header">
                    <button type="button" class="nav-btn" onclick="changeMonth(-1)">
                        <span class="material-icons">chevron_left</span>
                    </button>
                    <span id="monthYear"></span>
                    <button type="button" class="nav-btn" onclick="changeMonth(1)">
                        <span class="material-icons">chevron_right</span>
                    </button>
                </div>

                <div class="weekdays">
                    <span>Sun</span>
                    <span>Mon</span>
                    <span>Tue</span>
                    <span>Wed</span>
                    <span>Thu</span>
                    <span>Fri</span>
                    <span>Sat</span>
                </div>

                <div class="calendar-grid" id="calendarGrid"></div>
            </div>

            <input type="hidden" name="date" id="appointmentDate" required>
        </div>

        <!-- Time Slot -->
        <div class="form-group">
            <label>Appointment Time</label>
            <select name="time" id="timeSelect"
                    class="<%= (slotError != null ? "slot-error" : "") %>"
                    required>
                <option value="">Select Time Slot</option>
            </select>
        </div>

        <button type="submit" class="primary-btn">
            Confirm Appointment
        </button>
    </form>

    <%
        String displayTime = errTime;
        if (errTime != null) {
            String[] parts = errTime.split(":");
            int hour = Integer.parseInt(parts[0]);
            String minute = parts[1];

            String ampm = (hour >= 12) ? "PM" : "AM";
            hour = hour % 12;
            if (hour == 0) hour = 12;

            displayTime = String.format("%02d:%s %s", hour, minute, ampm);
        }
    %>

    <% if ("1".equals(slotError)) { %>
        <div class="slot-message">
            You already have an appointment with
            <b>Dr. <%= docName %></b>
            at <b><%= displayTime %></b>.
            Please choose another time slot.
        </div>
    <% } %>

</div>

<!-- ================= JS (LOGIC FIX ONLY) ================= -->

<script>
/* 🔥 DEFINE ELEMENTS (MISSING IN ORIGINAL) */
const doctorSelect = document.getElementById("doctorSelect");
const timeSelect = document.getElementById("timeSelect");
const appointmentDate = document.getElementById("appointmentDate");

/* LOAD DOCTORS */
function loadDoctors(diseaseId) {
    fetch("LoadDoctorsByDiseaseServlet?diseaseId=" + diseaseId)
        .then(r => r.text())
        .then(d => {
            doctorSelect.innerHTML = d;
            timeSelect.innerHTML = "<option value=''>Select Time Slot</option>";
            timeSelect.disabled = true;
        });
}

/* LOAD SLOTS */
function loadSlots() {
    if (!doctorSelect.value || !appointmentDate.value) return;

    timeSelect.disabled = true;
    timeSelect.innerHTML = "<option>Loading...</option>";

    fetch("LoadAvailableSlotsServlet?doctorId=" + doctorSelect.value +
          "&date=" + appointmentDate.value)
        .then(r => r.text())
        .then(d => {
            timeSelect.innerHTML = d;
            timeSelect.disabled = d.includes("No slots");
        });
}

/* ===== CUSTOM CALENDAR (UNCHANGED) ===== */
const calendarGrid = document.getElementById("calendarGrid");
const monthYear = document.getElementById("monthYear");

const today = new Date(); today.setHours(0,0,0,0);
const maxDate = new Date(today); maxDate.setDate(today.getDate() + 15);

let currentMonth = today.getMonth();
let currentYear = today.getFullYear();

function formatDate(d) {
    return d.toISOString().split("T")[0];
}

function changeMonth(step) {
    currentMonth += step;
    if (currentMonth < 0) { currentMonth = 11; currentYear--; }
    if (currentMonth > 11) { currentMonth = 0; currentYear++; }
    renderCalendar();
}

function renderCalendar() {
    calendarGrid.innerHTML = "";
    const firstDay = new Date(currentYear, currentMonth, 1).getDay();
    const days = new Date(currentYear, currentMonth + 1, 0).getDate();

    monthYear.innerText =
        new Date(currentYear, currentMonth)
            .toLocaleString("default",{month:"long",year:"numeric"});

    for (let i=0;i<firstDay;i++)
        calendarGrid.appendChild(document.createElement("div"));

    for (let d=1; d<=days; d++) {
        const dateObj = new Date(currentYear, currentMonth, d);
        dateObj.setHours(0,0,0,0);

        const cell = document.createElement("div");
        cell.className = "calendar-day";
        cell.innerText = d;

        if (dateObj < today || dateObj > maxDate) {
            cell.classList.add("disabled");
        } else {
            cell.classList.add("active");
            cell.onclick = () => {
                document.querySelectorAll(".calendar-day")
                    .forEach(x => x.classList.remove("selected"));

                cell.classList.add("selected");
                appointmentDate.value = formatDate(dateObj);
                loadSlots();
            };
        }
        calendarGrid.appendChild(cell);
    }
}
renderCalendar();

/* 🔥 SUBMIT FIX (MOST IMPORTANT) */
document.querySelector("form").addEventListener("submit", function (e) {

    if (!appointmentDate.value) {
        alert("Please select appointment date");
        e.preventDefault();
        return;
    }

    if (!timeSelect.value) {
        alert("Please select appointment time");
        e.preventDefault();
        return;
    }

    // 🔥 ENABLE TIME BEFORE SUBMIT
    timeSelect.disabled = false;
});
</script>

</body>
</html>
