# vim: ft=yaml:
cwlVersion: v1.2
class: Workflow

requirements:
  SubworkflowFeatureRequirement: {}
  NetworkAccess:
    networkAccess: true
  StepInputExpressionRequirement: {}

inputs:
  stage_in_dir: Directory
  file1: string

outputs: {}

steps:
  process:
    run: process.cwl
    in:
      file1: file1
      input_dir: stage_in_dir 
    out: [outdir]
