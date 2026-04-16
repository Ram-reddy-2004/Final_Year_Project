package servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dao.DBConnect;
import dao.DoctorDAO;
import model.Doctor;

public class DoctorRegisterServlet extends HttpServlet {

    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        Doctor d = new Doctor();
        d.setName(req.getParameter("name"));
        d.setSpeciality(req.getParameter("speciality"));
        d.setDiseaseId(Integer.parseInt(req.getParameter("diseaseId")));
        d.setEmail(req.getParameter("email"));
        d.setPassword(req.getParameter("password"));

        DoctorDAO dao = new DoctorDAO(DBConnect.getConn());
        dao.addDoctor(d);

        resp.sendRedirect("doctorLogin.jsp");
    }
}
