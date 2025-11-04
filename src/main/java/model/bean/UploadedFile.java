package model.bean;

import java.sql.Timestamp;

/**
 * Lớp này đại diện cho một file đã được người dùng tải lên,
 * tương ứng với bảng 'uploaded_files' trong CSDL.
 */
public class UploadedFile {

    private int id;
    private int userId;
    private String originalFilename;
    private String serverFilepath;
    private Timestamp uploadDate;

    // Constructor rỗng
    public UploadedFile() {
    }

    // Getters and Setters

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getOriginalFilename() {
        return originalFilename;
    }

    public void setOriginalFilename(String originalFilename) {
        this.originalFilename = originalFilename;
    }

    public String getServerFilepath() {
        return serverFilepath;
    }

    public void setServerFilepath(String serverFilepath) {
        this.serverFilepath = serverFilepath;
    }

    public Timestamp getUploadDate() {
        return uploadDate;
    }

    public void setUploadDate(Timestamp uploadDate) {
        this.uploadDate = uploadDate;
    }
}