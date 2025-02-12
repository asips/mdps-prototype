# Local Testing


Assumptions:
- this is checked out to ~/code/mdps-prototype
- we are currently in a python env with cwltool and unity-sds installed

## Note:
You have to have the docker images on your machine tagged with the aws name as
that is what is referenced in the cwl task, for instnace this is the current
viirsl1 iamge
```
$ docker images | head -n2
REPOSITORY                                                   TAG                 IMAGE ID       CREATED         SIZE
195353574769.dkr.ecr.us-west-2.amazonaws.com/asips/viirsl1   20250210-3          6533f2bd2af4   41 hours ago    4.94GB
```


## Running all 4 stages in order:

```
cd ~/code/mdps-prototype/local_testing
bash step0_run_l0split.sh
bash step1_run_l0prep-l1a.sh
bash step2_run_l1b.sh
bash step3_run_geo.sh
```

Step0 will download 2-hour L0 files from https, after that all other stages will
use the previous stages outputs

## Timings:
```
 35 seconds: step0(l0split)
 20 seconds: step1(l0prep-l1a)
 28 seconds: step2(l1b)
386 seconds: step3(geo)
```

## Opinions:

- The goal with this local testing directory was to make getting inputs for the
  current task easier. I feel like that helps debugging our individiual docker
  containers and scripts.
- The other goal was to keep all of test testing junk out of the workflow
  directories such that those are easier to understand.  For isntance

```
$ cd ~/code/mdps-prototype/workflows/
$ tree l0split/
l0split/
├── docker
│   └── Dockerfile
├── l0split.workflow.cwl
└── tasks
    └── process.cwl
```

That is the simplest workflow as it just has 3 files need and technically the
workflow.cwl is only needed in MDPS.  For local testing we run just the
process.cwl

Here is a slightly more complicated workflow as there are 3 parts:
- l0prep (i.e. merge)
- l1a
- l1b

```
$ tree viirsl1
viirsl1
├── docker
│   ├── build.sh
│   ├── Dockerfile
│   └── requirements.txt
├── scripts
│   ├── l0prep
│   ├── level1a
│   └── level1b
├── tasks
│   ├── l0prep.cwl
│   ├── l1a-step.cwl
│   ├── l1b-step.cwl
│   ├── process.cwl
│   └── stage_in.cwl
├── l0prep.workflow.cwl
└── viirsl1.workflow.cwl
```


## Results

When done the user should have all of these outputs available:

```
$ tree *-outputs
l0prep-outputs
├── P1590000AAAAAAAAAAAA6T19244000000001.PDS.merged
├── P1590008AAAAAAAAAAAA6T19244000000001.PDS.merged
├── P1590011AAAAAAAAAAAA6T19244000000001.PDS.merged
└── P1590826VIIRSSCIENCE6T19244000000001.PDS.merged
l0split-outputs
├── 1pzd6s04
│   ├── catalog.json
│   ├── P1590000AAAAAAAAAAAA6T19244000000001.json
│   ├── P1590000AAAAAAAAAAAA6T19244000000001.PDS
│   ├── P1590000AAAAAAAAAAAA6T19244000600001.json
│   ├── P1590000AAAAAAAAAAAA6T19244000600001.PDS
│   ├── P1590000AAAAAAAAAAAA6T19244001200001.json
│   └── P1590000AAAAAAAAAAAA6T19244001200001.PDS
├── 2_kvfiji
│   ├── catalog.json
│   ├── P1590008AAAAAAAAAAAA6T19244000000001.json
│   ├── P1590008AAAAAAAAAAAA6T19244000000001.PDS
│   ├── P1590008AAAAAAAAAAAA6T19244000600001.json
│   ├── P1590008AAAAAAAAAAAA6T19244000600001.PDS
│   ├── P1590008AAAAAAAAAAAA6T19244001200001.json
│   └── P1590008AAAAAAAAAAAA6T19244001200001.PDS
├── 30r2c9uc
│   ├── catalog.json
│   ├── P1590011AAAAAAAAAAAA6T19244000000001.json
│   ├── P1590011AAAAAAAAAAAA6T19244000000001.PDS
│   ├── P1590011AAAAAAAAAAAA6T19244000600001.json
│   ├── P1590011AAAAAAAAAAAA6T19244000600001.PDS
│   ├── P1590011AAAAAAAAAAAA6T19244001200001.json
│   └── P1590011AAAAAAAAAAAA6T19244001200001.PDS
└── 99vhewrq
    ├── catalog.json
    ├── P1590826VIIRSSCIENCE6T19244000000001.json
    ├── P1590826VIIRSSCIENCE6T19244000000001.PDS
    ├── P1590826VIIRSSCIENCE6T19244000600001.json
    ├── P1590826VIIRSSCIENCE6T19244000600001.PDS
    ├── P1590826VIIRSSCIENCE6T19244001200001.json
    └── P1590826VIIRSSCIENCE6T19244001200001.PDS
l1a-outputs
└── x0md84s3
    ├── catalog.json
    ├── V2019244000000.L1A_JPSS1.txt
    ├── V2019244000600.L1A_JPSS1.txt
    ├── V2019244001200.L1A_JPSS1.txt
    ├── VJ101.A2019244.0006.002.2025022203635.json
    └── VJ101.A2019244.0006.002.2025022203635.nc
l1b-outputs
└── pin_gwx7
    ├── catalog.json
    ├── V2019244000600.L1A_JPSS1.nc
    ├── VJ102CDG.A2019244.0006.021.2025022203638.json
    ├── VJ102CDG.A2019244.0006.021.2025022203638.nc
    ├── VJ102DNB.A2019244.0006.021.2025022203638.json
    ├── VJ102DNB.A2019244.0006.021.2025022203638.nc
    ├── VJ102IMG.A2019244.0006.021.2025022203638.json
    ├── VJ102IMG.A2019244.0006.021.2025022203638.nc
    ├── VJ102MOD.A2019244.0006.021.2025022203638.json
    └── VJ102MOD.A2019244.0006.021.2025022203638.nc

6 directories, 48 files
```
