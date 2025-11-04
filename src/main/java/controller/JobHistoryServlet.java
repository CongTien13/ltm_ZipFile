package controller;

import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.bean.User;
import model.bean.ZipJob;
import model.bo.ZipJobBO;

/**
 * Servlet này có nhiệm vụ lấy lịch sử các tác vụ nén của người dùng
 * và hiển thị trang job_history.jsp.
 */
// Dòng này CỰC KỲ QUAN TRỌNG, nó map URL với Servlet
@WebServlet("/JobHistoryServlet") 
public class JobHistoryServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ZipJobBO zipJobBO = new ZipJobBO();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        // Kiểm tra xem user đã đăng nhập chưa
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/LoginServlet");
            return;
        }
        
        // Bước 1: Gọi BO để lấy danh sách các job từ CSDL
        List<ZipJob> jobList = zipJobBO.getJobsByUserId(user.getId());
        
        // Bước 2: Đặt danh sách job vào request để JSP có thể truy cập
        request.setAttribute("jobList", jobList);
        
        // Bước 3: Chuyển tiếp (forward) đến trang JSP để hiển thị
        request.getRequestDispatcher("/views/job_history.jsp").forward(request, response);
    }
}