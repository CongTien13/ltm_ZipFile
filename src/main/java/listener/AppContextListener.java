package listener;

import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;
import util.JobQueue;
import worker.WorkerManager;
import worker.ZipWorker;

@WebListener
public class AppContextListener implements ServletContextListener {

    private Thread dispatcherThread;

    @Override
    public void contextInitialized(ServletContextEvent sce) {

        dispatcherThread = new Thread(() -> {
            System.out.println(">>> Job Dispatcher Started!");

            while (true) {
                try {
                    int jobId = JobQueue.getInstance().takeJob();
                    String fileName = JobQueue.getInstance().takeName();

                    System.out.println(">>> Dispatch job " + jobId);

                    WorkerManager.getInstance().submitJob(jobId, fileName);

                } catch (InterruptedException e) {
                    break;
                }
            }
        });

        dispatcherThread.start();
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        if (dispatcherThread != null) dispatcherThread.interrupt();
        WorkerManager.getInstance().shutdown();
    }
}
