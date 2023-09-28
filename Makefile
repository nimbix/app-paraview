all:
	DOCKER_BUILDKIT=1 docker build --pull --rm -f "Dockerfile" -t us-docker.pkg.dev/jarvice/images/app-paraview:5.11.2 "."

push: all
	docker push us-docker.pkg.dev/jarvice/images/app-paraview:5.11.2
