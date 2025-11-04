package model.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * Lớp tiện ích để quản lý việc kết nối đến cơ sở dữ liệu.
 */
public class DatabaseConnection {
    // Thông tin kết nối cho XAMPP mặc định
    private static final String JDBC_URL = "jdbc:mysql://localhost:3306/web_ltm_db";
    private static final String JDBC_USER = "root";
    private static final String JDBC_PASSWORD = ""; // Mật khẩu rỗng

    /**
     * Phương thức tĩnh để lấy một kết nối đến CSDL.
     * @return một đối tượng Connection hoặc null nếu có lỗi.
     */
    public static Connection getConnection() {
        Connection connection = null;
        try {
            // Nạp driver MySQL Connector/J
            Class.forName("com.mysql.cj.jdbc.Driver");
            // Thực hiện kết nối
            connection = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASSWORD);
        } catch (ClassNotFoundException | SQLException e) {
            // In ra lỗi nếu có vấn đề xảy ra
            e.printStackTrace();
        }
        return connection;
    }
}