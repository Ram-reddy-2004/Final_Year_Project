package dao;

import java.sql.*;
import model.ConsultationReport;

public class ConsultationReportDAO {

    private Connection conn;

    public ConsultationReportDAO(Connection conn) {
        this.conn = conn;
    }

    // SAVE REPORT
    public boolean saveReport(ConsultationReport r) {
        try {
            String sql =
              "INSERT INTO consultation_reports " +
              "(appointment_id, consult_in_hospital, medicines, suggestions) " +
              "VALUES (?,?,?,?)";

            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, r.getAppointmentId());
            ps.setString(2, r.getConsultInHospital());
            ps.setString(3, r.getMedicines());
            ps.setString(4, r.getSuggestions());

            return ps.executeUpdate() == 1;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // FETCH REPORT BY APPOINTMENT
    public ConsultationReport getByAppointmentId(int appointmentId) {
        try {
            String sql =
              "SELECT * FROM consultation_reports WHERE appointment_id=?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, appointmentId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                ConsultationReport r = new ConsultationReport();
                r.setConsultInHospital(rs.getString("consult_in_hospital"));
                r.setMedicines(rs.getString("medicines"));
                r.setSuggestions(rs.getString("suggestions"));
                return r;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public boolean isReviewSubmitted(int appointmentId) {
        boolean exists = false;
        try {
            String sql = "SELECT id FROM consultation_reports WHERE appointment_id=?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, appointmentId);
            ResultSet rs = ps.executeQuery();
            exists = rs.next();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return exists;
    }

}
