#!/bin/bash
#
# This script will execute a local run using cwltool, example usage:
#


# this is out output collection_id
collection_id=VJ102

# This is the directory where mdps-prototype is checked out to
protodir=${MDPS_DIR:-$HOME/code/mdps-prototype}

# override the default /tmp that cwltool uses as some steps are large inputs
rm -fr tmp
mkdir -p tmp
export TMPDIR=tmp/

# Make a directory to stage our inputs
mkdir -p $protodir/local_testing/l1b-inputs/$collection_id/
cd $protodir/local_testing/l1b-inputs/$collection_id/

# start from the l1a otuputs
rsync -av $protodir/local_testing/l0prep-l1a-outputs/VJ101.*.nc .

# Run catgen and create a feature collection
python $protodir/scripts/catgen -t collection "$collection_id,VJ101.*nc"

# Move up a directory and write our input yaml
cd ../
cat <<EOF >$collection_id.yaml
input:
  class: Directory
  path: ./$collection_id
collection_id: "urn:nasa:unity:asips:int:$collection_id"
download_type: HTTP
EOF

# Run cwltool
cd $protodir
cwltool \
    --outdir=./local_testing/l1b-outputs/ \
    $protodir/workflows/viirsl1/tasks/l1b-step.cwl \
    $protodir/local_testing/l1b-inputs/$collection_id.yaml
