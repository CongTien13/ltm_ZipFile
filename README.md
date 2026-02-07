# ZIP File Management System

A Java-based web application for uploading, managing, and compressing files into ZIP archives with asynchronous job processing.

## Features

- **User Authentication**: Register and login functionality with session management
- **File Upload**: Upload multiple files to the server
- **Asynchronous ZIP Creation**: Create ZIP archives from selected files using background workers
- **Job Queue System**: Queue-based job processing for handling multiple compression requests
- **Job History**: Track the status and history of all compression jobs
- **Real-time Job Status**: Monitor the progress of active compression jobs
- **File Download**: Download created ZIP archives

## Technology Stack

- **Backend**: Java Servlet API (Jakarta EE)
- **Web Server**: Apache Tomcat (or compatible servlet container)
- **Database**: SQL-based database (MySQL/PostgreSQL)
- **Frontend**: JSP (JavaServer Pages)
- **Build Tool**: Manual build (classes compiled to `build/` directory)

## Project Structure

```
ltm_ZipFile/
├── src/main/java/
│   ├── controller/          # Servlet controllers
│   │   ├── AuthenticationFilter.java
│   │   ├── CreateZipServlet.java
│   │   ├── DownloadServlet.java
│   │   ├── HomeServlet.java
│   │   ├── JobHistoryServlet.java
│   │   ├── JobStatusServlet.java
│   │   ├── LoginServlet.java
│   │   ├── LogoutServlet.java
│   │   ├── RegisterServlet.java
│   │   └── UploadServlet.java
│   ├── listener/            # Application listeners
│   │   └── AppContextListener.java
│   ├── model/
│   │   ├── bean/           # Data models
│   │   │   ├── UploadedFile.java
│   │   │   ├── User.java
│   │   │   └── ZipJob.java
│   │   ├── bo/             # Business logic layer
│   │   │   ├── FileBO.java
│   │   │   ├── UserBO.java
│   │   │   └── ZipJobBO.java
│   │   └── dao/            # Data access layer
│   │       ├── DatabaseConnection.java
│   │       ├── FileDAO.java
│   │       ├── UserDAO.java
│   │       └── ZipJobDAO.java
│   ├── util/               # Utility classes
│   │   └── JobQueue.java
│   └── worker/             # Background workers
│       └── ZipWorker.java
├── src/main/webapp/
│   ├── views/              # JSP pages
│   │   ├── home.jsp
│   │   ├── job_history.jsp
│   │   ├── login.jsp
│   │   └── register.jsp
│   ├── WEB-INF/
│   │   └── lib/            # External libraries
│   └── index.jsp
└── build/                  # Compiled classes
```

## Architecture

### MVC Pattern
The application follows the Model-View-Controller (MVC) design pattern:
- **Model**: Bean classes (User, UploadedFile, ZipJob)
- **View**: JSP pages
- **Controller**: Servlet classes

### Three-Layer Architecture
1. **Presentation Layer**: Servlets and JSP pages
2. **Business Logic Layer (BO)**: Business object classes
3. **Data Access Layer (DAO)**: Database interaction classes

### Asynchronous Job Processing
- **JobQueue**: Thread-safe queue for managing compression jobs
- **ZipWorker**: Background worker thread that processes jobs from the queue
- **AppContextListener**: Initializes the worker thread on application startup

## Prerequisites

- Java Development Kit (JDK) 11 or higher
- Apache Tomcat 10.x or compatible servlet container
- MySQL/PostgreSQL database server
- Jakarta Servlet API

## Installation & Setup

### 1. Database Setup

Create the required database tables:

