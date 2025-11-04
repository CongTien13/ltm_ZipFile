package controller;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import model.bean.User;
import model.bean.ZipJob;
import model.dao.ZipJobDAO; // Tạm thời dùng DAO để lấy thông tin job

/**
 * Servlet này xử lý việc tải xuống file ZIP đã được nén.
 */
@WebServlet("/DownloadServlet") // Map URL với Servlet
public class DownloadServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        // --- BƯỚC 1: XÁC THỰC VÀ LẤY THÔNG TIN ---
        
        // Kiểm tra xem người dùng đã đăng nhập chưa
        if (user == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Bạn cần đăng nhập để thực hiện chức năng này.");
            return;
        }

        String jobIdStr = request.getParameter("jobId");
        if (jobIdStr == null || jobIdStr.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Thiếu Job ID.");
            return;
        }

        int jobId = Integer.parseInt(jobIdStr);
        ZipJobDAO zipJobDAO = new ZipJobDAO(); // Nên dùng BO, nhưng tạm dùng DAO cho nhanh
        
        // Lấy thông tin job từ CSDL để biết đường dẫn file
        // TODO: Cần có phương thức getJobById trong DAO
        // Tạm thời dùng lại phương thức getJobsByUserId và lọc ra
        ZipJob jobToDownload = null;
        for (ZipJob job : zipJobDAO.getJobsByUserId(user.getId())) {
            if (job.getId() == jobId) {
                jobToDownload = job;
                break;
            }
        }

        if (jobToDownload == null || !"COMPLETED".equals(jobToDownload.getStatus())) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy tác vụ hoặc tác vụ chưa hoàn thành.");
            return;
        }
        
        // --- BƯỚC 2: KIỂM TRA FILE VẬT LÝ ---
        
        String filePath = jobToDownload.getResultFilepath();
        File downloadFile = new File(filePath);
        
        if (!downloadFile.exists()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "File vật lý không còn tồn tại trên server.");
            return;
        }
        
        // --- BƯỚC 3: THIẾT LẬP HTTP HEADERS VÀ GỬI FILE ---

        // Lấy kiểu MIME của file (ở đây là zip)
        String mimeType = "application/zip";
        response.setContentType(mimeType);
        
        // Lấy kích thước file
        response.setContentLengthLong(downloadFile.length());

        // Thiết lập header quan trọng nhất: "Content-Disposition"
        // "attachment" sẽ báo cho trình duyệt mở hộp thoại "Save As..."
        String headerKey = "Content-Disposition";
        String headerValue = String.format("attachment; filename=\"%s\"", "download_job_" + jobId + ".zip");
        response.setHeader(headerKey, headerValue);

        // --- BƯỚC 4: ĐỌC FILE VÀ GHI VÀO OUTPUT STREAM CỦA RESPONSE ---
        
        // Sử dụng try-with-resources để đảm bảo stream được đóng tự động
        try (FileInputStream inStream = new FileInputStream(downloadFile);
             OutputStream outStream = response.getOutputStream()) {
            
            byte[] buffer = new byte[4096]; // Tạo một bộ đệm
            int bytesRead = -1;
            
            // Đọc từ file và ghi vào response cho đến khi hết file
            while ((bytesRead = inStream.read(buffer)) != -1) {
                outStream.write(buffer, 0, bytesRead);
            }
        }
    }
}