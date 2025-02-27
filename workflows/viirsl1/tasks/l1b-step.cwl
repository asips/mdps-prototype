# vim: ft=yaml:
cwlVersion: v1.2
class: CommandLineTool
id: viirsl1-l1b
baseCommand: [level1b]
requirements:
  DockerRequirement:
    dockerPull: 195353574769.dkr.ecr.us-west-2.amazonaws.com/asips/viirsl1:20250227-1

inputs:
  input:
    type: Directory
    inputBinding:
      position: 0
  collection_id:
    type: string
    inputBinding:
      position: 1
  granlen:
    type: int
    label: granule length in minuts
    default: 6
    inputBinding:
      prefix: -d

outputs:
  outdir:
    type: Directory
    outputBinding:
      glob: .
#  cdg:
#    type: File
#    outputBinding:
#      glob: "V??02CDG.A*.nc"
  mod:
    type: File
    outputBinding:
      glob: "V??02MOD.A*.nc"
  dnb:
    type: File
    outputBinding:
      glob: "V??02DNB.A*.nc"
  img:
    type: File
    outputBinding:
      glob: "V??02IMG.A*.nc"
