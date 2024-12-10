# vim: ft=yaml:
cwlVersion: v1.2
class: CommandLineTool
baseCommand: ["/software/run_l3_aggr.py", "--verbose"]
requirements:
  DockerRequirement:
    dockerPull: gitlab.ssec.wisc.edu:5555/sips/mdps-images/mvcm_l3
inputs:
  indir:
    type: Directory
    inputBinding:
      prefix: --indir
  collection_id:
    type: string
    inputBinding:
      prefix: --collection_id
outputs:
  outfile:
    type: File
    outputBinding:
      glob: CLDMSK_M3*.nc
  outdir:
    type: Directory
    outputBinding:
      glob: .