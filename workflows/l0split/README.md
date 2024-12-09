# Level-0 File Splitting

## Execute locally (i.e., not in docker)
This assumes the `ccsds` command line tool is on `PATH`. It can be downloaded from
here: https://github.com/bmflynn/ccsds-rs/commits/0.1.0-beta.11

Make sure the necessary scripts are on the path
```
export PATH=$PWD/workflows/scripts
```

Run the workflow
```
rm -fr tmp/
mkdir tmp/

cwltool \
    --outdir=./tmp/outputs \
    --log-dir=./tmp/logs \
    ./workflows/l0split/l0split.workflow.cwl \
    ./workflows/l0split/l0split.inputs.yaml \
```


