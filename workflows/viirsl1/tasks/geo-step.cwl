# vim: ft=yaml:
cwlVersion: v1.2
class: CommandLineTool
id: viirsl1-geo
baseCommand: [geolocate]
requirements:
  DockerRequirement:
    dockerPull: gitlab.ssec.wisc.edu:5555/sips/mdps-images/viirsl1:20250210-3

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
