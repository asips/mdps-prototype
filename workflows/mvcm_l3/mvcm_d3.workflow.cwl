# vim: ft=yaml:
cwlVersion: v1.2
class: Workflow
doc: |-
  Aggregate Yori granule files into a daily
  aggregate output file.

  Required input file(s):
    - 1 day of MVCM G3

  All inputs must be present in the catalog in `stac_json`

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
    default: "7vehllplbone6p4usqgutqun35"
  unity_stac_auth:
    type: string
    default: "UNITY"
  collection_id:
    type: string
    default: urn:nasa:unity:asips:int:CLDMSK_D3_VIIRS_NOAA20.001___1

outputs:
  outfile:
    type: File 
    outputSource: process/outfile
  outdir:
    type: Directory
    outputSource: process/outdir
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
      unity_stac_auth: unity_stac_auth
    out: [stage_in_download_dir]

  process:
    run: tasks/process_d3.cwl
    in:
      input: stage_in/stage_in_download_dir
      collection_id: collection_id
    out: [outdir, outfile]

  stage_out:
    run: "http://awslbdockstorestack-lb-1429770210.us-west-2.elb.amazonaws.com:9998/api/ga4gh/trs/v2/tools/%23workflow%2Fdockstore.org%2Fmike-gangl%2Funity-OGC-example-application/versions/2/PLAIN-CWL/descriptor/%2Fstage_out.cwl"
    in:
      output_dir: process/outdir
      result_path_prefix:
        valueFrom: "stage_out"
      staging_bucket:
        valueFrom: "asips-int-unity-data"
      collection_id: collection_id
    out: [failed_features, stage_out_results, successful_features]
