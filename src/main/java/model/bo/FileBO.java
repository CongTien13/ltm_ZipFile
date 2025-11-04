package model.bo;

import java.io.File;
import java.util.List;
import model.bean.UploadedFile;
import model.dao.FileDAO;

/**
 * Chứa các logic nghiệp vụ liên quan đến quản lý file.
 */
public class FileBO {
    
    private FileDAO fileDAO = new FileDAO();

    /**
     * Lấy danh sách file của một người dùng.
     * Đây là một ví dụ về pass-through đơn giản, vì không có logic phức tạp cần thêm.
     * @param userId ID của người dùng.
     * @return List các UploadedFile.
     */
    public List<UploadedFile> getFilesByUserId(int userId) {
        return fileDAO.getFilesByUserId(userId);
    }

    /**
     * Thêm thông tin file vào CSDL.
     * @param file đối tượng UploadedFile cần thêm.
     * @return true nếu thành công.
     */
    public boolean addFile(UploadedFile file) {
        // Có thể thêm logic kiểm tra loại file, dung lượng file ở đây
        return fileDAO.addFile(file);
    }

    /**
     * Xử lý logic xóa file.
     * Đây là một ví dụ điển hình của logic nghiệp vụ: kết hợp nhiều thao tác.
     * @param fileId ID của file cần xóa.
     * @param userId ID của người dùng đang thực hiện (để kiểm tra quyền).
     * @return true nếu xóa thành công cả trong CSDL và trên ổ cứng.
     */
    public boolean deleteFile(int fileId, int userId) {
        // Bước 1: Lấy thông tin file từ CSDL để biết đường dẫn và kiểm tra quyền sở hữu
        UploadedFile fileToDelete = fileDAO.getFileById(fileId);
        
        // Bước 2: Kiểm tra xem file có tồn tại không và người dùng có phải là chủ sở hữu không
        if (fileToDelete == null || fileToDelete.getUserId() != userId) {
            return false; // Không tìm thấy file hoặc không có quyền xóa
        }
        
        // Bước 3: Xóa file vật lý trên server
        try {
            File physicalFile = new File(fileToDelete.getServerFilepath());
            if (physicalFile.exists()) {
                physicalFile.delete();
            }
        } catch (Exception e) {
            e.printStackTrace();
            // Có thể không cần return false ở đây nếu vẫn muốn xóa record trong DB
        }
        
        // Bước 4: Xóa bản ghi trong cơ sở dữ liệu
        return fileDAO.deleteFile(fileId);
    }
}