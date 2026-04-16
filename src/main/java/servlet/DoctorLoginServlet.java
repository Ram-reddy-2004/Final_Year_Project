package servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import dao.DBConnect;
import dao.DoctorDAO;
import model.Doctor;

public class DoctorLoginServlet extends HttpServlet {

    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest req, HttpServletResponse resp)
	        throws ServletException, IOException {

	    String email = req.getParameter("email");
	    String password = req.getParameter("password");

	    DoctorDAO dao = new DoctorDAO(DBConnect.getConn());

	    // 🔍 Check doctor existence
	    Doctor doctorByEmail = dao.getDoctorByEmail(email);

	    if (doctorByEmail == null) {
	        resp.sendRedirect("doctorLogin.jsp?error=no_doctor");
	        return;
	    }

	    // 🔐 Validate password
	    Doctor doctor = dao.login(email, password);

	    if (doctor == null) {
	        resp.sendRedirect("doctorLogin.jsp?error=invalid");
	        return;
	    }

	    // ✅ SUCCESS
	    HttpSession session = req.getSession();
	    session.setAttribute("doctor", doctor);
	    resp.sendRedirect("doctorDashboard.jsp");
	}


}
