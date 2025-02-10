# vim: ft=yaml:
cwlVersion: v1.2
class: CommandLineTool
id: viirsl1-l1a
baseCommand: [level1a]
#arguments: ["noaa20", "l1a"]
# FIXME: Necessary to map 101 to success because incomplete scans cause it to exit 101 because
#        we have not provided inputs with full context.
successCodes: [0, 101]
requirements:
  DockerRequirement:
    dockerPull: gitlab.ssec.wisc.edu:5555/sips/mdps-images/viirsl1:20250210
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
  catalogname:
    type: string
    label: catalog name
    default: catalog.json
    inputBinding:
      prefix: -c
outputs:
  outdir:
    type: Directory
    outputBinding:
      glob: .
  l1a:
    type: File
    outputBinding:
      glob: "V*01.A*.nc"
