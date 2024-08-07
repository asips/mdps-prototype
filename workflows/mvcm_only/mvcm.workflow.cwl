# vim: ft=yaml:
# Test mvcm with pre-existing input
cwlVersion: v1.2
class: Workflow
id: mvcm

requirements:
  SubworkflowFeatureRequirement: {}

inputs:
  satellite: 
    type: string
  granule:
    type: string
  gdas1: File
  gdas2: File
  iff: File
  nise: File
  sst: File

outputs:
  cldmsk_l2:
    type: File
    outputSource: mvcm/cldmsk_l2

steps:
  mvcm:
    run: ../../tasks/mvcm/workflow.cwl
    in:
      satellite: satellite
      granule: granule
      gdas1: gdas1
      gdas2: gdas2
      iff: iff
      nise: nise
      sst: sst
    out: [cldmsk_l2]
