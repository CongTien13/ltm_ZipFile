package model.bean;

import java.sql.Timestamp;

/**
 * Lớp này đại diện cho một tác vụ nén file,
 * tương ứng với bảng 'zip_jobs' trong CSDL.
 */
public class ZipJob {

    private int id;
    private int userId;
    private String status; // Ví dụ: "PENDING", "PROCESSING", "COMPLETED", "FAILED"
    private Timestamp creationDate;
    private String resultFilepath; // Đường dẫn tới file ZIP sau khi nén xong

    // Constructor rỗng
    public ZipJob() {
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

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Timestamp getCreationDate() {
        return creationDate;
    }

    public void setCreationDate(Timestamp creationDate) {
        this.creationDate = creationDate;
    }

    public String getResultFilepath() {
        return resultFilepath;
    }

    public void setResultFilepath(String resultFilepath) {
        this.resultFilepath = resultFilepath;
    }
}