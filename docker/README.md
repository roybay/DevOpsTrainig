# Using Docker Images

## How to build docker images 

Create a Docker file

		vi Dockerfile 

Example File

		FROM forgerock-docker-public.bintray.io/forgerock/openig:6.0.0

Build a docker image in your local ([more information](https://docs.docker.com/engine/reference/commandline/build/))

		docker build --tag <image_name>:<version_tag> .
		Ex: docker build --tag openig .


## How to pushing and pulling docker images to GCP Container Registry

More informations can be found at [GCP documants](https://cloud.google.com/container-registry/docs/pushing-and-pulling)

Local docker image need to have required name convension before pushing to google registery 

Build local image with: 

		docker build --tag [HOSTNAME]/[PROJECT-ID]/[IMAGE] .
		Ex: docker build --tag gcr.io/myproject/openig .

Tag the loacl image if it has already been built

		docker tag [HOSTNAME]/[PROJECT-ID]/[IMAGE]
		Ex: docker tag gcr.io/myproject/openig

Push the image to GCP container Registry 

		docker push gcr.io/myproject/openig
