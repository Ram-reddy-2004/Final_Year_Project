package servlet;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dao.AppointmentDAO;
import dao.DBConnect;
import model.Doctor;

public class DoctorDashboardServlet extends HttpServlet {

    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        Doctor doctor = (Doctor) req.getSession().getAttribute("doctor");

        if (doctor == null) {
            resp.sendRedirect("doctorLogin.jsp");
            return;
        }

        AppointmentDAO dao = new AppointmentDAO(DBConnect.getConn());
        int count = dao.getAppointmentCountByDoctor(doctor.getId());

        req.setAttribute("count", count);
        RequestDispatcher rd = req.getRequestDispatcher("doctorDashboard.jsp");
        rd.forward(req, resp);
    }
}
