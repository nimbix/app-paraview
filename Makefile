SERIAL_NUMBER=20240305.1000
PARAVIEW_VERSION=5.12.0
IMAGE=us-docker.pkg.dev/jarvice/images/app-paraview:$(PARAVIEW_VERSION)
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
