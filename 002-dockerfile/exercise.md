# 🐳 Dockerfile Case Studies

A comprehensive guide to mastering Dockerfile through hands-on examples, from basic to advanced concepts.

---

## 📋 Table of Contents

- [Case Study 1: Static Web App with Nginx](#-case-study-1-static-web-app-with-nginx)
- [Case Study 2: Node.js Web App with ENV & HEALTHCHECK](#-case-study-2-nodejs-web-app-with-env--healthcheck)
- [Case Study 3: Multi-Stage Build with Golang](#-case-study-3-multi-stage-build-with-golang)
- [Case Study 4: Publishing to Docker Hub](#-case-study-4-publishing-to-docker-hub)
- [Case Study 5: Advanced Dockerfile with .dockerignore & Non-Root User](#-case-study-5-advanced-dockerfile-with-dockerignore--non-root-user)

---

## 🧩 CASE STUDY 1: Static Web App with Nginx

### 📘 Objective
Build a simple static web container that serves an HTML page using Nginx.

### 🎯 Level
**Beginner** — Understanding basic Dockerfile syntax and image building.

### 📋 Steps

#### 1️⃣ Create project folder

```bash
mkdir dockerfile-nginx && cd dockerfile-nginx
```

#### 2️⃣ Create `index.html` file

```html
<h1>Hello from Dockerfile!</h1>
<p>This is a simple static web served by Nginx.</p>
```

#### 3️⃣ Create `Dockerfile`

```dockerfile
FROM nginx:latest
LABEL maintainer="dzaru@example.com"
COPY index.html /usr/share/nginx/html/index.html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```

#### 4️⃣ Build the image

```bash
docker build -t dzaru/nginx-web:1.0 .
```

#### 5️⃣ Run the container

```bash
docker run -d --name nginx-web -p 8080:80 dzaru/nginx-web:1.0
```

#### 6️⃣ Access in browser

```
http://localhost:8080
```

---

## 🧩 CASE STUDY 2: Node.js Web App with ENV & HEALTHCHECK

### 📘 Objective
Create a Node.js application that reads environment variables and includes a health check mechanism.

### 🎯 Level
**Intermediate** — Working with environment variables and container health checks.

### 📋 Steps

#### 1️⃣ Create project folder

```bash
mkdir dockerfile-nodejs && cd dockerfile-nodejs
```

#### 2️⃣ Create `server.js` file

```javascript
const http = require('http');
const port = process.env.PORT || 3000;
const appName = process.env.APP_NAME || 'My Docker App';

const server = http.createServer((req, res) => {
  res.end(`<h1>Hello from ${appName}</h1>`);
});

server.listen(port, () => console.log(`Server running on port ${port}`));
```

#### 3️⃣ Create `Dockerfile`

```dockerfile
FROM node:18-alpine
WORKDIR /app
COPY server.js .
ENV PORT=3000 APP_NAME="Dockerized Node.js App"
EXPOSE 3000
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
  CMD wget -qO- http://localhost:3000/ || exit 1
CMD ["node", "server.js"]
```

#### 4️⃣ Build the image

```bash
docker build -t dzaru/node-web:1.0 .
```

#### 5️⃣ Run the container with default environment

```bash
docker run -d --name node-web -p 3000:3000 dzaru/node-web:1.0
```

#### 6️⃣ Run with custom environment variables

```bash
docker run -d --name node-web2 -p 4000:3000 -e APP_NAME="Custom Web" dzaru/node-web:1.0
```

#### 7️⃣ Access in browser

```
http://localhost:3000
http://localhost:4000
```

---

## 🧩 CASE STUDY 3: Multi-Stage Build with Golang

### 📘 Objective
Build a Golang application using multi-stage builds to create a minimal production image.

### 🎯 Level
**Advanced** — Implementing multi-stage builds for optimized images.

### 📋 Steps

#### 1️⃣ Create project folder

```bash
mkdir dockerfile-golang && cd dockerfile-golang
```

#### 2️⃣ Create `main.go` file

```go
package main

import (
    "fmt"
    "net/http"
)

func handler(w http.ResponseWriter, r *http.Request) {
    fmt.Fprintf(w, "<h1>Hello from Go Docker Multi-Stage!</h1>")
}

func main() {
    http.HandleFunc("/", handler)
    fmt.Println("Server running on port 8080...")
    http.ListenAndServe(":8080", nil)
}
```

#### 3️⃣ Create `Dockerfile`

```dockerfile
# Build stage
FROM golang:1.18-alpine AS builder
WORKDIR /app
COPY main.go .
RUN go build -o main main.go

# Runtime stage
FROM alpine:3
WORKDIR /app
COPY --from=builder /app/main .
EXPOSE 8080
CMD ["/app/main"]
```

#### 4️⃣ Build the image

```bash
docker build -t dzaru/go-web:1.0 .
```

#### 5️⃣ Run the container

```bash
docker run -d --name go-web -p 8080:8080 dzaru/go-web:1.0
```

#### 6️⃣ Access in browser

```
http://localhost:8080
```

---

## 🧩 CASE STUDY 4: Publishing to Docker Hub

### 📘 Objective
Learn how to publish your Docker images to Docker Hub registry.

### 📋 Steps

#### 1️⃣ Login to Docker Hub

```bash
docker login -u dzaru
```

#### 2️⃣ Push the image

```bash
docker push dzaru/go-web:1.0
```

#### 3️⃣ Test pulling from another system

```bash
docker pull dzaru/go-web:1.0
docker run -d -p 8080:8080 dzaru/go-web:1.0
```

---

## 🧩 CASE STUDY 5: Advanced Dockerfile with .dockerignore & Non-Root User

### 📘 Objective
Create a production-ready Dockerfile with security best practices, including:
- Using `.dockerignore` to exclude unnecessary files
- Running as a non-root user for security
- Using `ARG` for dynamic build versions
- Separate development and production stages

### 🎯 Level
**Expert** — Production-ready containers with security and optimization.

### 📁 Project Structure

```
study-case/
├── .dockerignore
├── Dockerfile
├── main.go
```

### 📋 Steps

#### 1️⃣ Create project folder

```bash
mkdir dockerfile-advanced && cd dockerfile-advanced
```

#### 2️⃣ Create `.dockerignore` file

```
.git
*.log
node_modules
```

> **Note:** Files and folders listed here will not be copied into the image during `docker build`.

#### 3️⃣ Create `main.go` file

```go
package main

import (
    "fmt"
    "net/http"
    "os"
)

func handler(w http.ResponseWriter, r *http.Request) {
    env := os.Getenv("ENVIRONMENT")
    fmt.Fprintf(w, "<h1>Hello from %s environment!</h1>", env)
}

func main() {
    http.HandleFunc("/", handler)
    fmt.Println("Server running on port 8080...")
    http.ListenAndServe(":8080", nil)
}
```

#### 4️⃣ Create `Dockerfile` with multi-stage builds

```dockerfile
# ========== Stage 1: Base Builder ==========
FROM golang:1.20-alpine AS base
WORKDIR /app

# Add ARG for build version
ARG APP_VERSION=1.0.0
LABEL version=$APP_VERSION

# Copy all necessary files (excluding those in .dockerignore)
COPY . .

# Build binary
RUN go mod init example.com/app || true
RUN go build -o main main.go

# ========== Stage 2: Development ==========
FROM alpine:3.20 AS development
WORKDIR /app

# Copy build artifact from base stage
COPY --from=base /app/main .

# Add non-root user
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
USER appuser

# Development environment
ENV ENVIRONMENT=development

# Run application
CMD ["./main"]

# ========== Stage 3: Production ==========
FROM alpine:3.20 AS production
WORKDIR /app

# Copy build artifact from base stage
COPY --from=base /app/main .

# Add non-root user
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
USER appuser

# Production environment
ENV ENVIRONMENT=production

# Run application
CMD ["./main"]
```

#### 5️⃣ Build for Development

```bash
docker build -t myapp:dev --target development .
```

#### 6️⃣ Build for Production with custom version

```bash
docker build -t myapp:prod --target production --build-arg APP_VERSION=2.0.0 .
```

#### 7️⃣ Run Development container

```bash
docker run -d --name myapp-dev -p 8080:8080 myapp:dev
```

#### 8️⃣ Run Production container

```bash
docker run -d --name myapp-prod -p 9090:8080 myapp:prod
```

#### 9️⃣ Access in browser

```
http://localhost:8080  # Development
http://localhost:9090  # Production
```