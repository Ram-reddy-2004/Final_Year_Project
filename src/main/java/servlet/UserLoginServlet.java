package servlet;

import dao.DBConnect;
import dao.UserDAO;
import model.User;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;

public class UserLoginServlet extends HttpServlet {

    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest req, HttpServletResponse resp)
	        throws ServletException, IOException {

	    String email = req.getParameter("email");
	    String password = req.getParameter("password");

	    UserDAO dao = new UserDAO(DBConnect.getConn());

	    // 🔍 Check user by email first
	    User userByEmail = dao.getUserByEmail(email);

	    if (userByEmail == null) {
	        // ❌ No user found
	        resp.sendRedirect("login.jsp?error=no_user");
	        return;
	    }

	    // 🔐 Validate password
	    User user = dao.login(email, password);

	    if (user == null) {
	        // ❌ Wrong password
	        resp.sendRedirect("login.jsp?error=invalid");
	        return;
	    }

	    // ✅ SUCCESS
	    HttpSession session = req.getSession();
	    session.setAttribute("user", user);
	    resp.sendRedirect("userDashboard.jsp");
	}

}
