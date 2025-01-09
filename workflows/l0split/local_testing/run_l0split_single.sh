#!/bin/bash
#
# This script will execute a local run using cwltool, example usage:
#
#    bash run_l0split_single.sh \
#        P1590000-T \
#        https://sipsdev.ssec.wisc.edu/~steved/P1590000AAAAAAAAAAAAAT19244050140701.PDS
#

collection_id=$1
level0_url=$2
level0_fn=`basename $level0_url`

# This is the directory where mdps-prototype is checked out to
protodir=$HOME/code/mdps-prototype

# Make a directory to stage our inputs
mkdir -p $protodir/workflows/l0split/local_testing/inputs/$collection_id
pushd $protodir/workflows/l0split/local_testing/inputs/$collection_id

# download the L0 file
curl -O "$level0_url"

# Run catgen and create a feature collection
python $protodir/scripts/catgen -t collection "$collection_id" "$level0_fn"
mv catalog.json stage-in-results.json

# Move up a directory and write our input yaml
cd ../
cat <<EOF >$collection_id.yaml
input:
  class: Directory
  path: ./$collection_id
collection_id: "urn:nasa:unity:asips:int:$collection_id"
download_type: HTTP
EOF

# Move back to the directory we started in
popd

# cwltool uses /tmp by default but these files can be large
# let's make a local directory and set TMPDIR to it
mkdir tmp
export TMPDIR=./tmp

# Run cwltool
cwltool \
    --log-dir=./logs/ \
    --outdir=./outputs/ \
    $protodir/workflows/l0split/tasks/process.cwl \
    $protodir/workflows/l0split/local_testing/inputs/$collection_id.yaml
