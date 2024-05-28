SERIAL_NUMBER=20240526.1000
PARAVIEW_VERSION=5.12.1
CUR_DATE=$(shell date +%Y-%m-%d)
IMAGE=us-docker.pkg.dev/jarvice/images/app-paraview:$(PARAVIEW_VERSION)-$(CUR_DATE)
all:
	podman build \
		--jobs 0 \
		--pull \
		--rm \
		-f "Dockerfile" \
		-t $(IMAGE) \
		--build-arg SERIAL_NUMBER=$(SERIAL_NUMBER) \
		--build-arg PARAVIEW_VERSION=$(PARAVIEW_VERSION) "."

push: all
	podman push $(IMAGE)
