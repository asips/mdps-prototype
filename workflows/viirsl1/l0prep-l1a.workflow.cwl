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
  collection_id: string

outputs:
  outdir:
    type: Directory
  l1a:
    type: File
    outputSource: l1a/l1a

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
  l1a:
    run: tasks/l1a-step-nocat.cwl
    in:
      input: inputdir
      collection_id: collection_id
      apid826: sci/merged
      apid11: apid11/merged
      apid8: apid8/merged
      apid0: apid0/merged
    out: [outdir, l1a]
