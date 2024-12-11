# vim: ft=yaml:
cwlVersion: v1.2
class: Workflow

requirements:
  SubworkflowFeatureRequirement: {}
  NetworkAccess:
    networkAccess: true
  StepInputExpressionRequirement: {}
  InlineJavascriptRequirement: {}
  EnvVarRequirement:
    envDef: 
      CCSDS_LOG: debug 

inputs:
  inputdir: Directory
  granule: string

outputs:
  apid0: 
    type: File
    outputSource: apid0/merged
  apid8: 
    type: File
    outputSource: apid8/merged
  apid11: 
    type: File
    outputSource: apid11/merged
  sci: 
    type: File
    outputSource: sci/merged

steps:
  apid0:
    run: tasks/l0prep.cwl
    in:
      granule: granule
      regex:
        valueFrom: "P...0000.*.PDS"
      inputdir: inputdir 
    out: [merged]
  apid8:
    run: tasks/l0prep.cwl
    in:
      granule: granule
      regex:
        valueFrom: "P...0008.*.PDS"
      inputdir: inputdir 
    out: [merged]
  apid11:
    run: tasks/l0prep.cwl
    in:
      granule: granule
      regex:
        valueFrom: "P...0011.*.PDS"
      inputdir: inputdir 
    out: [merged]
  sci:
    run: tasks/l0prep.cwl
    in:
      granule: granule
      regex:
        valueFrom: "P...0826.*.PDS"
      inputdir: inputdir 
    out: [merged]
