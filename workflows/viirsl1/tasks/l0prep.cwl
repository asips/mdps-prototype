# vim: ft=yaml:
cwlVersion: v1.2
class: CommandLineTool
baseCommand: [l0prep]
requirements:
  DockerRequirement:
    dockerPull: gitlab.ssec.wisc.edu:5555/sips/viirs_l1-build/viirsl1:latest
inputs:
  granule:
    type: string
    label: "Target granule timestamp; %Y-%m-%dT%H:%M:%SZ"
    inputBinding:
      position: 0
  regex:
    type: string
    label: "Regex to identify products from catalog to merge (re.fullmatch)"
    inputBinding:
      position: 1
  catalog:
    type: File
    inputBinding:
      position: 2
outputs:
  merged:
    type: File
    outputBinding:
      glob: "$(input.product).pds"
