package model.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import model.bean.User;

/**
 * Lớp này chứa các phương thức truy vấn liên quan đến bảng 'users'.
 */
public class UserDAO {

    /**
     * Kiểm tra thông tin đăng nhập của người dùng.
     * @param username Tên đăng nhập.
     * @param password Mật khẩu.
     * @return một đối tượng User nếu đăng nhập thành công, ngược lại trả về null.
     */
    public User checkLogin(String username, String password) {
        String sql = "SELECT * FROM users WHERE username = ? AND password = ?";
        
        // Sử dụng try-with-resources để đảm bảo kết nối được đóng tự động
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            // Dùng PreparedStatement để tránh lỗi SQL Injection
            ps.setString(1, username);
            ps.setString(2, password);
            
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                User user = new User();
                user.setId(rs.getInt("id"));
                user.setUsername(rs.getString("username"));
                // Không lấy password ra để tăng tính bảo mật
                return user;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null; // Trả về null nếu không tìm thấy user hoặc có lỗi
    }

    /**
     * Thêm một người dùng mới vào cơ sở dữ liệu.
     * @param user Đối tượng User chứa thông tin cần thêm.
     * @return true nếu thêm thành công, false nếu thất bại.
     */
    public boolean createUser(User user) {
        String sql = "INSERT INTO users (username, password) VALUES (?, ?)";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, user.getUsername());
            ps.setString(2, user.getPassword());
            
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Kiểm tra xem một username đã tồn tại trong CSDL hay chưa.
     * @param username Tên đăng nhập cần kiểm tra.
     * @return true nếu đã tồn tại, false nếu chưa.
     */
    public boolean isUsernameExists(String username) {
        String sql = "SELECT id FROM users WHERE username = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();
            return rs.next(); // Nếu rs.next() là true, tức là có bản ghi -> username đã tồn tại
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}