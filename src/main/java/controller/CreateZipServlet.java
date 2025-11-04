package controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.bean.User;
import model.bo.ZipJobBO;
import util.JobQueue;

@WebServlet("/CreateZipServlet")
public class CreateZipServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ZipJobBO zipJobBO = new ZipJobBO();

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        String[] selectedFileIds = request.getParameterValues("selectedFiles");

        if (selectedFileIds != null && selectedFileIds.length > 0) {
            
            // GỌI MỘT PHƯƠNG THỨC DUY NHẤT TỪ BO ĐỂ THỰC HIỆN TOÀN BỘ LOGIC
            int jobId = zipJobBO.createJobWithDetails(user.getId(), selectedFileIds);
            
            if (jobId != -1) {
                // Thêm job ID vào hàng đợi để Worker xử lý
                JobQueue.getInstance().addJob(jobId);
                session.setAttribute("message", "Yêu cầu nén file đã được gửi đi.");
            } else {
                session.setAttribute("error", "Không thể tạo yêu cầu nén file.");
            }
        } else {
            session.setAttribute("error", "Vui lòng chọn ít nhất một file để nén.");
        }
        
        response.sendRedirect(request.getContextPath() + "/JobHistoryServlet");
    }
}