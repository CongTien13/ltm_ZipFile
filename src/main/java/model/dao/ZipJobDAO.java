package model.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import model.bean.UploadedFile;
import model.bean.ZipJob;

/**
 * Lớp này chứa các phương thức truy vấn liên quan đến bảng 'zip_jobs'.
 */
public class ZipJobDAO {

    /**
     * Tạo một tác vụ nén mới trong CSDL với trạng thái 'PENDING'.
     * @param userId ID của người dùng yêu cầu tác vụ.
     * @return ID của job vừa được tạo, hoặc -1 nếu có lỗi.
     */
    public int createJob(int userId) {
        String sql = "INSERT INTO zip_jobs (user_id) VALUES (?)";
        try (Connection conn = DatabaseConnection.getConnection();
             // Thêm Statement.RETURN_GENERATED_KEYS để lấy lại ID tự tăng
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            ps.setInt(1, userId);
            
            int affectedRows = ps.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        return generatedKeys.getInt(1); // Trả về ID của job mới
                    }
                }
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1; // Trả về -1 nếu có lỗi
    }

    /**
     * Lấy danh sách lịch sử các tác vụ nén của một người dùng.
     * @param userId ID của người dùng.
     * @return một List các đối tượng ZipJob.
     */
    public List<ZipJob> getJobsByUserId(int userId) {
        List<ZipJob> jobList = new ArrayList<>();
        String sql = "SELECT * FROM zip_jobs WHERE user_id = ? ORDER BY creation_date DESC";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                ZipJob job = new ZipJob();
                job.setId(rs.getInt("id"));
                job.setUserId(rs.getInt("user_id"));
                job.setStatus(rs.getString("status"));
                job.setCreationDate(rs.getTimestamp("creation_date"));
                job.setResultFilepath(rs.getString("result_filepath"));
                jobList.add(job);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return jobList;
    }
    
    /**
     * Cập nhật trạng thái và đường dẫn file kết quả cho một tác vụ.
     * Phương thức này sẽ được gọi bởi luồng xử lý ngầm (worker thread).
     * @param jobId ID của job cần cập nhật.
     * @param status Trạng thái mới (ví dụ: "COMPLETED", "FAILED").
     * @param resultPath Đường dẫn đến file ZIP kết quả (có thể là null nếu thất bại).
     * @return true nếu cập nhật thành công, false nếu thất bại.
     */
    public boolean updateJobStatusAndResult(int jobId, String status, String resultPath) {
        String sql = "UPDATE zip_jobs SET status = ?, result_filepath = ? WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, status);
            ps.setString(2, resultPath);
            ps.setInt(3, jobId);
            
            return ps.executeUpdate() > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Thêm danh sách các file ID vào một job cụ thể.
     * @param jobId ID của job.
     * @param fileIds Mảng các ID của file (dưới dạng String).
     */
    public void addFilesToJob(int jobId, String[] fileIds) {
        String sql = "INSERT INTO zip_job_details (job_id, file_id) VALUES (?, ?)";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            for (String fileIdStr : fileIds) {
                int fileId = Integer.parseInt(fileIdStr);
                ps.setInt(1, jobId);
                ps.setInt(2, fileId);
                ps.addBatch(); // Thêm lệnh vào một "lô" để thực thi cùng lúc
            }
            ps.executeBatch(); // Thực thi tất cả các lệnh trong lô
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    /**
     * Lấy danh sách các đối tượng UploadedFile cho một job cụ thể.
     * @param jobId ID của job.
     * @return List các UploadedFile.
     */
    public List<UploadedFile> getFilesForJob(int jobId) {
        List<UploadedFile> fileList = new ArrayList<>();
        // Dùng JOIN để lấy thông tin đầy đủ của file từ bảng uploaded_files
        String sql = "SELECT f.* FROM uploaded_files f " +
                     "JOIN zip_job_details d ON f.id = d.file_id " +
                     "WHERE d.job_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, jobId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                UploadedFile file = new UploadedFile();
                file.setId(rs.getInt("id"));
                file.setUserId(rs.getInt("user_id"));
                file.setOriginalFilename(rs.getString("original_filename"));
                file.setServerFilepath(rs.getString("server_filepath"));
                file.setUploadDate(rs.getTimestamp("upload_date"));
                fileList.add(file);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return fileList;
    }
}