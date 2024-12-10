#!/usr/bin/env python3
import json
import logging
import subprocess
from dataclasses import asdict, dataclass
from datetime import datetime
from pathlib import Path
from tempfile import NamedTemporaryFile

import fnmeta

LOG = logging.getLogger("mvcm_l3_aggr")


def run(*args, **kwds):
    LOG.info("running: %s", " ".join([str(s) for s in args[0]]))
    return subprocess.run(*args, **kwds)


def yori_grid(inputs: list[Path], output: Path):
    with NamedTemporaryFile(mode="wt") as fptr:
        for fpath in inputs:
            fptr.write(str(fpath) + "\n")
        fptr.flush()
        run(
            [
                "yori-aggr",
                fptr.name,
                output,
            ],
            check=True,
        )
    assert output.exists()


@dataclass
class Inputs:
    inputs: list[Path]

    @staticmethod
    def from_dir(dirpath: Path):
        def findmany(pat: str, expect_min: int = 10) -> list[Path]:
            if len(x := list(dirpath.glob(pat))) < expect_min:
                raise ValueError(
                    f"Expected at least {expect_min} files matching {pat}, got {len(x)}"
                )
            return x

        return Inputs(
            inputs=findmany("CLDMSK*.nc"),
        )


def pipeline(inputs: Inputs) -> Path:
    input_name = inputs.inputs[0].name
    meta = fnmeta.identify(inputs.inputs[0].name)
    if not meta:
        raise ValueError(f"Failed to identify input file")
    granule = meta["begin_time"]
    created = datetime.utcnow()
    if "G3" in input_name:
        out_level = "D3"
    elif "D3" in input_name:
        out_level = "M3"
    else:
        raise ValueError(f"Unexpected input {input_name}")
    output = Path(
        f"CLDMSK_{out_level}_VIIRS_SNPP.{granule:A%Y%j}.001.{created:%Y%j%H%M%S}.nc"
    )
    yori_grid(inputs.inputs, output=output)
    return output


def generate_catalog(collection_id: str, output: Path):
    LOG.info(f"generating catalog for {collection_id=} {output=}")
    run(["catgen", collection_id, str(output)], check=True)


if __name__ == "__main__":
    import argparse

    parser = argparse.ArgumentParser()
    parser.add_argument("--verbose", action="store_true")
    parser.add_argument("--indir", type=Path)
    parser.add_argument("--collection_id")
    args = parser.parse_args()

    logging.basicConfig(level=logging.INFO, format="%(name)s -- %(message)s")
    LOG.setLevel(logging.DEBUG if args.verbose else logging.INFO)

    if not args.indir.is_dir() or not args.indir.exists():
        parser.error(f"Invalid input directory: {args.indir}")

    for path in args.indir.glob("*.json"):
        LOG.debug("%s:\n%s", path, json.dumps(json.load(open(path)), indent=2))

    inputs = Inputs.from_dir(args.indir)

    output = pipeline(inputs)

    generate_catalog(args.collection_id, output)