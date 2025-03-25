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
    dockerPull: 195353574769.dkr.ecr.us-west-2.amazonaws.com/asips/viirsl1:20250325-1
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
