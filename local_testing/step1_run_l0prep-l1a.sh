#!/bin/bash
#
# This script will run l0prpep which merges 6 min files to 6:20
# Requrires that l0split was previously run
#


# override the default /tmp that cwltool uses as some steps are large inputs
rm -fr tmp
mkdir -p tmp
export TMPDIR=tmp/

collection_id=P159-merged

# This is the directory where mdps-prototype is checked out to
protodir=$HOME/code/mdps-prototype

# Make a directory to stage our inputs
mkdir -p $protodir/local_testing/l0prep-inputs/$collection_id/
cd $protodir/local_testing/l0prep-inputs/$collection_id/

# grab our input data from upstream test of l0split, need the 00:00, 00:06, 00:12
rsync -auv $protodir/local_testing/l0split-outputs/*/P159*T192440000*.PDS .
rsync -auv $protodir/local_testing/l0split-outputs/*/P159*T192440006*.PDS .
rsync -auv $protodir/local_testing/l0split-outputs/*/P159*T192440012*.PDS .

# Run catgen and create a feature collection
python $protodir/scripts/catgen -t collection "$collection_id" P159\*.PDS
mv catalog.json stage-in-results.json

# Move up a directory and write our input yaml
cd ../
cat <<EOF >$collection_id.yaml
inputdir:
  class: Directory
  path: ./$collection_id
granule: "2019-09-01T00:06:00Z"
collection_id: "urn:nasa:unity:asips:int:$collection_id"
download_type: HTTP
EOF

cd $protodir

# Run cwltool
cwltool \
    --outdir=./local_testing/l0prep-l1a-outputs/ \
    $protodir/workflows/viirsl1/l0prep-l1a.workflow.cwl \
    $protodir/local_testing/l0prep-inputs/$collection_id.yaml
