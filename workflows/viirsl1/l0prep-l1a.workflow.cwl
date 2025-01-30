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

outputs:
  outdir:
    type: Directory
  l1a:
    type: File
    outputSource: l1a/l1a

steps:
  stage_in:
    run: "http://awslbdockstorestack-lb-1429770210.us-west-2.elb.amazonaws.com:9998/api/ga4gh/trs/v2/tools/%23workflow%2Fdockstore.org%2Fmike-gangl%2Funity-OGC-example-application/versions/1/PLAIN-CWL/descriptor/%2Fstage_in.cwl"
    in:
      download_type: download_type
      stac_json: stac_json
      unity_client_id: unity_client_id
    out: [stage_in_collection_file, stage_in_download_dir]


  apid0:
    run: tasks/l0prep.cwl
    in:
      granule: granule
      regex:
        valueFrom: "P...0000.*.PDS"
      inputdir: stage_in/stage_in_download_dir
    out: [merged]
  apid8:
    run: tasks/l0prep.cwl
    in:
      granule: granule
      regex:
        valueFrom: "P...0008.*.PDS"
      inputdir: stage_in/stage_in_download_dir
    out: [merged]
  apid11:
    run: tasks/l0prep.cwl
    in:
      granule: granule
      regex:
        valueFrom: "P...0011.*.PDS"
      inputdir: stage_in/stage_in_download_dir
    out: [merged]
  sci:
    run: tasks/l0prep.cwl
    in:
      granule: granule
      regex:
        valueFrom: "P...0826.*.PDS"
      inputdir: stage_in/stage_in_download_dir
    out: [merged]
  l1a:
    run: tasks/l1a-step-nocat.cwl
    in:
      collection_id: collection_id
      apid826: sci/merged
      apid11: apid11/merged
      apid8: apid8/merged
      apid0: apid0/merged
    out: [outdir, l1a]

  stage_out:
    run: "http://awslbdockstorestack-lb-1429770210.us-west-2.elb.amazonaws.com:9998/api/ga4gh/trs/v2/tools/%23workflow%2Fdockstore.org%2Fmike-gangl%2Funity-OGC-example-application/versions/1/PLAIN-CWL/descriptor/%2Fstage_in.cwl"
    in:
      output_dir: l1a/outdir
      result_path_prefix:
        valueFrom: "stage_out"
      staging_bucket:
        valueFrom: "asips-int-unity-data"
      collection_id: collection_id
    out: [failed_features, stage_out_results, successful_features]

