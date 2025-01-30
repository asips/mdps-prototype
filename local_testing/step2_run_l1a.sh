#!/bin/bash
#
# This script will execute a local run using cwltool, example usage:
#


# this is out output collection_id
collection_id=VJ101

# This is the directory where mdps-prototype is checked out to
protodir=$HOME/code/mdps-prototype

# override the default /tmp that cwltool uses as some steps are large inputs
rm -fr tmp
mkdir -p tmp
export TMPDIR=tmp/

# Make a directory to stage our inputs
mkdir -p $protodir/local_testing/l1a-inputs/$collection_id/
cd $protodir/local_testing/l1a-inputs/$collection_id/

# Use output from l0prep stage
rsync -auv $protodir/local_testing/l0prep-outputs/* .
for fn in ./*.PDS.merged; do
    # strip off the .merged part
    mv $fn "${fn%.*}"
done;

# Run catgen and create a feature collection
python $protodir/scripts/catgen -t collection "$collection_id" P159\*.PDS

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
    --outdir=./local_testing/l1a-outputs/ \
    $protodir/workflows/viirsl1/tasks/l1a-step.cwl \
    $protodir/local_testing/l1a-inputs/$collection_id.yaml
