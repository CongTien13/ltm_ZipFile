package model.bean;

import java.io.Serializable;

/**
 * Lớp này đại diện cho đối tượng User, tương ứng với bảng 'users' trong CSDL.
 * Serializable được implement để có thể lưu đối tượng này vào Session.
 */
public class User implements Serializable {

    private static final long serialVersionUID = 1L; // Cần thiết cho Serializable

    private int id;
    private String username;
    private String password;

    // Constructor rỗng
    public User() {
    }

    // Getters and Setters
    // Eclipse có thể tự động tạo các hàm này cho bạn:
    // Chuột phải -> Source -> Generate Getters and Setters...

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }
}