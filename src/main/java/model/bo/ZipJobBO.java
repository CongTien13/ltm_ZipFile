package model.bo;

import java.util.List;
import model.bean.ZipJob;
import model.dao.ZipJobDAO;

/**
 * Chứa các logic nghiệp vụ liên quan đến tác vụ nén file.
 */
public class ZipJobBO {

    private ZipJobDAO zipJobDAO = new ZipJobDAO();

    /**
     * Tạo một tác vụ nén mới.
     * @param userId ID của người dùng.
     * @return ID của job mới được tạo.
     */
    public int createJob(int userId) {
        // Logic nghiệp vụ ở đây là tạo một bản ghi job trong CSDL.
        // Việc đưa job vào hàng đợi xử lý sẽ do một lớp khác (Worker/Listener) đảm nhiệm
        // hoặc có thể được khởi tạo ngay tại đây trong các thiết kế phức tạp hơn.
        return zipJobDAO.createJob(userId);
    }

    /**
     * Lấy lịch sử các tác vụ nén của người dùng.
     * @param userId ID của người dùng.
     * @return List các ZipJob.
     */
    public List<ZipJob> getJobsByUserId(int userId) {
        return zipJobDAO.getJobsByUserId(userId);
    }
    
    
    public int createJobWithDetails(int userId, String[] fileIds) {
        // Bước 1: Gọi DAO để tạo bản ghi job chính trong bảng 'zip_jobs'
        int jobId = zipJobDAO.createJob(userId);
        
        // Nếu việc tạo job chính thất bại, dừng lại ngay lập tức
        if (jobId == -1) {
            return -1;
        }
        
        // Bước 2: Nếu tạo job chính thành công, gọi DAO để thêm các file chi tiết
        // vào bảng 'zip_job_details'
        zipJobDAO.addFilesToJob(jobId, fileIds);
        
        // Bước 3: Trả về jobId để Controller có thể thêm vào hàng đợi
        return jobId;
    }
}