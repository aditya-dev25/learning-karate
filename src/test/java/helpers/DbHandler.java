package helpers;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Collections;
import java.util.HashMap;
import java.util.Map;

public class DbHandler {

    private static final String connectionUrl = "jdbc:mysql://mysql:3306/testdb";
    private static final String username = "testuser";
    private static final String password = "testpass";

    private static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(connectionUrl, username, password);
    }

    public static int addNewJobWithName(String jobDescription, int minLvl, int maxLvl) throws SQLException {
        String sql = "INSERT INTO jobs (job_description, min_lvl, max_lvl) VALUES (?, ?, ?)";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, jobDescription);
            stmt.setInt(2, minLvl);
            stmt.setInt(3, maxLvl);
            return stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
            return 0;
        }
    }

    public static Map<String, Object> getJobByDescription(String jobDescription) throws SQLException {
        String sql = "SELECT job_id, job_description, min_lvl, max_lvl FROM jobs WHERE job_description = ?";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, jobDescription);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Map<String, Object> result = new HashMap<>();
                    result.put("jobId", rs.getInt("job_id"));
                    result.put("jobDescription", rs.getString("job_description"));
                    result.put("minLvl", rs.getInt("min_lvl"));
                    result.put("maxLvl", rs.getInt("max_lvl"));
                    return result;
                }
            }
        }
        return Collections.emptyMap();
    }

    public static int updateMinMaxLvlByDescription(String jobDescription, int newMinLvl, int newMaxLvl) throws SQLException {
        String sql = "UPDATE jobs SET min_lvl = ?, max_lvl = ? WHERE job_description = ?";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, newMinLvl);
            stmt.setInt(2, newMaxLvl);
            stmt.setString(3, jobDescription);
            return stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
            return 0;
        }
    }

    public static int deleteJobByDescription(String jobDescription) throws SQLException {
        String sql = "DELETE FROM jobs WHERE job_description = ?";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, jobDescription);
            return stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
            return 0;
        }
    }
 }
