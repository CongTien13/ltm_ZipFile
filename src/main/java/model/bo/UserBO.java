package model.bo;

import model.bean.User;
import model.dao.UserDAO;

/**
 * Chứa các logic nghiệp vụ liên quan đến người dùng.
 */
public class UserBO {
    
    private UserDAO userDAO = new UserDAO();

    /**
     * Kiểm tra thông tin đăng nhập.
     * @param username Tên đăng nhập.
     * @param password Mật khẩu.
     * @return Đối tượng User nếu hợp lệ, ngược lại trả về null.
     */
    public User checkLogin(String username, String password) {
        // Có thể thêm logic kiểm tra validation ở đây
        if (username == null || username.trim().isEmpty() || password == null || password.isEmpty()) {
            return null;
        }
        return userDAO.checkLogin(username, password);
    }

    /**
     * Xử lý logic đăng ký người dùng mới.
     * @param username Tên đăng nhập.
     * @param password Mật khẩu.
     * @param confirmPassword Mật khẩu xác nhận.
     * @return String biểu thị kết quả: "SUCCESS", "USERNAME_EXISTS", "PASSWORD_MISMATCH", "INVALID_INFO".
     */
    public String createUser(String username, String password, String confirmPassword) {
        // 1. Kiểm tra validation cơ bản
        if (username == null || username.trim().isEmpty() || password == null || password.isEmpty()) {
            return "INVALID_INFO";
        }
        
        // 2. Kiểm tra mật khẩu có khớp không
        if (!password.equals(confirmPassword)) {
            return "PASSWORD_MISMATCH";
        }
        
        // 3. Kiểm tra xem username đã tồn tại chưa (gọi xuống DAO)
        if (userDAO.isUsernameExists(username)) {
            return "USERNAME_EXISTS";
        }
        
        // 4. Nếu mọi thứ hợp lệ, tạo đối tượng User và gọi DAO để lưu
        User newUser = new User();
        newUser.setUsername(username);
        newUser.setPassword(password); // Trong thực tế nên mã hóa mật khẩu trước khi lưu
        
        if (userDAO.createUser(newUser)) {
            return "SUCCESS";
        } else {
            return "DATABASE_ERROR"; // Lỗi không xác định khi lưu
        }
    }
}