# vim: ft=yaml:
cwlVersion: v1.2
class: CommandLineTool
id: viirsl1-l1a
baseCommand: [level1a-nocat]
#arguments: ["noaa20", "l1a"]
# FIXME: Necessary to map 101 to success because incomplete scans cause it to exit 101 because
#        we have not provided inputs with full context.
successCodes: [0, 101]
requirements:
  DockerRequirement:
    dockerPull: gitlab.ssec.wisc.edu:5555/sips/mdps-images/viirsl1:20250130
inputs:
  collection_id:
    type: string
    inputBinding:
      position: 0
  apid826:
    type: File
    inputBinding:
      position: 1
  apid11:
    type: File
    inputBinding:
      position: 2
  apid8:
    type: File
    inputBinding:
      position: 3
  apid0:
    type: File
    inputBinding:
      position: 4
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
  l1a:
    type: File
    outputBinding:
      glob: "V*01.A*.nc"
