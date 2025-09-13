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

# Add file to docker imagae
ADD path/to/source-file path/to/destination-fike