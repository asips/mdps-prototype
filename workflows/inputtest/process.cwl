# vim: ft=yaml:
cwlVersion: v1.2
class: CommandLineTool
baseCommand: ["work.py"]
arguments: 
  - $(inputs.file1)
  - $(inputs.input_dir.path)/catalog.json
inputs:
  input_dir:
    type: Directory
  file1: string
outputs:
  outdir:
    type: Directory
    outputBinding:
      glob: .
