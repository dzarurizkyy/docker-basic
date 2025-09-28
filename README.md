# Docker Basic 🐳

This repository contains examples of **basic Docker commands**, how to write a **Dockerfile**, and how to use **Docker Compose**.


## Installation 🔧

1. Download [Docker Desktop](https://www.docker.com/get-started)
2. Install it like a regular application
3. Verify installation:

   ```
   docker --version
   ```


## List of Material 📚

* 📘 **Docker Basics**

  Contains examples of common Docker commands, such as:

  ```bash
  # Display running containers
  docker container ls

  # Create docker container
  docker container create --name my-nginx nginx:latest

  # Start docker container
  docker container start my-nginx
  ```
  
* 📗 **Dockerfile** 

  Shows how to build custom images with Dockerfile, including:

  ```dockerfile
  # Use base image
  FROM node:18-alpine

  # Copy files and install dependencies
  WORKDIR /app
  COPY . .
  RUN npm install

  # Start application
  CMD ["npm", "start"]
  ```
  
* 📙 **Docker Compose**

  Demonstrates how to manage multiple services using Docker Compose, such as:

  ```yaml
  version: "3.8"
  services:
    web:
      image: nginx
      ports:
        - "8080:80"
    db:
      image: postgres:14
      environment:
        POSTGRES_USER: user
        POSTGRES_PASSWORD: pass
        POSTGRES_DB: mydb
  ```

## 📚 References
* [Udemy](https://www.udemy.com/course/docker-pemula)


## 👨‍💻 Contributors
* [Dzaru Rizky Fathan Fortuna](https://www.linkedin.com/in/dzarurizky)
