# TODO API Implementation

A comprehensive MuleSoft Mule 4 application implementing a RESTful API for task management with full CRUD operations, database integration, and comprehensive testing.

## 📋 Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Prerequisites](#prerequisites)
- [Project Structure](#project-structure)
- [Setup & Installation](#setup--installation)
- [Running the Application](#running-the-application)
- [API Endpoints](#api-endpoints)
- [Testing](#testing)
- [CI/CD Pipeline](#cicd-pipeline)
- [Database Schema](#database-schema)
- [Development Guidelines](#development-guidelines)
- [Troubleshooting](#troubleshooting)

## 🎯 Overview

This MuleSoft application provides a complete task management API with the following capabilities:
- **Create** new tasks with title, description, completion status, and due date
- **Read** individual tasks by ID or retrieve all tasks
- **Update** existing tasks with new information
- **Delete** tasks by ID
- **Error Handling** with proper HTTP status codes and error messages
- **Database Integration** with MySQL for persistent storage
- **Comprehensive Testing** with MUnit test suite covering all scenarios

## ✨ Features

- 🔄 **Full CRUD Operations** - Complete task lifecycle management
- 🗄️ **MySQL Integration** - Persistent data storage with connection pooling
- 🧪 **Comprehensive Testing** - 10 MUnit test cases covering success and failure scenarios
- 🚀 **CI/CD Ready** - GitHub Actions workflow for automated testing
- 📊 **API Documentation** - OpenAPI specification integration
- 🛡️ **Error Handling** - Robust error management with proper HTTP responses
- 🐳 **Docker Support** - Containerized database for development
- 📈 **Code Coverage** - MUnit coverage reporting

## 🔧 Prerequisites

### Required Software
- **Java 17** (LTS) - [Download OpenJDK 17](https://adoptium.net/)
- **Apache Maven 3.6+** - [Download Maven](https://maven.apache.org/download.cgi)
- **Docker Desktop** - [Download Docker](https://www.docker.com/get-started)
- **Git** - [Download Git](https://git-scm.com/downloads)

### Development Environment (Choose One)
- **Anypoint Studio 7.x** - [Download Anypoint Studio](https://www.mulesoft.com/platform/studio)
  - Traditional desktop IDE for MuleSoft development
  - Full-featured with visual flow designer and debugging capabilities
- **Anypoint Code Builder (VS Code Extension)** - [Install from VS Code Marketplace](https://marketplace.visualstudio.com/items?itemName=MuleSoft.anypoint-code-builder)
  - Modern VS Code extension for MuleSoft development
  - Lightweight alternative with IntelliSense and debugging support
  - Requires VS Code 1.75+ and Java 17
- **Anypoint Code Builder Cloud** - [Access via Anypoint Platform](https://anypoint.mulesoft.com/)
  - Cloud-based development environment (if access available)
  - No local installation required
  - Integrated with Anypoint Platform services

### MuleSoft Dependencies
- **Mule Runtime 4.7.4+**
- **MUnit 3.5.0** (for testing)
- **APIKit Module 1.11.10**
- **Database Connector 1.14.17**
- **HTTP Connector 1.11.0**

### Database
- **MySQL 8.0** (provided via Docker Compose)

## 📁 Project Structure

```
todo-api-impl/
├── .github/
│   └── workflows/
│       └── munit-tests.yml          # CI/CD pipeline configuration
├── src/
│   ├── main/
│   │   ├── mule/
│   │   │   ├── create-new-task.xml          # Create task subflow
│   │   │   ├── delete-task-by-id-subflow.xml # Delete task subflow
│   │   │   ├── get-all-tasks.xml            # Get all tasks subflow
│   │   │   ├── get-task-by-id.xml           # Get task by ID subflow
│   │   │   ├── update-task-by-id-subflow.xml # Update task subflow
│   │   │   ├── global.xml                   # Global configurations
│   │   │   └── todo-api-impl.xml            # Main API flow
│   │   └── resources/
│   │       ├── dw/                          # DataWeave transformations
│   │       └── log4j2.xml                   # Logging configuration
│   └── test/
│       ├── munit/
│       │   └── test-crud-tasks.xml          # Comprehensive test suite
│       └── resources/
├── docker-compose.yml                       # MySQL database setup
├── pom.xml                                  # Maven configuration
└── README.md                               # This file
```

## 🚀 Setup & Installation

### 1. Clone the Repository
```bash
git clone <repository-url>
cd todo-api-impl
```

### 2. Verify Java Installation
```bash
java -version
# Should show Java 17.x.x
```

### 3. Verify Maven Installation
```bash
mvn -version
# Should show Maven 3.6+ with Java 17
```

### 4. Start Database
```bash
# Start MySQL database using Docker Compose
docker compose up -d

# Verify database is running
docker compose ps
```

### 5. Create Database Schema
```sql
-- Connect to MySQL and create the tasks table
CREATE DATABASE IF NOT EXISTS mysqldb;
USE mysqldb;

CREATE TABLE IF NOT EXISTS tasks (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    completed BOOLEAN DEFAULT FALSE,
    dueDate DATE
);
```

### 6. Install Dependencies
```bash
# Install Maven dependencies
mvn clean install -DskipTests
```

## 🏃‍♂️ Running the Application

### Option 1: Anypoint Studio
1. Import project into Anypoint Studio
   - File → Import → Anypoint Studio → Anypoint Studio Project from File System
   - Select the project folder
2. Right-click project → Run As → Mule Application
3. Application will start on `http://localhost:8081`

### Option 2: Anypoint Code Builder (VS Code)
1. Open project in VS Code with Anypoint Code Builder extension installed
2. Open Command Palette (`Ctrl+Shift+P` / `Cmd+Shift+P`)
3. Run command: `MuleSoft: Run Mule Application`
4. Or use the Run/Debug configuration in VS Code
5. Application will start on `http://localhost:8081`

### Option 3: Anypoint Code Builder Cloud
1. Access [Anypoint Platform](https://anypoint.mulesoft.com/)
2. Navigate to Design Center → Create → Mule Application
3. Import or create your project
4. Use the built-in Run functionality
5. Application will be available via the cloud environment

### Option 4: Maven Command Line
```bash
# Run the application
mvn mule:run

# Application will be available at http://localhost:8081
```

### Option 5: Standalone Mule Runtime
```bash
# Package the application
mvn clean package

# Deploy to Mule Runtime
# Copy target/todo-api-impl-1.0.0-SNAPSHOT-mule-application.jar to $MULE_HOME/apps/
```

## 🌐 API Endpoints

### Base URL
```
http://localhost:8081/api
```

### Available Endpoints

| Method | Endpoint | Description | Request Body |
|--------|----------|-------------|--------------|
| `GET` | `/tasks` | Get all tasks | None |
| `GET` | `/tasks/{id}` | Get task by ID | None |
| `POST` | `/tasks` | Create new task | Task JSON |
| `PUT` | `/tasks/{id}` | Update task | Task JSON |
| `DELETE` | `/tasks/{id}` | Delete task | None |

### Request/Response Examples

#### Create Task
```bash
POST /api/tasks
Content-Type: application/json

{
    "title": "Complete project documentation",
    "description": "Write comprehensive README and API docs",
    "completed": false,
    "dueDate": "2024-12-31"
}
```

#### Response
```json
{
    "id": 1,
    "title": "Complete project documentation",
    "description": "Write comprehensive README and API docs",
    "completed": false,
    "dueDate": "2024-12-31"
}
```

#### Get All Tasks
```bash
GET /api/tasks
```

#### Update Task
```bash
PUT /api/tasks/1
Content-Type: application/json

{
    "title": "Complete project documentation",
    "description": "Write comprehensive README and API docs",
    "completed": true,
    "dueDate": "2024-12-31"
}
```

#### Delete Task
```bash
DELETE /api/tasks/1
```

## 🧪 Testing

### MUnit Test Suite
The project includes comprehensive MUnit tests covering all CRUD operations:

#### Test Coverage
- ✅ **Get Task by ID** (Success & Failure)
- ✅ **Create New Task** (Success & Failure)
- ✅ **Update Task** (Success & Failure)
- ✅ **Delete Task** (Success & Failure)
- ✅ **Get All Tasks** (Success & Failure)

#### Running Tests

**Via Maven:**
```bash
# Run all tests
mvn clean test

# Run specific test suite
mvn test -Dmunit.test=test-crud-tasks.xml

# Run tests with coverage
mvn clean test -Dmunit.coverage.runCoverage=true
```

**Via Anypoint Studio:**
1. Right-click on `test-crud-tasks.xml`
2. Select "Run MUnit Suite"

**Via Anypoint Code Builder (VS Code):**
1. Open `test-crud-tasks.xml` in VS Code
2. Use Command Palette: `MuleSoft: Run MUnit Test`
3. Or right-click in editor and select "Run MUnit Test"

**Via Anypoint Code Builder Cloud:**
1. Open the test file in the cloud IDE
2. Use the integrated test runner
3. View results in the cloud environment

#### Test Reports
- **Console Output**: Real-time test results
- **HTML Reports**: `target/site/munit/coverage/`
- **XML Reports**: `target/surefire-reports/`

### Manual Testing
Use tools like Postman, curl, or any REST client to test the API endpoints manually.

## 🔄 CI/CD Pipeline

### GitHub Actions Workflow
The project includes a comprehensive CI/CD pipeline (`.github/workflows/munit-tests.yml`) that:

- ✅ **Triggers**: On push/PR to main and develop branches
- ✅ **Environment**: Ubuntu with Java 17 and Maven
- ✅ **Database**: MySQL 8.0 service container
- ✅ **Testing**: Runs complete MUnit test suite
- ✅ **Coverage**: Generates and uploads coverage reports
- ✅ **Artifacts**: Stores test results and reports

### Pipeline Steps
1. **Checkout Code**
2. **Setup Java 17**
3. **Cache Maven Dependencies**
4. **Start MySQL Service**
5. **Create Database Schema**
6. **Run MUnit Tests**
7. **Generate Coverage Reports**
8. **Upload Test Artifacts**

## 🗄️ Database Schema

### Tasks Table
```sql
CREATE TABLE tasks (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    completed BOOLEAN DEFAULT FALSE,
    dueDate DATE
);
```

### Database Configuration
- **Host**: localhost (127.0.0.1)
- **Port**: 3306
- **Database**: mysqldb
- **Username**: user
- **Password**: password

## 👨‍💻 Development Guidelines

### Code Style
- Follow MuleSoft best practices
- Use meaningful names for flows and components
- Implement proper error handling
- Add comprehensive logging

### Testing Standards
- Write tests for all new features
- Maintain minimum 80% code coverage
- Test both success and failure scenarios
- Use proper mocking for external dependencies

### Git Workflow
1. Create feature branch from `main`
2. Implement changes with tests
3. Ensure all tests pass locally
4. Create pull request
5. CI/CD pipeline validates changes
6. Merge after review and approval

## 🔧 Troubleshooting

### Common Issues

#### Database Connection Issues
```bash
# Check if MySQL is running
docker compose ps

# View database logs
docker compose logs mysql

# Restart database
docker compose restart mysql
```

#### Port Conflicts
```bash
# Check if port 8081 is in use
netstat -an | grep 8081

# Kill process using port (Windows)
netstat -ano | findstr :8081
taskkill /PID <PID> /F

# Kill process using port (Linux/Mac)
lsof -ti:8081 | xargs kill -9
```

#### Maven Dependency Issues
```bash
# Clear Maven cache
mvn dependency:purge-local-repository

# Force update dependencies
mvn clean install -U
```

#### MUnit Test Failures
```bash
# Run tests with debug logging
mvn test -Dmunit.test=test-crud-tasks.xml -X

# Check test reports
cat target/surefire-reports/*.xml
```

### Environment Variables
Set these environment variables if needed:
```bash
export JAVA_HOME=/path/to/java17
export MAVEN_HOME=/path/to/maven
export MULE_HOME=/path/to/mule-runtime
```

### Support
For issues and questions:
1. Check the troubleshooting section above
2. Review MuleSoft documentation
3. Check project issues on GitHub
4. Contact the development team

---

## 📄 License
This project is licensed under the MIT License - see the LICENSE file for details.

## 🤝 Contributing
1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Ensure all tests pass
6. Submit a pull request

---

**Happy Coding! 🚀**
