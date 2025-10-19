# 🐳 Docker Compose Case Studies

A comprehensive guide to mastering Docker Compose through hands-on examples, from single containers to complex multi-service applications.

---

## 📋 Table of Contents

- [Case Study 1: Running a Single Application with Docker Compose](#-case-study-1-running-a-single-application-with-docker-compose)
- [Case Study 2: Multi-Service Stack (Web + Database)](#-case-study-2-multi-service-stack-web--database)
- [Case Study 3: Bind Mount for Development](#-case-study-3-bind-mount-for-development)
- [Case Study 4: Custom Network and Inter-Service Communication](#-case-study-4-custom-network-and-inter-service-communication)
- [Case Study 5: Build Custom Image with Build Args](#-case-study-5-build-custom-image-with-build-args)
- [Case Study 6: Resource Limits & Restart Policy](#-case-study-6-resource-limits--restart-policy)
- [Case Study 7: Multiple Compose Files & Override](#-case-study-7-multiple-compose-files--override)

---

## 🧩 CASE STUDY 1: Running a Single Application with Docker Compose

### 📘 Objective
Learn to create a simple Compose file to run a single container.

### 🎯 Level
**Beginner** — Understanding basic Docker Compose syntax and commands.

### 📋 Steps

#### 1️⃣ Create project folder

```bash
mkdir compose-single-app && cd compose-single-app
```

#### 2️⃣ Create `docker-compose.yml` file

```yaml
version: '3.8'

services:
  web:
    image: nginx:latest
    ports:
      - "8080:80"
```

#### 3️⃣ Start the container

```bash
docker compose up -d
```

#### 4️⃣ Check running containers

```bash
docker compose ps
```

#### 5️⃣ Access in browser

```
http://localhost:8080
```

#### 6️⃣ View logs

```bash
docker compose logs -f web
```

#### 7️⃣ Stop and remove the container

```bash
docker compose down
```

---

## 🧩 CASE STUDY 2: Multi-Service Stack (Web + Database)

### 📘 Objective
Learn multi-service orchestration, environment variables, volumes, and service dependencies.

### 🎯 Level
**Intermediate** — Working with multiple interconnected services.

### 📋 Steps

#### 1️⃣ Create project folder

```bash
mkdir compose-multi-service && cd compose-multi-service
```

#### 2️⃣ Create `docker-compose.yml` file

```yaml
version: '3.8'

services:
  web:
    image: nginx:latest
    ports:
      - "8080:80"
    depends_on:
      - db

  db:
    image: mysql:8.0
    environment:
      MYSQL_ROOT_PASSWORD: secret
      MYSQL_DATABASE: myapp
      MYSQL_USER: admin
      MYSQL_PASSWORD: admin123
    volumes:
      - dbdata:/var/lib/mysql

volumes:
  dbdata:
```

#### 3️⃣ Start the stack

```bash
docker compose up -d
```

#### 4️⃣ Check all services status

```bash
docker compose ps
```

#### 5️⃣ View logs from all services

```bash
docker compose logs -f
```

#### 6️⃣ View logs from specific service

```bash
docker compose logs -f db
```

#### 7️⃣ Access the database

```bash
docker compose exec db mysql -u admin -padmin123 myapp
```

#### 8️⃣ Stop stack and remove volumes

```bash
docker compose down -v
```

---

## 🧩 CASE STUDY 3: Bind Mount for Development

### 📘 Objective
Connect local folders to containers for live file updates during development.

### 🎯 Level
**Intermediate** — Understanding bind mounts for development workflow.

### 📋 Steps

#### 1️⃣ Create project folder and HTML directory

```bash
mkdir compose-bind-mount && cd compose-bind-mount
mkdir html
```

#### 2️⃣ Create `html/index.html` file

```html
<!DOCTYPE html>
<html>
<head>
    <title>Docker Compose Dev</title>
</head>
<body>
    <h1>Hello from Bind Mount!</h1>
    <p>Edit this file and refresh to see changes instantly.</p>
</body>
</html>
```

#### 3️⃣ Create `docker-compose.yml` file

```yaml
version: '3.8'

services:
  web:
    image: nginx:latest
    ports:
      - "8080:80"
    volumes:
      - ./html:/usr/share/nginx/html:ro
```

> **Note:** `:ro` means read-only. The container can read files but cannot modify them.

#### 4️⃣ Start the stack

```bash
docker compose up -d
```

#### 5️⃣ Access in browser

```
http://localhost:8080
```

#### 6️⃣ Edit `html/index.html` on your host machine

```html
<h1>Hello from Updated Bind Mount!</h1>
<p>Changes appear immediately!</p>
```

#### 7️⃣ Refresh browser to see changes instantly

No need to rebuild or restart the container!

#### 8️⃣ Stop the stack

```bash
docker compose down
```

---

## 🧩 CASE STUDY 4: Custom Network and Inter-Service Communication

### 📘 Objective
Learn custom networking, service discovery, and health checks.

### 🎯 Level
**Advanced** — Understanding container networking and health monitoring.

### 📋 Steps

#### 1️⃣ Create project folder

```bash
mkdir compose-networking && cd compose-networking
```

#### 2️⃣ Create `docker-compose.yml` file with custom network

```yaml
version: '3.8'

networks:
  appnet:
    driver: bridge

services:
  web:
    image: nginx:latest
    ports:
      - "8080:80"
    networks:
      - appnet
    depends_on:
      db:
        condition: service_healthy

  db:
    image: mysql:8.0
    environment:
      MYSQL_ROOT_PASSWORD: secret
      MYSQL_DATABASE: myapp
    networks:
      - appnet
    healthcheck:
      test: ["CMD", "mysqladmin", "ping", "-h", "localhost"]
      interval: 10s
      timeout: 5s
      retries: 5
      start_period: 30s
```

#### 3️⃣ Start the stack

```bash
docker compose up -d
```

#### 4️⃣ Wait for health check to pass

```bash
docker compose ps
```

You should see `(healthy)` status for the database.

#### 5️⃣ Test inter-service communication

Ping database from web container:

```bash
docker compose exec web ping -c 3 db
```

#### 6️⃣ Check network details

```bash
docker network ls
docker network inspect compose-networking_appnet
```

#### 7️⃣ Test DNS resolution

```bash
docker compose exec web nslookup db
```

#### 8️⃣ Stop the stack

```bash
docker compose down
```

---

## 🧩 CASE STUDY 5: Build Custom Image with Build Args

### 📘 Objective
Learn to build containers from Dockerfile and configure build arguments.

### 🎯 Level
**Advanced** — Integrating Dockerfile builds with Compose.

### 📋 Steps

#### 1️⃣ Create project structure

```bash
mkdir compose-custom-build && cd compose-custom-build
mkdir app
```

#### 2️⃣ Create `app/index.js` file

```javascript
const http = require('http');
const port = process.env.PORT || 3000;
const env = process.env.BUILD_ENV || 'unknown';

const server = http.createServer((req, res) => {
  res.writeHead(200, {'Content-Type': 'text/html'});
  res.end(`
    <h1>Custom Built App</h1>
    <p>Build Environment: <strong>${env}</strong></p>
    <p>Server running on port ${port}</p>
  `);
});

server.listen(port, () => {
  console.log(`Server running on port ${port}`);
  console.log(`Build environment: ${env}`);
});
```

#### 3️⃣ Create `app/Dockerfile`

```dockerfile
FROM node:18-alpine
ARG BUILD_ENV=production
ENV BUILD_ENV=${BUILD_ENV}
WORKDIR /app
COPY . .
RUN echo "Building for environment: $BUILD_ENV"
EXPOSE 3000
CMD ["node", "index.js"]
```

#### 4️⃣ Create `docker-compose.yml` in root folder

```yaml
version: '3.8'

services:
  webapp:
    build:
      context: ./app
      dockerfile: Dockerfile
      args:
        BUILD_ENV: development
    image: my-webapp:1.0
    container_name: custom-webapp
    ports:
      - "3000:3000"
    environment:
      - PORT=3000
```

#### 5️⃣ Build and start the application

```bash
docker compose up -d --build
```

#### 6️⃣ Access in browser

```
http://localhost:3000
```

#### 7️⃣ View build logs

```bash
docker compose logs webapp
```

#### 8️⃣ Rebuild with different build arg

```bash
docker compose build --build-arg BUILD_ENV=production webapp
docker compose up -d
```

#### 9️⃣ Stop the stack

```bash
docker compose down
```

### ✅ Skills Practiced
- Building custom images with Compose
- Dockerfile integration
- Build arguments (ARG)
- Environment variables

---

## 🧩 CASE STUDY 6: Resource Limits & Restart Policy

### 📘 Objective
Learn to configure resource constraints and automatic restart policies.

### 🎯 Level
**Advanced** — Managing container resources and availability.

### 📋 Steps

#### 1️⃣ Create project folder

```bash
mkdir compose-resources && cd compose-resources
```

#### 2️⃣ Create `docker-compose.yml` file

```yaml
version: '3.8'

services:
  web:
    image: nginx:latest
    container_name: resource-limited-nginx
    ports:
      - "8080:80"
    deploy:
      resources:
        limits:
          cpus: "0.5"
          memory: "256M"
        reservations:
          cpus: "0.25"
          memory: "128M"
    restart: always
    
  app:
    image: nginx:alpine
    container_name: app-with-restart
    ports:
      - "8081:80"
    restart: unless-stopped
```

#### 3️⃣ Start the stack

```bash
docker compose up -d
```

#### 4️⃣ Check container status

```bash
docker compose ps
```

#### 5️⃣ Monitor resource usage

```bash
docker stats
```

Press `Ctrl+C` to exit stats view.

#### 6️⃣ Test restart policy

Kill the container manually:

```bash
docker compose kill web
```

Wait a few seconds and check status:

```bash
docker compose ps
```

The container should restart automatically.

#### 7️⃣ View logs

```bash
docker compose logs -f web
```

#### 8️⃣ Stop the stack

```bash
docker compose down
```

---

## 🧩 CASE STUDY 7: Multiple Compose Files & Override

### 📘 Objective
Learn to manage different environments (dev/prod) using multiple Compose files.

### 🎯 Level
**Expert** — Advanced environment management and configuration inheritance.

### 📋 Steps

#### 1️⃣ Create project folder

```bash
mkdir compose-multi-env && cd compose-multi-env
```

#### 2️⃣ Create `docker-compose.yml` (base configuration)

```yaml
version: '3.8'

services:
  web:
    image: nginx:latest
    ports:
      - "8080:80"
    
  db:
    image: mysql:8.0
    environment:
      MYSQL_ROOT_PASSWORD: secret
    volumes:
      - dbdata:/var/lib/mysql

volumes:
  dbdata:
```

#### 3️⃣ Create `docker-compose.override.yml` (development overrides)

```yaml
version: '3.8'

services:
  web:
    volumes:
      - ./html:/usr/share/nginx/html
    environment:
      - DEBUG=true
      - ENVIRONMENT=development
    
  db:
    ports:
      - "3306:3306"
    environment:
      MYSQL_DATABASE: dev_db
```

> **Note:** This file is automatically loaded with `docker-compose.yml` when you run `docker compose up`.

#### 4️⃣ Create `docker-compose.prod.yml` (production overrides)

```yaml
version: '3.8'

services:
  web:
    deploy:
      resources:
        limits:
          cpus: "1.0"
          memory: "512M"
    restart: always
    environment:
      - DEBUG=false
      - ENVIRONMENT=production
    
  db:
    deploy:
      resources:
        limits:
          cpus: "2.0"
          memory: "1G"
    restart: always
    environment:
      MYSQL_DATABASE: prod_db
```

#### 5️⃣ Create HTML folder for development

```bash
mkdir html
echo "<h1>Development Environment</h1>" > html/index.html
```

#### 6️⃣ Run development stack

```bash
docker compose up -d
```

This automatically uses `docker-compose.yml` + `docker-compose.override.yml`.

#### 7️⃣ Check development environment

```bash
docker compose ps
docker compose exec web env | grep ENVIRONMENT
```

Access: http://localhost:8080

#### 8️⃣ Stop development stack

```bash
docker compose down
```

#### 9️⃣ Run production stack

```bash
docker compose -f docker-compose.yml -f docker-compose.prod.yml up -d
```

#### 🔟 Check production environment

```bash
docker compose -f docker-compose.yml -f docker-compose.prod.yml ps
docker compose -f docker-compose.yml -f docker-compose.prod.yml exec web env | grep ENVIRONMENT
```

#### 1️⃣1️⃣ Stop production stack

```bash
docker compose -f docker-compose.yml -f docker-compose.prod.yml down
```

### 🔍 File Loading Order

```
docker compose up
└── Loads: docker-compose.yml + docker-compose.override.yml (automatically)

docker compose -f docker-compose.yml -f docker-compose.prod.yml up
└── Loads: docker-compose.yml + docker-compose.prod.yml (explicitly)
```