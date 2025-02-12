#!/bin/bash


# This is the directory where mdps-prototype is checked out to
protodir=$HOME/code/mdps-prototype

# override the default /tmp that cwltool uses as some steps are large inputs
export TMPDIR=$protodir/local_testing/tmp/
rm -fr $TMPDIR
mkdir -p $TMPDIR


for collection_id in 'foo' 'P1590000-T' 'P1590008-T' 'P1590011-T' 'P1590826VIIRSSCIENCE-T' ;
do
    if [ $collection_id == "P1590000-T" ]; then
        level0_url=https://sipsdev.ssec.wisc.edu/~steved/P1590000AAAAAAAAAAAAAT19244050140701.PDS
    elif [ $collection_id == "P1590008-T" ]; then
        level0_url=https://sipsdev.ssec.wisc.edu/~steved/P1590008AAAAAAAAAAAAAT19244050215301.PDS
    elif [ $collection_id == "P1590011-T" ]; then
        level0_url=https://sipsdev.ssec.wisc.edu/~steved/P1590011AAAAAAAAAAAAAT19244050230601.PDS
    elif [ $collection_id == "P1590826VIIRSSCIENCE-T" ]; then
        level0_url=https://sipsdev.ssec.wisc.edu/~steved/P1590826VIIRSSCIENCEAT19244050504901.PDS
    else
        echo "WARNING unknowned collection_id $collection_id"
        continue
    fi
    level0_fn=`basename $level0_url`

    # Stage our L0 files
    mkdir -p $protodir/local_testing/l0split-inputs/$collection_id
    cd $protodir/local_testing/l0split-inputs/$collection_id
    curl -O "$level0_url"

    # Run catgen and create a feature collection
    python $protodir/scripts/catgen -t collection "$collection_id,$level0_fn"

    # Rename the catalog to stage-in-results.json
    mv catalog.json stage-in-results.json

    # Move up a directory and write our input yaml
    cd ..
    cat <<EOF >$collection_id.yaml
    input:
      class: Directory
      path: ./$collection_id
    collection_id: "urn:nasa:unity:asips:int:$collection_id"
    download_type: HTTP
EOF

    # Move back to the original directory
    cd $protodir

    # Run cwltool
    cwltool \
        --outdir=./local_testing/l0split-outputs/ \
        ./workflows/l0split/tasks/process.cwl \
        ./local_testing/l0split-inputs/$collection_id.yaml

    # get rid of input L0 since we don't need that anymore
    rm $protodir/local_testing/l0split-inputs/$collection_id/$level0_fn

done


rm -f ./local_testing/l0split-outputs/*/P159*T192440018*
rm -f ./local_testing/l0split-outputs/*/P159*T19244002*
rm -f ./local_testing/l0split-outputs/*/P159*T19244003*
rm -f ./local_testing/l0split-outputs/*/P159*T19244004*
rm -f ./local_testing/l0split-outputs/*/P159*T19244005*
rm -f ./local_testing/l0split-outputs/*/P159*T1924401*

