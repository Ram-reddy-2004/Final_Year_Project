package dao;

import java.sql.*;
import java.util.*;
import model.Doctor;
import org.mindrot.jbcrypt.BCrypt;

public class DoctorDAO {

    private Connection conn;

    public DoctorDAO(Connection conn) {
        this.conn = conn;
    }

    // Add Doctor
    public boolean addDoctor(Doctor d) {

        try {

            String sql = "INSERT INTO doctors(name,speciality,disease_id,email,password) VALUES (?,?,?,?,?)";
            PreparedStatement ps = conn.prepareStatement(sql);

            // Encrypt password
            String hashedPassword = BCrypt.hashpw(d.getPassword(), BCrypt.gensalt());

            ps.setString(1, d.getName());
            ps.setString(2, d.getSpeciality());
            ps.setInt(3, d.getDiseaseId());
            ps.setString(4, d.getEmail());
            ps.setString(5, hashedPassword);

            return ps.executeUpdate() == 1;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    // Doctor Login
    public Doctor login(String email, String password) {

        try {

            String sql = "SELECT * FROM doctors WHERE email=?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, email);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                String storedPassword = rs.getString("password");

                if (BCrypt.checkpw(password, storedPassword)) {

                    Doctor d = new Doctor();
                    d.setId(rs.getInt("id"));
                    d.setName(rs.getString("name"));
                    d.setSpeciality(rs.getString("speciality"));
                    d.setDiseaseId(rs.getInt("disease_id"));
                    d.setEmail(rs.getString("email"));

                    return d;
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    // Get Doctors by Disease
    public List<Doctor> getDoctorsByDisease(int diseaseId) {

        List<Doctor> list = new ArrayList<>();

        try {

            String sql = "SELECT * FROM doctors WHERE disease_id=?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, diseaseId);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                Doctor d = new Doctor();
                d.setId(rs.getInt("id"));
                d.setName(rs.getString("name"));

                list.add(d);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // Get Doctor by Email
    public Doctor getDoctorByEmail(String email) {

        Doctor d = null;

        try {

            String sql = "SELECT * FROM doctors WHERE email=?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, email);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                d = new Doctor();
                d.setId(rs.getInt("id"));
                d.setName(rs.getString("name"));
                d.setEmail(rs.getString("email"));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return d;
    }
}