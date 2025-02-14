#!/bin/bash
#
# This script will execute a local run using cwltool, example usage:
#


# this is out output collection_id
collection_id=CLDMSK_G3_VIIRS_NOAA20

# This is the directory where mdps-prototype is checked out to
protodir=${MDPS_DIR:-$HOME/code/mdps-prototype}

# override the default /tmp that cwltool uses as some steps are large inputs
export TMPDIR=$protodir/local_testing/tmp/
rm -rf $TMPDIR
mkdir -p $TMPDIR

# Make a directory to stage our inputs
mkdir -p $protodir/local_testing/mvcm_g3-inputs/$collection_id/
cd $protodir/local_testing/mvcm_g3-inputs/$collection_id/

rsync -av $protodir/local_testing/mvcm_l2-outputs/*/CLDMSK*.nc .

# Run catgen and create a feature collection
python $protodir/scripts/catgen -t collection "$collection_id,*"

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
    --outdir=./local_testing/mvcm_g3-outputs/ \
    $protodir/workflows/mvcm_l3/tasks/process_g3.cwl \
    $protodir/local_testing/mvcm_g3-inputs/$collection_id.yaml
