package dao;

import java.sql.*;
import model.User;
import org.mindrot.jbcrypt.BCrypt;

public class UserDAO {

    private Connection conn;

    public UserDAO(Connection conn) {
        this.conn = conn;
    }

    // Register User
    public boolean register(User u) {

        try {

            String sql = "INSERT INTO users(name,email,password,mobile) VALUES (?,?,?,?)";
            PreparedStatement ps = conn.prepareStatement(sql);

            // Encrypt password
            String hashedPassword = BCrypt.hashpw(u.getPassword(), BCrypt.gensalt());

            ps.setString(1, u.getName());
            ps.setString(2, u.getEmail());
            ps.setString(3, hashedPassword);
            ps.setString(4, u.getMobile());

            return ps.executeUpdate() == 1;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    // Login User
    public User login(String email, String password) {

        try {

            String sql = "SELECT * FROM users WHERE email=?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, email);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                String storedPassword = rs.getString("password");

                // Check encrypted password
                if (BCrypt.checkpw(password, storedPassword)) {

                    User u = new User();
                    u.setId(rs.getInt("id"));
                    u.setName(rs.getString("name"));
                    u.setEmail(rs.getString("email"));

                    return u;
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    // Get user by email
    public User getUserByEmail(String email) {

        User u = null;

        try {

            String sql = "SELECT * FROM users WHERE email=?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, email);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                u = new User();
                u.setId(rs.getInt("id"));
                u.setName(rs.getString("name"));
                u.setEmail(rs.getString("email"));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return u;
    }
}