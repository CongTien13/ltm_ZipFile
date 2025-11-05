package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.concurrent.CopyOnWriteArrayList;

@WebServlet("/JobStatusServlet")
public class JobStatusServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // Danh sách client đang mở kết nối SSE
    private static CopyOnWriteArrayList<PrintWriter> clients = new CopyOnWriteArrayList<>();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        resp.setContentType("text/event-stream");
        resp.setCharacterEncoding("UTF-8");

        PrintWriter out = resp.getWriter();
        clients.add(out);

        // Giữ kết nối SSE không timeout
        resp.flushBuffer();

        // Không đóng kết nối cho đến khi client rời đi
        while (!Thread.interrupted()) {
            try {
                Thread.sleep(1000);
            } catch (InterruptedException e) {
                break;
            }
        }
        clients.remove(out);
    }

    // Gọi hàm này từ bất cứ đâu (ví dụ: trong ZipWorker) để gửi thông báo
    public static void broadcastJobUpdate(int jobId, String status) {
        String message = "Job " + jobId + " → " + status;
        for (PrintWriter client : clients) {
            client.println("data: " + message + "\n");
            client.flush();
        }
    }
}
