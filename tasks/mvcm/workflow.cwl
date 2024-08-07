# vim: ft=yaml:
cwlVersion: v1.2
$graph:
  - class: Workflow
    id: main
    label: MODIS-VIIRS Cloud Mask
    inputs:
      satellite: 
        type: string
      granule: 
        type: string
      gdas1: File
      gdas2: File
      l1b: File
      nise: File
      sst: File
    outputs:
      cldmsk_l2: 
        type: File
        outputSource: mvcm/cldmsk_l2
    steps:
      mvcm:
        run: "#mvcm"
        in:
          sat: satellite
          granule: granule
          l1b: l1b
          nise: nise
          sst: sst
          gdas1: gdas1
          gdas2: gdas2
        out: [cldmsk_l2]

  - class: CommandLineTool
    id: mvcm
    baseCommand: run.py
    stdout: stdout.txt
    stderr: stderr.txt
    requirements:
      InitialWorkDirRequirement:
        listing:
          - $(inputs.l1b) 
          - $(inputs.nise) 
          - $(inputs.sst) 
          - $(inputs.gdas1) 
          - $(inputs.gdas2) 
      DockerRequirement:
        dockerPull: gitlab.ssec.wisc.edu:5555/sips/mdps-prototype/mvcm:20240807-1
    inputs:
      sat: 
        type: string
        inputBinding:
          position: 0
      granule: 
        type: string
        inputBinding:
          position: 1
      l1b:
        type: File
        inputBinding:
          position: 2
      nise:
        type: File
        inputBinding:
          position: 3
      sst:
        type: File
        inputBinding:
          position: 4
      gdas1:
        type: File
        inputBinding:
          position: 5
      gdas2:
        type: File
        inputBinding:
          position: 6
    outputs:
      cldmsk_l2:
        type: File
        outputBinding:
          glob: "mvcm*"
