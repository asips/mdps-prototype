# vim: ft=yaml:
cwlVersion: v1.2
class: CommandLineTool
baseCommand: ["/software/run.py", "--verbose"]
requirements:
  DockerRequirement:
    dockerPull: 195353574769.dkr.ecr.us-west-2.amazonaws.com/asips/mvcm_l2:20240213
inputs:
  input:
    type: Directory
    inputBinding:
      prefix: --input
  collection_id:
    type: string
    inputBinding:
      prefix: --collection_id
outputs:
  outfile:
    type: File
    outputBinding:
      glob: CLDMSK_L2*.nc
  outdir:
    type: Directory
    outputBinding:
      glob: .
