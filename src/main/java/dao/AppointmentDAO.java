package dao;

import java.sql.*;
import java.sql.Date;
import java.util.*;
import model.Appointment;

public class AppointmentDAO {

    private Connection conn;

    public AppointmentDAO(Connection conn) {
        this.conn = conn;
    }

    /* -------------------------------------------------
       BOOK APPOINTMENT
    ------------------------------------------------- */
    public boolean book(Appointment a) {
        boolean success = false;

        try {
            String sql =
                "INSERT INTO appointments (user_id, doctor_id, appointment_date, appointment_time, status) " +
                "VALUES (?, ?, ?, ?, 'Scheduled')";

            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setInt(1, a.getUserId());
            ps.setInt(2, a.getDoctorId());
            ps.setDate(3, Date.valueOf(a.getDate()));

            // 🔥 FIX TIME FORMAT
            String time = a.getTime();
            if (time.length() == 5) {  // HH:mm
                time = time + ":00";
            }
            ps.setTime(4, Time.valueOf(time));

            int rows = ps.executeUpdate();
            if (rows == 1) success = true;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return success;
    }

    /* -------------------------------------------------
       USER APPOINTMENTS
    ------------------------------------------------- */
    public List<Appointment> getUserAppointments(int userId) {

        List<Appointment> list = new ArrayList<>();

        try {
            String sql =
                "SELECT a.*, d.name AS doctor_name, dis.disease_name " +
                "FROM appointments a " +
                "JOIN doctors d ON a.doctor_id = d.id " +
                "JOIN diseases dis ON d.disease_id = dis.id " +
                "WHERE a.user_id = ? " +
                "ORDER BY a.appointment_date, a.appointment_time";

            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Appointment a = new Appointment();
                a.setId(rs.getInt("id"));
                a.setUserId(rs.getInt("user_id"));
                a.setDoctorId(rs.getInt("doctor_id"));
                a.setDate(rs.getString("appointment_date"));
                a.setTime(rs.getString("appointment_time"));
                a.setStatus(rs.getString("status"));
                a.setDoctorName(rs.getString("doctor_name"));
                a.setDiseaseName(rs.getString("disease_name"));

                list.add(a);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    /* -------------------------------------------------
       SAME USER SLOT CHECK
    ------------------------------------------------- */
    public Appointment getUserAppointmentAtSlot(int userId, String date, String time) {

        try {
            String sql =
                "SELECT d.name, a.appointment_time " +
                "FROM appointments a " +
                "JOIN doctors d ON a.doctor_id = d.id " +
                "WHERE a.user_id=? AND a.appointment_date=? AND a.appointment_time=?";

            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            ps.setDate(2, Date.valueOf(date));

            if (time.length() == 5) time += ":00";
            ps.setTime(3, Time.valueOf(time));

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Appointment a = new Appointment();
                a.setDoctorName(rs.getString("name"));
                a.setTime(rs.getString("appointment_time"));
                return a;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    /* -------------------------------------------------
       DOCTOR SLOT AVAILABILITY
    ------------------------------------------------- */
    public boolean isSlotAvailable(int doctorId, String date, String time) {

        try {
            String sql =
                "SELECT COUNT(*) FROM appointments " +
                "WHERE doctor_id=? AND appointment_date=? AND appointment_time=?";

            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, doctorId);
            ps.setDate(2, Date.valueOf(date));

            if (time.length() == 5) time += ":00";
            ps.setTime(3, Time.valueOf(time));

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) == 0;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /* -------------------------------------------------
       GET DOCTOR NAME
    ------------------------------------------------- */
    public String getDoctorNameById(int doctorId) {

        String name = null;

        try {
            String sql = "SELECT name FROM doctors WHERE id=?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, doctorId);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                name = rs.getString("name");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return name;
    }
    /* -------------------------------------------------
    DOCTOR DASHBOARD APPOINTMENTS
 ------------------------------------------------- */
    /* -------------------------------------------------
    DOCTOR DASHBOARD APPOINTMENTS (FIXED)
 ------------------------------------------------- */
 public List<Appointment> getDoctorAppointments(int doctorId) {

     List<Appointment> list = new ArrayList<>();

     try {
         String sql =
             "SELECT a.id, a.user_id, a.doctor_id, " +
             "a.appointment_date, a.appointment_time, a.status, " +
             "u.name AS patient " +
             "FROM appointments a " +
             "JOIN users u ON a.user_id = u.id " +
             "WHERE a.doctor_id = ? " +
             "ORDER BY a.appointment_date, a.appointment_time";

         PreparedStatement ps = conn.prepareStatement(sql);
         ps.setInt(1, doctorId);

         ResultSet rs = ps.executeQuery();

         while (rs.next()) {
             Appointment a = new Appointment();
             a.setId(rs.getInt("id"));
             a.setUserId(rs.getInt("user_id"));
             a.setDoctorId(rs.getInt("doctor_id"));
             a.setPatientName(rs.getString("patient"));
             a.setDate(rs.getString("appointment_date"));
             a.setTime(rs.getString("appointment_time"));
             a.setStatus(rs.getString("status"));

             list.add(a);
         }

     } catch (Exception e) {
         e.printStackTrace(); // IMPORTANT FOR DEBUG
     }

     return list;
 }
 
 /* -------------------------------------------------
 getAppointments to add review
------------------------------------------------- */
 public Appointment getAppointmentById(int appointmentId) {

	    Appointment a = null;

	    try {
	        String sql =
	            "SELECT a.id, a.appointment_date, a.appointment_time, a.status, " +
	            "u.name AS patient_name, d.name AS doctor_name, dis.disease_name " +
	            "FROM appointments a " +
	            "JOIN users u ON a.user_id = u.id " +
	            "JOIN doctors d ON a.doctor_id = d.id " +
	            "JOIN diseases dis ON d.disease_id = dis.id " +
	            "WHERE a.id = ?";

	        PreparedStatement ps = conn.prepareStatement(sql);
	        ps.setInt(1, appointmentId);

	        ResultSet rs = ps.executeQuery();

	        if (rs.next()) {
	            a = new Appointment();
	            a.setId(rs.getInt("id"));
	            a.setDate(rs.getString("appointment_date"));
	            a.setTime(rs.getString("appointment_time"));
	            a.setStatus(rs.getString("status"));
	            a.setPatientName(rs.getString("patient_name"));
	            a.setDoctorName(rs.getString("doctor_name"));
	            a.setDiseaseName(rs.getString("disease_name"));
	        }

	    } catch (Exception e) {
	        e.printStackTrace();
	    }

	    return a;
	}

    
    /* -------------------------------------------------
    COUNT APPOINTMENTS BY DOCTOR
 ------------------------------------------------- */
 public int getAppointmentCountByDoctor(int doctorId) {

     int count = 0;

     try {
         String sql = "SELECT COUNT(*) FROM appointments WHERE doctor_id=?";
         PreparedStatement ps = conn.prepareStatement(sql);
         ps.setInt(1, doctorId);

         ResultSet rs = ps.executeQuery();
         if (rs.next()) {
             count = rs.getInt(1);
         }

     } catch (Exception e) {
         e.printStackTrace();
     }
     return count;
 }

 /* -------------------------------------------------
 GET BOOKED SLOTS FOR A DOCTOR (HH:mm FORMAT)
------------------------------------------------- */
public Set<String> getBookedSlots(int doctorId, String date) {

  Set<String> set = new HashSet<>();

  try {
      String sql =
          "SELECT appointment_time FROM appointments " +
          "WHERE doctor_id=? AND appointment_date=?";

      PreparedStatement ps = conn.prepareStatement(sql);
      ps.setInt(1, doctorId);
      ps.setDate(2, Date.valueOf(date));

      ResultSet rs = ps.executeQuery();
      while (rs.next()) {

          String dbTime = rs.getString("appointment_time"); // HH:mm:ss

          // 🔥 NORMALIZE TO HH:mm
          if (dbTime != null && dbTime.length() >= 5) {
              set.add(dbTime.substring(0, 5));
          }
      }

  } catch (Exception e) {
      e.printStackTrace();
  }

  return set;
}

}
