package util;

import java.util.concurrent.BlockingQueue;
import java.util.concurrent.LinkedBlockingQueue;

/**
 * Lớp Singleton để quản lý hàng đợi các tác vụ nén file.
 * Dùng LinkedBlockingQueue vì nó an toàn cho đa luồng (thread-safe).
 */
public class JobQueue {
    
    private static JobQueue instance;
    private BlockingQueue<Integer> queue; // Hàng đợi sẽ chỉ chứa các job ID

    private JobQueue() {
        queue = new LinkedBlockingQueue<>();
    }

    /**
     * Lấy về instance duy nhất của JobQueue.
     * @return instance của JobQueue.
     */
    public static synchronized JobQueue getInstance() {
        if (instance == null) {
            instance = new JobQueue();
        }
        return instance;
    }

    /**
     * Thêm một job ID vào cuối hàng đợi.
     * @param jobId ID của job cần xử lý.
     */
    public void addJob(int jobId) {
        try {
            queue.put(jobId);
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt(); // Restore the interrupted status
            e.printStackTrace();
        }
    }

    /**
     * Lấy và xóa một job ID khỏi đầu hàng đợi.
     * Phương thức này sẽ block (chờ) cho đến khi có một job trong hàng đợi.
     * @return job ID.
     * @throws InterruptedException
     */
    public int takeJob() throws InterruptedException {
        return queue.take();
    }
}