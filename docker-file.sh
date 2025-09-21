# Build docker image from Dockerfile
docker build -t dockerhub-username/imagename:tag path/to/dockerfile-folder

# Build docker image from Dockerfile with specific details
docker build -t dockerhub-username/imagename:tag path/to/dockerfile-folder --progress=plain

# Build docker image from Dockerfile with no cache
docker build -t dockerhub-username/imagename:tag path/to/dockerfile-folder --no-cache

# From instruction
FROM imagename:tag

# Run instruction (executes during build image stage)
RUN instruction

# Command instruction (executes when container start)
CMD instruction

# Add metadata to docker image 
LABEL key=value

# Add file to image (supports URL sources and auto-extracts archives like .zip)
ADD path/to/source-file path/to/destination-file

# Copy file to docker image
COPY path/to/source-file path/to/destination-fike

# To specify the port that will be used to access docker container
EXPOSE PORT

# Add environment variables
ENV key=value

# Bind host directory to docker volume
VOLUME /path/to/source-file

# Set working directory inside docker container
WORKDIR /path

# Define build-time variable (only available during docker image build)
ARG key=value

# Ignore selected file (.dockerignore)
folder/*.matcher
folder/subfoler

# Define health check for docker container
HEALTHCHECK [OPTIONS] CMD command

# OPTIONS
# --interval=DURATION (default: 30s)
# --timeout=DURATION (default: 30s)
# --start-period=DURATION (default: 0s)
# --retries=N (default: 3)

# Define container startup command
ENTRYPOINT ["executable", "param 1"]


# User Instructions

# 1. Create new group
RUN addgroup -S groupname

# 2. Create new user and assign it to the group
RUN adduser -S -D -h /app username groupname
# -S : create as system user
# -D : don't assign a password
# -h : specify home directory

# 3. Change ownership of working directory to new user
RUN chown -R username:groupname /app

# 4. Switch to new user
USER username


# Multi Build Stage

# 1. Use Golang image to build application
FROM golang:1.18-alpine AS builder

# 2. Set working directory inside container
WORKDIR /app/

# 3. Copy source code into container
COPY main.go .

# 4. Compile Go binary, output file is "main"
RUN go build -o /app/main main.go

# 5. Use small base image (no build tools, just runtime)
FROM alpine:3

# 6. Set working directory inside container
WORKDIR /app/

# 7. Copy compiled binary from builder stage
COPY --from=builder /app/main ./

# 8. Run binary
CMD ["/app/main"]


# Docker Hub Registry
docker login -u username

# 1. Login to Docker Hub registry
# 2. Use your Docker Hub username after -u
# 3. When prompted for password, enter your Personal Access Token (not your real password)

# 4. Push image to Docker Hub
docker push imagename:tag

# 4. Pull image from Docker Hub
docker pull imagename:tag