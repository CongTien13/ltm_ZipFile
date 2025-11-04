package controller;

import java.io.File;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import model.bean.UploadedFile;
import model.bean.User;
import model.bo.FileBO;

@WebServlet("/UploadServlet")
@MultipartConfig // Bắt buộc để xử lý file upload
public class UploadServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private FileBO fileBO = new FileBO();
    // Cấu hình đường dẫn lưu file (nên đặt trong web.xml)
    private static final String UPLOAD_DIRECTORY = "D:/web_ltm_uploads";

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        // Tạo thư mục upload nếu chưa tồn tại
        File uploadDir = new File(UPLOAD_DIRECTORY);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }

        try {
            Part filePart = request.getPart("file");
            String originalFileName = filePart.getSubmittedFileName();
            // Tạo tên file duy nhất để tránh ghi đè
            String savedFileName = System.currentTimeMillis() + "_" + originalFileName;
            String savePath = UPLOAD_DIRECTORY + File.separator + savedFileName;
            
            // Lưu file vật lý xuống ổ cứng server
            filePart.write(savePath);

            // Tạo đối tượng bean và lưu thông tin vào CSDL
            UploadedFile uploadedFile = new UploadedFile();
            uploadedFile.setUserId(user.getId());
            uploadedFile.setOriginalFilename(originalFileName);
            uploadedFile.setServerFilepath(savePath);

            fileBO.addFile(uploadedFile);
            
            session.setAttribute("message", "Tải file thành công!");
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "Tải file thất bại!");
        }

        response.sendRedirect(request.getContextPath() + "/HomeServlet");
    }
}