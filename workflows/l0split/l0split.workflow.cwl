# vim: ft=yaml:
cwlVersion: v1.2
class: Workflow

requirements:
  SubworkflowFeatureRequirement: {}
  NetworkAccess:
    networkAccess: true
  StepInputExpressionRequirement: {}

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

outputs:
  outdir:
    type: File
    outputSource: stage_out/stage_out_results
  failed:
    type: File
    outputSource: stage_out/failed_features
  successful:
    type: File
    outputSource: stage_out/successful_features

steps:

  stage_in:
    run: "http://awslbdockstorestack-lb-1429770210.us-west-2.elb.amazonaws.com:9998/api/ga4gh/trs/v2/tools/%23workflow%2Fdockstore.org%2Fmike-gangl%2Funity-OGC-example-application/versions/2/PLAIN-CWL/descriptor/%2Fstage_in.cwl"
    in:
      download_type: download_type
      stac_json: stac_json
      unity_client_id: unity_client_id
    out: [stage_in_collection_file, stage_in_download_dir]

  process:
    run: tasks/process.cwl
    in:
      input: stage_in/stage_in_download_dir
      collection_id: collection_id
    out: [outdir]

  stage_out:
    run: "http://awslbdockstorestack-lb-1429770210.us-west-2.elb.amazonaws.com:9998/api/ga4gh/trs/v2/tools/%23workflow%2Fdockstore.org%2Fmike-gangl%2Funity-OGC-example-application/versions/2/PLAIN-CWL/descriptor/%2Fstage_out.cwl"
    in:
      output_dir: process/outdir
      result_path_prefix:
        valueFrom: "stage_out"
      staging_bucket:
        valueFrom: "asips-int-unity-data"
    out: [failed_features, stage_out_results, successful_features]
