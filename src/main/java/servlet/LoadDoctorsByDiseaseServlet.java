package servlet;

import dao.DoctorDAO;
import dao.DBConnect;
import model.Doctor;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

public class LoadDoctorsByDiseaseServlet extends HttpServlet {

    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        int diseaseId = Integer.parseInt(req.getParameter("diseaseId"));

        DoctorDAO dao = new DoctorDAO(DBConnect.getConn());
        List<Doctor> list = dao.getDoctorsByDisease(diseaseId);

        resp.setContentType("text/html");
        PrintWriter out = resp.getWriter();

        out.println("<option value=''>Select Doctor</option>");

        for (Doctor d : list) {
            out.println("<option value='" + d.getId() + "'>" +"Dr. "+
                        d.getName() + "</option>");
        }
    }
}
