#!/bin/bash
#
# This script will execute a local run using cwltool, example usage:
#


# this is out output collection_id
collection_id=CLDMSK_L2_VIIRS_NOAA20

# This is the directory where mdps-prototype is checked out to
protodir=${MDPS_DIR:-$HOME/code/mdps-prototype}

# override the default /tmp that cwltool uses as some steps are large inputs
export TMPDIR=$protodir/local_testing/tmp/
rm -rf $TMPDIR
mkdir -p $TMPDIR

# Make a directory to stage our inputs
mkdir -p $protodir/local_testing/mvcm_l2-inputs/$collection_id/
cd $protodir/local_testing/mvcm_l2-inputs/$collection_id/

# start from the l1b/geo outputs
rsync -av $protodir/local_testing/l1b-outputs/*/VJ102MOD.*.nc .
rsync -av $protodir/local_testing/geo-outputs/*/VJ103MOD.*.nc .

# stage ancillary inputs
curl -O "https://sipsdev.ssec.wisc.edu/~zgriffith/mdps-inputs/gdas1.PGrbF00.190901.00z"
curl -O "https://sipsdev.ssec.wisc.edu/~zgriffith/mdps-inputs/gdas1.PGrbF00.190901.06z"
curl -O "https://sipsdev.ssec.wisc.edu/~zgriffith/mdps-inputs/NISE_SSMISF18_20190901.HDFEOS"
curl -O "https://sipsdev.ssec.wisc.edu/~zgriffith/mdps-inputs/oisst-avhrr-v02r01.20190901.nc"

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
    --outdir=./local_testing/mvcm_l2-outputs/ \
    $protodir/workflows/mvcm_l2/tasks/process.cwl \
    $protodir/local_testing/mvcm_l2-inputs/$collection_id.yaml
