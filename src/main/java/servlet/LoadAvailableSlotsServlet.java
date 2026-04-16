package servlet;

import dao.AppointmentDAO;
import dao.DBConnect;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.*;

public class LoadAvailableSlotsServlet extends HttpServlet {

    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        int doctorId = Integer.parseInt(req.getParameter("doctorId"));
        String date = req.getParameter("date"); // yyyy-MM-dd

        AppointmentDAO dao = new AppointmentDAO(DBConnect.getConn());

        // 🔥 BOOKED SLOTS (NORMALIZED TO HH:mm IN DAO)
        Set<String> bookedSlots = dao.getBookedSlots(doctorId, date);

        /* ALL POSSIBLE SLOTS (KEY = HH:mm) */
        LinkedHashMap<String, String> allSlots = new LinkedHashMap<>();
        allSlots.put("10:00", "10:00 AM - 11:00 AM");
        allSlots.put("12:30", "12:30 PM - 01:30 PM");
        allSlots.put("14:30", "02:30 PM - 03:30 PM");
        allSlots.put("16:00", "04:00 PM - 05:00 PM");
        allSlots.put("21:32", "09:32 PM - 10:30 PM");
        allSlots.put("22:42", "10:42 PM - 10:30 PM");
        allSlots.put("20:17", "08:00 PM - 09:30 PM");
        allSlots.put("20:23", "08:23 PM - 10:30 PM");
        allSlots.put("22:25", "10:25 PM - 11:00 PM");
        allSlots.put("23:07", "11:07 PM - 11:59 PM");

        // Today & current time
        String today = new SimpleDateFormat("yyyy-MM-dd").format(new Date());
        String nowTime = new SimpleDateFormat("HH:mm").format(new Date());
        SimpleDateFormat timeFormat = new SimpleDateFormat("HH:mm");

        resp.setContentType("text/html");
        PrintWriter out = resp.getWriter();

        boolean hasSlot = false;
        out.println("<option value=''>Select Time Slot</option>");

        for (Map.Entry<String, String> entry : allSlots.entrySet()) {

            String slotTime = entry.getKey(); // HH:mm

            // ❌ SLOT ALREADY BOOKED BY ANY USER
            if (bookedSlots.contains(slotTime)) {
                continue;
            }

            // ❌ PAST TIME FOR TODAY
            try {
                if (date.equals(today) &&
                    timeFormat.parse(slotTime)
                              .before(timeFormat.parse(nowTime))) {
                    continue;
                }
            } catch (Exception e) {
                e.printStackTrace();
            }

            // ✅ AVAILABLE SLOT
            hasSlot = true;
            out.println(
                "<option value='" + slotTime + "'>" +
                entry.getValue() +
                "</option>"
            );
        }

        // ❌ NO SLOTS LEFT
        if (!hasSlot) {
            out.println("<option value=''>No slots available</option>");
        }
    }
}
