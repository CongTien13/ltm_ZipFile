package worker;

import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

public class WorkerManager {

    private static WorkerManager instance = null;

    // 5 worker chạy song song (bạn có thể tăng lên)
    private ExecutorService executor = Executors.newFixedThreadPool(5);

    private WorkerManager() {}

    public static WorkerManager getInstance() {
        if (instance == null) {
            instance = new WorkerManager();
        }
        return instance;
    }

    public void submitJob(int jobId, String fileName) {
        executor.submit(new ZipWorker(jobId, fileName));
    }

    public void shutdown() {
        executor.shutdownNow();
    }
}
