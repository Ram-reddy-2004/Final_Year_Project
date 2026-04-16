package dao;

import java.sql.*;
import java.util.*;
import model.Disease;

public class DiseaseDAO {
    private Connection conn;

    public DiseaseDAO(Connection conn) {
        this.conn = conn;
    }

    public List<Disease> getAllDiseases() {
        List<Disease> list = new ArrayList<>();
        try {
            String sql = "SELECT * FROM diseases";
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Disease d = new Disease();
                d.setId(rs.getInt("id"));
                d.setDiseaseName(rs.getString("disease_name"));
                list.add(d);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}
