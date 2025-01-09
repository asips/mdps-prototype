# Level-0 File Splitting

## Example of how to test out L0split locally using docker/cwltool

Assumptions:
- this is checked out to ~/code/mdps-prototype
- we are currently in a python env with cwltool and unity-sds installed

To run local testing of all 4 L0-split file types:

```
cd ~/code/mdps-prototype/workflows/l0split/local_testing
bash run_l0split_all.sh
```


## Notes:

- runtime ~30 seconds
- The run_l0split_all.sh has URLs to 2-hour L0 files to use for testing
- The run_l0split_single.sh handles downloading and constructing inputs and
  finally runs cwltool


