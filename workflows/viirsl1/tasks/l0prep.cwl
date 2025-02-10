# vim: ft=yaml:
cwlVersion: v1.2
class: CommandLineTool
baseCommand: [l0prep]
arguments:
  - "$(inputs.granule)"
  - "$(inputs.regex)"
  - "$(inputs.inputdir.path)/stage-in-results.json"
requirements:
  DockerRequirement:
    dockerPull: gitlab.ssec.wisc.edu:5555/sips/mdps-images/viirsl1:20250210-2
inputs:
  granule:
    type: string
    label: "Target granule timestamp; %Y-%m-%dT%H:%M:%SZ"
  regex:
    type: string
    label: "Regex to identify products from catalog to merge (re.fullmatch)"
  inputdir:
    type: Directory
outputs:
  merged:
    type: File
    outputBinding:
      glob: "*.merged"
