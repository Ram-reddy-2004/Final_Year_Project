package servlet;

import java.io.IOException;
import java.net.URLEncoder;
import javax.servlet.*;
import javax.servlet.http.*;

import dao.AppointmentDAO;
import dao.DBConnect;
import model.Appointment;

public class BookAppointmentServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        int userId = Integer.parseInt(req.getParameter("userId"));
        int doctorId = Integer.parseInt(req.getParameter("doctorId"));
        int age = Integer.parseInt(req.getParameter("age"));
        String gender = req.getParameter("gender");
        String date = req.getParameter("date");
        String time = req.getParameter("time");

        AppointmentDAO dao = new AppointmentDAO(DBConnect.getConn());

        // 1️⃣ SAME USER SLOT CHECK
        Appointment existing = dao.getUserAppointmentAtSlot(userId, date, time);
        if (existing != null) {
            resp.sendRedirect(
                "bookAppointment.jsp?slotError=1" +
                "&doctor=" + URLEncoder.encode(existing.getDoctorName(), "UTF-8") +
                "&time=" + URLEncoder.encode(time, "UTF-8")
            );
            return;
        }

        // 2️⃣ DOCTOR SLOT CHECK
        if (!dao.isSlotAvailable(doctorId, date, time)) {

            String doctorName = dao.getDoctorNameById(doctorId);

            resp.sendRedirect(
                "bookAppointment.jsp?slotError=1" +
                "&doctor=" + URLEncoder.encode(doctorName, "UTF-8") +
                "&time=" + URLEncoder.encode(time, "UTF-8")
            );
            return;
        }

        // 3️⃣ BOOK APPOINTMENT
        Appointment a = new Appointment();
        a.setUserId(userId);
        a.setDoctorId(doctorId);
        a.setAge(age);
        a.setGender(gender);
        a.setDate(date);
        a.setTime(time);

        boolean booked = dao.book(a);

        // 4️⃣ RESULT
        if (booked) {
            resp.sendRedirect("viewAppointments.jsp");
        } else {
            resp.sendRedirect("bookAppointment.jsp?error=1");
        }
    }
}
