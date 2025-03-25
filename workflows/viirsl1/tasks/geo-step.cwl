# vim: ft=yaml:
cwlVersion: v1.2
class: CommandLineTool
id: viirsl1-geo
baseCommand: [geolocate]
requirements:
  DockerRequirement:
    dockerPull: 195353574769.dkr.ecr.us-west-2.amazonaws.com/asips/viirsl1:20250325-1

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
      glob: "V??03MOD.A*.nc"
  dnb:
    type: File
    outputBinding:
      glob: "V??03DNB.A*.nc"
  img:
    type: File
    outputBinding:
      glob: "V??03IMG.A*.nc"
