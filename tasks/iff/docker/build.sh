#!/bin/bash
version=2.7.3
docker build \
  -t gitlab.ssec.wisc.edu:5555/sips/mdps-prototype/iff:${version} \
  -f docker/Dockerfile \
  .
