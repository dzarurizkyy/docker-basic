# Display Docker Compose Version
docker compose version

# YAML vs JSON Format Comparison

## YAML Format
firstName: "Dzaru",
lastName: "Rizky Fathan Fortuna",
hobbies: 
  - "Coding",
  - "Reading"
address:
  city: "Surabaya"
  country: "Indonesia"
education:
  - type: Bachelor degree
    name: Universitas Pembangunan Nasional Veteran Jawa Timur
  - type: Master degree
    name: Monash University

## JSON Format
{
  "firstName": "Dzaru",
  "lastName": "Rizky Fathan Fortuna",
  "hobbies": [
    "Coding",
    "Reading"
  ],
  "address": {
    "city": "Surabaya"
    "country": "Indonesia" 
  },
  "education": [
    {
      "type": "Bachelor's degree",
      "name": "Universitas Pembangunan Nasional 'Veteran' Jawa Timur"
    },
    {
      "type": "Master degree",
      "name": "Monash University"
    }
  ]
}


# Create Docker Container
  
## Command
docker compose create

## YAML Configuration
services:
  nginx-example:
    container_name: nginx-example
    image: nginx:latest


# Display List of Docker Containers
docker compose ps

# Start Docker Containers
docker compose start

# Stop Docker Containers
docker compose stop

# Delete Docker Containers
docker compose down

# Display List of Running Projects
docker compose ls


# Create multiple services

## YAML Configuration
services:
  container-name1:
    container_name: container-name1
    image: image-name1:tag-name1
  container-name2:
    container_name: container-name2
    image: image-name2:tag-name2

## Command
docker compose create
docker compose start


# Add Port Forwarding

## Short Syntax
ports:
  - protocol: tcp/udp
    published: HOSTPORT
    target: CONTAINERPORT

## Long Syntax
  ports:
    - "HOSTPORT:CONTAINERPORT"


# Environment Variable
  environment:
    key: value


# Mount Binding

## Short Syntax
  volumes:
    - "SOURCE:TARGET:MODE"

## Long Syntax
  volumes:
    - type: bind/volume
      source: SOURCE
      target: TARGET


# Create Volume
  volumes:
    unique-key:
      name: unique-key

# Create Network
  networks:
    unique-key:
      name: unique-key
      driver: host/bridge

# Create Depends On
  depends_on:
    - container_name

# Restart Container
  restart: options

# OPTIONS
# - no : never restart by default
# - always : always restart if the container stops
# - on-failure : restart if the container encounters an error upon exit
# - unless-stopped : always restart the container, except when stopped manually

# Realtime logs of Docker events for specific container
docker events --filter 'container=container-name'

# Configure resource limits for Docker container
deploy:
  resources:
    reservations:     # Minimum resources reserved for this container
      cpus: "0.50"    
      memory: "256M"  
    limits:           # Maximum resources the container can use
      cpus: "1.00"    
      memory: "512M"  

# Define docker image from Dockerfile
    build:
      context: "path/to/app"        # The folder used as build context (contains source code & Dockerfile)
      dockerfile: dockerfile-name   # The specific Dockerfile to use (default is just "Dockerfile")
    image: "imagename:tagname"      # The name and tag of resulting image

# Define health check for service
  healthcheck:
    test: ["CMD", "COMMAND"]  # Command to run inside the container
    interval: DURATION        # How often to run the check
    timeout: DURATION         # Max time allowed for a single check
    start_period: DURATION    # Grace period before checks start
    retries: N                # Failures allowed before "unhealthy"

# Extend service using multiple Compose files
docker compose -f docker-compose-1.yaml -f docker-compose-2.yaml