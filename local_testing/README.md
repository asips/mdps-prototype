# Local Testing


Assumptions:
- this is checked out to ~/code/mdps-prototype
- we are currently in a python env with cwltool and unity-sds installed


## Running all 4 stages in order:

```
cd ~/code/mdps-prototype
bash step0_run_l0split.sh
bash step1_run_l0prep.sh
bash step2_run_l1a.sh
bash step3_run_l1b.sh
```

Step0 will download 2-hour L0 files from https, after that all other stages will
use the previous stages outputs

## Timings:
```
35 seconds: step0(l0split)
13 seconds: step1(l0prep)
13 seconds: step2(l1a)
28 seconds: step3(l1b)
```

## Opinions:

- The goal with this local testing directory was to make getting inputs for the
  current task easier. I feel like that helps debugging our individiual docker
  containers and scripts.


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
