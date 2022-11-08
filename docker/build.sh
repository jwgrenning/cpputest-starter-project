#!/bin/bash

TAG=jwgrenning/cpputest-runner

time sudo docker build -f $(dirname $0)/Dockerfile \
		--tag $TAG \
		. 2>&1 | tee docker-build.log

