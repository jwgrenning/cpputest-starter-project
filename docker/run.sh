#!/bin/bash

TAG=jwgrenning/cpputest-runner

HOST_WORKDIR=${PWD}
WORKDIR=/home
COMMAND=${1:-/bin/bash}

sudo docker run \
  --rm \
  --name cpputest-runner \
  --volume "${HOST_WORKDIR}":"${WORKDIR}" \
  --workdir "${WORKDIR}" \
  -it $TAG \
  $COMMAND