```sql
-- Users table
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Uploaded files table
CREATE TABLE uploaded_files (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    original_filename VARCHAR(255) NOT NULL,
    saved_filename VARCHAR(255) NOT NULL,
    file_path VARCHAR(500) NOT NULL,
    file_size BIGINT,
    upload_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- ZIP jobs table
CREATE TABLE zip_jobs (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    status VARCHAR(20) NOT NULL,
    creation_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    result_filepath VARCHAR(500),
    file_name VARCHAR(255),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- Job details table (many-to-many relationship)
CREATE TABLE job_file_details (
    job_id INT NOT NULL,
    file_id INT NOT NULL,
    PRIMARY KEY (job_id, file_id),
    FOREIGN KEY (job_id) REFERENCES zip_jobs(id),
    FOREIGN KEY (file_id) REFERENCES uploaded_files(id)
);
```

### 2. Configure Database Connection

Update the database connection settings in `DatabaseConnection.java`:

```java
private static final String URL = "jdbc:mysql://localhost:3306/your_database";
private static final String USER = "your_username";
private static final String PASSWORD = "your_password";
```

### 3. Configure File Directories

Create the required directories and update paths in:
- `UploadServlet.java`: Set `UPLOAD_DIRECTORY` (default: `D:/web_ltm_uploads`)
- `ZipWorker.java`: Set `ZIP_OUTPUT_DIRECTORY` (default: `D:/web_ltm_zips`)

```bash
mkdir D:/web_ltm_uploads
mkdir D:/web_ltm_zips
```

### 4. Deploy to Tomcat

1. Compile the project
2. Copy the `webapp` folder contents to Tomcat's `webapps` directory
3. Copy compiled classes to `WEB-INF/classes`
4. Add required JAR files to `WEB-INF/lib`:
   - MySQL Connector/J (or PostgreSQL driver)
   - Jakarta Servlet API

### 5. Start the Application

1. Start Tomcat server
2. Access the application at: `http://localhost:8080/your-app-name`

## Usage

### 1. User Registration
- Navigate to the registration page
- Create a new account with username and password

### 2. Login
- Login with your credentials
- Session is maintained throughout the application

### 3. Upload Files
- Navigate to the home page
- Select and upload files to the server
- Files are stored with unique names to prevent conflicts

### 4. Create ZIP Archive
- Select files from your uploaded files list
- Provide a name for the ZIP archive
- Submit the compression request
- Job is queued and processed asynchronously

### 5. Monitor Jobs
- View job history page to see all compression requests
- Check job status: PENDING, PROCESSING, COMPLETED, or FAILED
- Download completed ZIP files

### 6. Download ZIP Files
- Click on completed jobs to download the ZIP archive

## Job Status Flow

```
PENDING → PROCESSING → COMPLETED
                    ↓
                  FAILED
```

## Security Features

- **Session Management**: User sessions are maintained securely
- **Authentication Filter**: Protects restricted pages from unauthorized access
- **Password Storage**: Passwords should be hashed (implement bcrypt or similar)

## Best Practices Implemented

- **Separation of Concerns**: Clear separation between presentation, business, and data layers
- **Thread Safety**: JobQueue uses thread-safe blocking queue
- **Resource Management**: Proper handling of file streams and database connections
- **Error Handling**: Try-catch blocks for robust error management

## Future Enhancements

- [ ] Implement password hashing (bcrypt)
- [ ] Add file type validation
- [ ] Implement file size limits
- [ ] Add progress bar for active jobs
- [ ] Email notifications for completed jobs
- [ ] Multi-threaded worker pool
- [ ] Admin panel for user management
- [ ] File preview functionality
- [ ] Bulk file deletion
- [ ] Search and filter capabilities

## Troubleshooting

### Common Issues

**Issue**: Files not uploading
- **Solution**: Check upload directory permissions and path configuration

**Issue**: Jobs stuck in PENDING status
- **Solution**: Verify ZipWorker thread is started in AppContextListener

**Issue**: Database connection errors
- **Solution**: Verify database credentials and JDBC driver is in WEB-INF/lib

**Issue**: ZIP files not being created
- **Solution**: Check ZIP output directory permissions and available disk space

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is created for educational purposes.

## Contact

For questions or support, please contact the development team.

---

**Note**: This is a learning project for understanding Java web development, servlet architecture, and asynchronous job processing.
