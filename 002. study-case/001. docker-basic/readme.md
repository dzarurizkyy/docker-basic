# 🐳 Docker Case Studies

A comprehensive guide to mastering Docker fundamentals through hands-on examples.

---

## 📋 Table of Contents

- [Case Study 1: Running a Simple Web Application](#-case-study-1-running-a-simple-web-application-nginx)
- [Case Study 2: Storing Application Data Using Volumes](#-case-study-2-storing-application-data-using-volumes)
- [Case Study 3: Backup & Restore Data from Volume](#-case-study-3-backup--restore-data-from-volume)
- [Case Study 4: Connecting Two Containers (Network)](#-case-study-4-connecting-two-containers-network)
- [Case Study 5: Custom Container with Resource Limits](#-case-study-5-custom-container-with-resource-limits)
- [Case Study 6: Maintenance and Cleanup](#-case-study-6-maintenance-and-cleanup)

---

## 🧩 CASE STUDY 1: Running a Simple Web Application (Nginx)

### 📘 Objective
Understand Docker images, container lifecycle, port forwarding, and logging.

### 📋 Steps

#### 1️⃣ Search and pull the Nginx image

```bash
docker image pull nginx:latest
docker image ls
```

#### 2️⃣ Create a container from the image

```bash
docker container create --name webserver --publish 8080:80 nginx:latest
```

#### 3️⃣ Start the container

```bash
docker container start webserver
docker container ls
```

#### 4️⃣ Open your browser

```
http://localhost:8080
```

#### 5️⃣ View container logs

```bash
docker container logs -f webserver
```

#### 6️⃣ Stop and remove the container

```bash
docker container stop webserver
docker container rm webserver
```

---


## 🧩 CASE STUDY 2: Storing Application Data Using Volumes

### 📘 Objective
Learn about volumes to ensure data persists even after containers are deleted.

### 📋 Steps

#### 1️⃣ Create a volume

```bash
docker volume create webdata
```

#### 2️⃣ Run Nginx with the volume

```bash
docker container create \
  --name webserver \
  --publish 8080:80 \
  --mount "type=volume,source=webdata,destination=/usr/share/nginx/html" \
  nginx:latest
```

#### 3️⃣ Enter the container and modify the index page

```bash
docker container start webserver
```

```bash
docker container exec -it webserver /bin/bash
```

```bash
echo "<h1>Hello from Docker Volume!</h1>" > /usr/share/nginx/html/index.html
```

```bash
exit
```

#### 4️⃣ Stop & remove the container, then create a new container with the same volume

```bash
docker container stop webserver
docker container rm webserver
```

```bash
docker container create \
  --name webserver2 \
  --publish 8080:80 \
  --mount "type=volume,source=webdata,destination=/usr/share/nginx/html" \
  nginx:latest
```

```bash
docker container start webserver2
```

#### 5️⃣ Check your browser → the data still exists

```
http://localhost:8080
```

---


## 🧩 CASE STUDY 3: Backup & Restore Data from Volume

### 📘 Objective
Learn how to backup and restore volumes using bind mounts.

### 📋 Steps

#### 1️⃣ Backup the volume

```bash
docker container run --rm --name backup-nginx \
  --mount "type=bind,source=$(PWD)/backup,destination=/backup" \
  --mount "type=volume,source=webdata,destination=/data" \
  ubuntu tar cvf /backup/webdata-backup.tar.gz /data
```

#### 2️⃣ Remove the volume

```bash
docker volume rm webdata
```

#### 3️⃣ Create a new volume and restore

```bash
docker volume create webdata
```

```bash
docker container run --rm --name restore-nginx \
  --mount "type=bind,source=$(PWD)/backup,destination=/backup" \
  --mount "type=volume,source=webdata,destination=/data" \
  ubuntu bash -c "tar xvf /backup/webdata-backup.tar.gz"
```

---


## 🧩 CASE STUDY 4: Connecting Two Containers (Network)

### 📘 Objective
Learn about custom networks and inter-container communication.

### 📋 Steps

#### 1️⃣ Create a network

```bash
docker network create --driver bridge appnet
```

#### 2️⃣ Run the database (MySQL)

```bash
docker container create \
  --name mysqldb \
  --network appnet \
  --env MYSQL_ROOT_PASSWORD=root \
  mysql:latest
```

```bash
docker container start mysqldb
```

#### 3️⃣ Run Adminer (GUI for MySQL)

```bash
docker container create \
  --name adminer \
  --publish 8080:80 \
  --network appnet \
  adminer
```

```bash
docker container start adminer
```

#### 4️⃣ Access the application

```
http://localhost:8080
```

**Login credentials:**
- 🖥️ Server: `mysqldb`
- 👤 Username: `root`
- 🔑 Password: `root`

#### 5️⃣ Test inter-container connection

```bash
docker container exec -it adminer ping mysqldb
```

---


## 🧩 CASE STUDY 5: Custom Container with Resource Limits

### 📘 Objective
Limit CPU and memory usage of containers to prevent system overload.

### 📋 Steps

#### 1️⃣ Create a container with resource limits

```bash
docker container create \
  --name limited-nginx \
  --memory="256m" \
  --cpus="0.5" \
  --publish 8080:80 \
  nginx
```

#### 2️⃣ Start the container

```bash
docker container start limited-nginx
```

#### 3️⃣ Monitor resource usage

```bash
docker container stats
```

#### 4️⃣ Access the application

```
http://localhost:8080
```

---


## 🧩 CASE STUDY 6: Maintenance and Cleanup

### 📘 Objective
Practice cleaning up unused images, containers, volumes, and networks.

### 📋 Steps

#### 1️⃣ Display all resources

```bash
docker image ls
```

```bash
docker container ls -a
```

```bash
docker volume ls
```

```bash
docker network ls
```

#### 2️⃣ Remove unnecessary resources

```bash
docker image rm <image_id>
```

```bash
docker container rm <container_id>
```

```bash
docker volume rm <volume_name>
```

```bash
docker network rm <network_name>
```

#### 3️⃣ Use prune for automatic cleanup

```bash
docker system prune
```

```bash
docker image prune
```

```bash
docker volume prune
```

```bash
docker network prune
```
