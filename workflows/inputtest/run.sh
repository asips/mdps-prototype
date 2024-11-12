#!/bin/bash

if [[ ! -d inputs ]]; then
  mkdir -p inputs
  touch inputs/VNP02MOD.A2024001.0006.021.nrt.nc
  cd inputs
  ../../../scripts/catgen mycollection *.nc
fi

PATH=$PATH:$PWD cwltool workflow.cwl inputs.yaml
