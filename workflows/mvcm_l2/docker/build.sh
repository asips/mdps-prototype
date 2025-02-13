#!/bin/bash
#
tag=latest
if [[ -n $1 ]]; then
  tag=$1
fi

OISST2BIN_DELIVERY=20230619-1
MVCM_DELIVERY=20201008-1
L1BSCALE_DELIVERY=20230719-1
DEMLW_STATIC_VER=0.2017.11.07

function install_mvcm_delivery() {
  local dpath=workflows/mvcm_l2/software/mvcm/
  echo "Installing MVCM into ${dpath}"
  mkdir -pv $dpath
  rsync -av --exclude NDVI --exclude test /mnt/deliveredcode/deliveries/mvcm/${MVCM_DELIVERY}/ ${dpath} 
  mkdir -pv ${dpath}/dist/data/NDVI
  for fpath in /mnt/deliveredcode/deliveries/mvcm/${MVCM_DELIVERY}/dist/data/NDVI/*.hdf; do 
    echo compressing ${fpath}
    hrepack -t '*:GZIP 5' -i ${fpath} -o ${dpath}/dist/data/NDVI/$( basename ${fpath} )
  done
}

function install_oisst2bin_delivery() {
  local dpath=workflows/mvcm_l2/software/oisst2bin/
  echo "Installing oisst2bin into ${dpath}"
  mkdir -p ${dpath}
  rsync -av --exclude env/ --exclude test /mnt/deliveredcode/deliveries/oisst_nc2bin/${OISST2BIN_DELIVERY}/ ${dpath}
  mkdir -p ${dpath}/dist/env/share/eccodes/definitions
  rsync -av /mnt/deliveredcode/deliveries/oisst_nc2bin/${OISST2BIN_DELIVERY}/dist/env/share/eccodes/ ${dpath}/dist/env/share/eccodes/
}

function install_l1bscale_delivery() {
  local dpath=workflows/mvcm_l2/software/l1bscale/
  echo "Installing L1BSCALE into ${dpath}"
  mkdir -p $dpath
  rsync -av --exclude test /mnt/deliveredcode/deliveries/viirs_l1bscale/${L1BSCALE_DELIVERY}/ ${dpath}
}

function install_demlw_static() {
  local dpath=workflows/mvcm_l2/software/demlw-static/
  local demlw_src=/mnt/software/support/demlw-static/${DEMLW_STATIC_VER}
  mkdir -p $dpath
  for fpath in $demlw_src/*.hdf; do 
    echo compressing ${fpath}
    hrepack -t '*:GZIP 5' -i ${fpath} -o ${dpath}/$(basename $fpath) 
  done
  for fn in README SOURCE lw-cache.npy; do 
    cp $demlw_src/$fn $dpath
  done
}


test -d workflows/mvcm_l2/software/mvcm || install_mvcm_delivery
test -d workflows/mvcm_l2/software/oisst2bin || install_oisst2bin_delivery
test -d workflows/mvcm_l2/software/l1bscale || install_l1bscale_delivery
test -d workflows/mvcm_l2/software/demlw-static || install_demlw_static

docker build \
  --build-arg=basetag=latest \
  -t gitlab.ssec.wisc.edu:5555/sips/mdps-images/mvcm_l2:${tag} \
  -f workflows/mvcm_l2/docker/Dockerfile \
  workflows/mvcm_l2
