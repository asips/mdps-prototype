#!/bin/bash
rm -rf outputs
exec cwltool \
  --cachedir=./cache \
  --parallel \
  --outdir=./outputs \
  --log-dir=./outputs \
  workflows/mvcm_only/mvcm.workflow.cwl \
  workflows/mvcm_only/mvcm-test.inputs.yaml
