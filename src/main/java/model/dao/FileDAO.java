package model.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.bean.UploadedFile;

/**
 * Lớp này chứa các phương thức truy vấn liên quan đến bảng 'uploaded_files'.
 */
public class FileDAO {

    /**
     * Thêm một bản ghi file mới vào cơ sở dữ liệu.
     * @param file đối tượng UploadedFile chứa thông tin cần lưu.
     * @return true nếu thêm thành công, false nếu thất bại.
     */
    public boolean addFile(UploadedFile file) {
        String sql = "INSERT INTO uploaded_files (user_id, original_filename, server_filepath) VALUES (?, ?, ?)";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, file.getUserId());
            ps.setString(2, file.getOriginalFilename());
            ps.setString(3, file.getServerFilepath());
            
            return ps.executeUpdate() > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Lấy danh sách tất cả các file của một người dùng cụ thể.
     * @param userId ID của người dùng.
     * @return một List các đối tượng UploadedFile.
     */
    public List<UploadedFile> getFilesByUserId(int userId) {
        List<UploadedFile> fileList = new ArrayList<>();
        String sql = "SELECT * FROM uploaded_files WHERE user_id = ? ORDER BY upload_date DESC";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
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
    
    /**
     * Lấy thông tin một file dựa trên ID của nó.
     * @param fileId ID của file cần lấy.
     * @return đối tượng UploadedFile hoặc null nếu không tìm thấy.
     */
    public UploadedFile getFileById(int fileId) {
        String sql = "SELECT * FROM uploaded_files WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, fileId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                UploadedFile file = new UploadedFile();
                file.setId(rs.getInt("id"));
                file.setUserId(rs.getInt("user_id"));
                file.setOriginalFilename(rs.getString("original_filename"));
                file.setServerFilepath(rs.getString("server_filepath"));
                file.setUploadDate(rs.getTimestamp("upload_date"));
                return file;
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Xóa một file khỏi cơ sở dữ liệu dựa trên ID của nó.
     * @param fileId ID của file cần xóa.
     * @return true nếu xóa thành công, false nếu thất bại.
     */
    public boolean deleteFile(int fileId) {
        String sql = "DELETE FROM uploaded_files WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, fileId);
            return ps.executeUpdate() > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}