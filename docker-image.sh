# Display version of Docker
docker version

# Display List of Images
docker image ls

# Download docker image
docker image pull imagename:tag

# Delete docker image
docker image rm imagename:tag

# Display running docker container
docker container ls

# Display all docker containers, including stopped ones
docker container ls -a

# Create docker container
docker container create --name containername imagename:tag

# Running docker container
docker container start containerid / containername

# Stop docker container
docker container stop containerid / containername

# Remove docker container
docker container rm containerid / containername

# Display logs docker container
docker container logs containerid / containername

# Display docker container logs realtime
docker container logs -f containerid / containername

# Execute interactive terminal in docker container
docker container exec -i -t containername /bin/bash

# Forwarding ports from host machine to container
docker container create --name containername --publish porthost:portcontainer image:tag

# Add environment variables
docker container create --name mongoexample --publish porthost:portcontainer -env key=value image:tag

# Display statistics of running containers
docker container stats

# Set container resource limits
docker container create --name containername --memory memorysize --cpus cpusize --publish porthost:portcontainer image:tag

# Perform docker mount binding for folder sharing in the container
docker container create --name containername --publish porthost:portcontainer --mount "type=bind,source=folder,destination=folder,readonly" image:tag 

# Dipslay list of docker volumes
docker volume ls

# Create docker volume
docker volume create volumename

# Delete docker volume
docker volume rm volumename

# Perform docker mount volume for folder sharing in the container
docker container create --name containername --publish porthost:portcontainer --mount "type=volume,source=folder,destination=folder" image:tag

# Backup data from docker volume
/* 
    1. Stop container that is using volume you want to back up.  
    2. Create temporary container with two mounts:  
        - Volume you want to back up.  
        - Bind mount to a folder on the host (as the backup storage location).  
    3. Run a backup command inside the container by archiving the contents of volume and saving archive to host folder.  
    4. Backup file is now available in host folder.  
    5. Remove temporary container used for backup process (optional).
*/

# Manual
docker container create --name containername --mount "type=bind,source=/path/on/host/backup,destination=/backup" --mount "type=volume,source=my-docker-volume,destination=/data" image:tag
tar cvf /backup/my-volume-backup.tar.gz /data

# Automatic
docker container run --rm --name containername --mount "type=bind,source=/path/to/backup,destination=/backup" --mount "type=volume,source=volumename,destination=/data" image:tag tar cvf /backup/backup-data.tar.gz /data

# Restore backup data to docker volume
docker container run --rm --name containername --mount "type=bind,source=/path/to/backup,destination=/backup" --mount "type=volume,source=volumename,destination=/data" image:tag bash -c "tar xvf /backup/backup-data.tar.gz"