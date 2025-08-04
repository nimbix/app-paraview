SERIAL_NUMBER=$(DATE).1000
PARAVIEW_VERSION=6.0.0
CUR_DATE=$(shell date +%Y-%m-%d)
IMAGE=us-docker.pkg.dev/jarvice/images/app-paraview:$(PARAVIEW_VERSION)-$(CUR_DATE)
all:
	docker build \
		--pull \
		--rm \
		-f "Dockerfile" \
		-t $(IMAGE) \
		--build-arg SERIAL_NUMBER=$(SERIAL_NUMBER) \
		--build-arg PARAVIEW_VERSION=$(PARAVIEW_VERSION) "."

push: all
	docker push $(IMAGE)
