package model.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DatabaseConnection {
    private static final String serverName = "LAPTOP-QL9Q0H5Q";
    private static final String dbName = "web_ltm_db";
    private static final String portNumber = "3306";
    private static final String userID = "root";
    private static final String password = "123456";

    public static Connection getConnection() {
        Connection conn = null;
        try {
            String url = "jdbc:mysql://localhost:" + portNumber + "/" + dbName + "?useSSL=false&serverTimezone=UTC";
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(url, userID, password);
            System.out.println("Kết nối cơ sở dữ liệu thành công!");
        } catch (ClassNotFoundException e) {
            System.err.println("Không tìm thấy Driver JDBC MySQL!");
            e.printStackTrace();
        } catch (SQLException e) {
            System.err.println("Lỗi kết nối cơ sở dữ liệu!");
            e.printStackTrace();
        }
        return conn;
    }
}
