#!/bin/bash
set -e

# build our container
bash ./workflows/viirsl1/docker/build.sh

# remove any results from previous run
rm -fr tmp/
mkdir -p tmp/workdir
export TMPDIR=tmp/workdir

time cwltool \
  --outdir=tmp/outputs/ \
  --log-dir=tmp/logs/ \
  --debug \
  workflows/viirsl1/tasks/l1b-step.cwl \
  workflows/viirsl1/tasks/inputs-l1b.yaml \
  |& tee tmp/log
