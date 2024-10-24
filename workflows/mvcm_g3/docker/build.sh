#!/bin/bash
#
tag=latest
if [[ -n $1 ]]; then
  tag=$1
fi

MVCM_PREYORI_DELIVERY=20200508-1

function install_mvcm_preyori_delivery() {
  local dpath=workflows/mvcm_g3/software/mvcm_preyori/
  echo "Installing MVCM preyori into ${dpath}"
  mkdir -pv $dpath
  rsync -av --exclude test /mnt/deliveredcode/deliveries/mvcm_preyori/${MVCM_PREYORI_DELIVERY}/ ${dpath} 
}

test -d workflows/mvcm_g3/software/mvcm || install_mvcm_preyori_delivery

docker build \
  --build-arg=basetag=${tag} \
  -t gitlab.ssec.wisc.edu:5555/sips/mdps-images/mvcm_g3:${tag} \
  -f workflows/mvcm_g3/docker/Dockerfile \
  workflows/mvcm_g3
