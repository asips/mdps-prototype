#!/usr/bin/env python3
import json
import logging
import subprocess
from dataclasses import asdict, dataclass
from pathlib import Path

LOG = logging.getLogger("mvcm_g3")


def run(*args, **kwds):
    LOG.info("running: %s", " ".join([str(s) for s in args[0]]))
    return subprocess.run(*args, **kwds)


def preyori(mvcm_l2: Path) -> Path:
    swdir = Path("/software/mvcm_preyori")
    output = Path(mvcm_l2.name.replace(".nc", "_preyori.nc"))
    run(
        [
            "python",
            swdir / "dist" / "mvcm_preproc_standard_mvcm.py",
            mvcm_l2,
            output,
        ],
        check=True,
    )
    assert output.exists()
    return output


def yori(preyori_nc: Path) -> Path:
    swdir = Path("/software/mvcm_preyori")
    output = Path(preyori_nc.name.replace("_preyori.nc", ".nc").replace("L2", "G3"))
    run(
        [
            "yori-grid",
            swdir / "dist" / "data" / "cldmsk_config_standard_mvcm.yml",
            preyori_nc,
            output,
        ],
        check=True,
    )
    assert output.exists()
    return output


@dataclass
class Inputs:
    mvcm: Path

    @staticmethod
    def from_dir(dirpath: Path):
        def findone(pat: str, expect: int = 1) -> list[Path]:
            if len(x := list(dirpath.glob(pat))) != expect:
                raise ValueError(
                    f"Expected {expect} files matching {pat}, got {len(x)}"
                )
            return x

        return Inputs(
            mvcm=findone("CLDMSK*.nc")[0],
        )


def pipeline(inputs: Inputs) -> Path:
    preyori_nc = preyori(inputs.mvcm)
    output = yori(preyori_nc)
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
    for k, v in asdict(inputs).items():
        LOG.info("input %s -> %s", k, v.absolute())

    output = pipeline(inputs)

    generate_catalog(args.collection_id, output)
