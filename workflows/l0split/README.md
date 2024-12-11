# Level-0 File Splitting

## Execute locally w/ docker/cwltool

Designed to be run from mdsp-prototype directory
```
bash docker/build.sh
```

If you don't already have the test L0 file you need to download it:
```
curl https://sipsdev.ssec.wisc.edu/~steved/P1590000AAAAAAAAAAAAAT19244050140701.PDS \
    -o l0split/inputs-apidl0/P1590000AAAAAAAAAAAAAT19244050140701.PDS
```

Run the workflow
```
rm -fr tmp/
mkdir -p tmp/workdir
export TMPDIR=tmp/workdir

cwltool \
    --outdir=./tmp/outputs \
    --log-dir=./tmp/logs \
    /workflows/l0split/tasks/process.cwl \
    ./workflows/l0split/inputs-apid.yaml
```


