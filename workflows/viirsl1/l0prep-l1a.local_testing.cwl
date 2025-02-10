# vim: ft=yaml:
cwlVersion: v1.2
class: Workflow

requirements:
  SubworkflowFeatureRequirement: {}
  NetworkAccess:
    networkAccess: true
  StepInputExpressionRequirement: {}
  InlineJavascriptRequirement: {}

inputs:
  stac_json:
    type:
      - string
      - File
  download_type:
    type: string
    default: "S3"
  unity_client_id:
    type: string
    default: "40c2s0ulbhp9i0fmaph3su9jch"
  collection_id: string
  granule: string
  inputdir: Directory

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
      granule: granule
      collection_id: collection_id
      apid826: sci/merged
      apid11: apid11/merged
      apid8: apid8/merged
      apid0: apid0/merged
    out: [outdir, l1a]
