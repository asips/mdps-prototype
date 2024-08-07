#!/bin/bash

docker build \
  -t gitlab.ssec.wisc.edu:5555/sips/mdps-prototype/mvcm:20240807-1 \
  --build-arg=version=20240807-1 \
  -f docker/Dockerfile \
  .
