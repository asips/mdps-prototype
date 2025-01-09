# Local testing of l0split

## Preimise:

Let's run cwlotool locally and generate split L0 files that can be used for
testing L1 and so on.

To run this script activate a python env with cwltool installed in it

```
bash run_l0split_all.sh
```


## Notes:

- The run_l0split_all.sh has URLS to 2-hour L0 files to use for testing
- The run_l0split_single.sh handles downloading and constructing inputs and
  finally runs cwltool
