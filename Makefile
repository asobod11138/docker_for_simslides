DOCKER_FILE=Dockerfile
IMAGE_NAME_TAG=gazebo_presentation
CONTAINER_NAME=gazebo_presentation
MOUNT=/home/asobod11138/Documents/gazebo_presentation/pdf

all:
	build

build:
	docker build -t $(IMAGE_NAME_TAG) -f $(DOCKER_FILE) .

bash:
	xhost +
	docker run --name $(CONTAINER_NAME) -it -v $(MOUNT):/root/pdf --net=host --rm --runtime=nvidia \
	       	--env="DISPLAY" \
					--privileged \
	       	$(IMAGE_NAME_TAG) bash  

exec:
	docker exec -it $(CONTAINER_NAME) bash


