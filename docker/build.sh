#!/bin/bash

# If you are building your own image, you should change this name.
# If you don't have a docker hub account, make up a name and use the container locally.
DOCKER_HUB_USER_ID=jwgrenning
TAG=$DOCKER_HUB_USER_ID/cpputest-runner

time sudo docker build -f $(dirname $0)/Dockerfile \
		--tag $TAG \
		. 2>&1 | tee docker-build.log

