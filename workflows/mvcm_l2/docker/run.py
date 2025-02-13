#!/usr/bin/env python3
import json
import logging
import os
import shutil
import subprocess
from dataclasses import asdict, dataclass
from datetime import datetime, timedelta
from pathlib import Path

import fnmeta

LOG = logging.getLogger("mvcm_l2")


def run(*args, **kwds):
    LOG.info("runninng: %s", " ".join([str(s) for s in args[0]]))
    return subprocess.run(*args, **kwds)


def oisst2bin(oisst: Path, gdas: Path):
    swdir = Path("/software/oisst2bin")
    output = Path(f"oisst.{oisst.name[19:27]}")
    run(
        [
            "python",
            swdir / "source/oisst_nc2bin.py",
            str(oisst),
            str(gdas),
            swdir / "dist/inland_water.nc",
            str(output),
        ],
        check=True,
        env={
            **os.environ,
            "ECCODES_DEFINITION_PATH": str(
                swdir / "dist/env/share/eccodes/definitions"
            ),
        },
    )
    assert output.exists()
    return output


def viirsmend(l1b: Path, geo: Path) -> Path:
    """(L1B, GEO) -> Mended L1B"""
    output = Path(l1b.name.replace(".nc", ".mended.nc"))
    shutil.copy(l1b, output)
    run(
        [
            "python3",
            "-m",
            "viirsmend.l1mend",
            str(output),
            str(geo),
        ],
        check=True,
    )
    assert output.exists()
    return output


def l1bscale(satellite: str, l1b: Path) -> Path:
    """L1B -> Scaled L1B"""
    swdir = Path("/software/l1bscale")
    if satellite == "snpp":
        satellite = "npp"
    scale_factors = swdir / f"dist/{satellite}_scale_factors.txt"
    if not scale_factors.exists():
        raise ValueError(f"{scale_factors} does not exist")
    run(
        [swdir / "dist/bin/VIIRS_L1BSCALE.exe", l1b, scale_factors],
        check=True,
        env={
            **os.environ,
            "LD_LIBRARY_PATH": swdir / "dist/lib",
        },
    )
    assert l1b.exists()
    return l1b


def create_iff_filename(prefix, platform, dt, output_type="HDF4"):
    origin = "ssec"
    domain = "dev"
    suffix = {"HDF4": ".hdf", "NETCDF": ".nc"}

    begin_date = dt.strftime("d%Y%m%d")
    begin_time = dt.strftime("t%H%M%S")
    processed_time = datetime.now().strftime("c%Y%m%d%H%M%S")

    fn = "%s%s" % (
        "_".join(
            [prefix, platform, begin_date, begin_time, processed_time, origin, domain]
        ),
        suffix[output_type],
    )
    return fn


def iff(
    satellite: str,
    granule: datetime,
    l1b: Path,
    geo: Path,
    output_type: str = "HDF4",
    band_type: str = "svm",
) -> Path:
    output = Path(
        create_iff_filename(
            f"IFF{band_type.upper()}",
            satellite,
            granule,
            output_type,
        )
    ).absolute()
    run(
        [
            "python",
            "-m",
            "iff2.iff2",
            "-v",
            "-o",
            str(output),
            "--hdf4" if output_type == "HDF4" else "",
            satellite,
            "viirs-nasa",
            band_type,
            f"{granule:%Y%m%d}",
            f"{granule:%H%M%S}",
            f"{granule + timedelta(minutes=6, seconds=-1):%H%M%S}",
            str(l1b),
            str(geo),
        ],
        check=True,
    )
    assert output.exists()
    return output


def mvcm(
    satellite: str,
    granule: datetime,
    iffsvm: Path,
    nise: Path,
    gdas: tuple[Path, Path],
    sst: Path,
) -> Path:
    swdir = Path("/software/mvcm")
    created = datetime.utcnow()
    output = Path(
        f"CLDMSK_L2_VIIRS_{satellite.upper()}.{granule:A%Y%j.%H%M}.001.{created:%Y%j%H%M%S}.nc"
    )
    run(
        [
            swdir / "dist/run.py",
            "--out",
            str(output),
            satellite,
            granule.strftime("%Y-%j %H:%M:%S"),
            str(iffsvm.absolute()),
            str(nise.absolute()),
            str(sst.absolute()),
            str(gdas[0].absolute()),
            str(gdas[1].absolute()),
        ],
        env={
            **os.environ,
            "LD_LIBRARY_PATH": swdir / "dist/lib",
        },
        check=True,
    )
    assert output.exists()
    return output


@dataclass
class Inputs:
    l1b: Path
    geo: Path
    sst: Path
    nise: Path
    gdas1: Path
    gdas2: Path

    @staticmethod
    def from_dir(dirpath: Path):
        def findone(pat: str, expect: int = 1) -> list[Path]:
            if len(x := list(dirpath.glob(pat))) != expect:
                raise ValueError(
                    f"Expected {expect} files matching {pat}, got {len(x)}"
                )
            return x

        gdas = list(sorted(findone("gdas1.PGrbF00.*z", expect=2)))
        return Inputs(
            l1b=findone("V??02MOD.A*.nc")[0],
            geo=findone("V??03MOD.A*.nc")[0],
            sst=findone("oisst-avhrr*.nc")[0],
            nise=findone("NISE_*.HDFEOS")[0],
            gdas1=gdas[0],
            gdas2=gdas[1],
        )


def demlw(iff: Path) -> Path:
    swdir = Path("/software/demlw-static")
    run(
        [
            "python",
            "-m",
            "demlw.ifflw",
            iff,
        ],
        env={
            **os.environ,
            # Land Water Data
            "DEMLW_DIR": str(swdir),
            # Land Water Cache starting in version 1.2
            "LW_CACHE_FILE": str(swdir / "lw-cache.npy"),
        },
    )
    return iff


def pipeline(inputs: Inputs) -> Path:
    meta = fnmeta.identify(inputs.l1b.name)
    if not meta:
        raise ValueError(f"Failed to identify {inputs.l1b}")
    granule = meta["begin_time"]
    satellite = meta["satellite"]["name"]
    LOG.info(f"parsed {satellite=} {granule=}")

    l1b = viirsmend(inputs.l1b, inputs.geo)
    l1b = l1bscale(satellite, l1b)
    iffsvm = iff(satellite, granule, l1b, inputs.geo)
    iffsvm = demlw(iffsvm)
    sst = oisst2bin(inputs.sst, inputs.gdas1)

    output = mvcm(
        satellite,
        granule,
        iffsvm,
        inputs.nise,
        (inputs.gdas1, inputs.gdas2),
        sst,
    )
    return output


def generate_catalog(collection_id: str, output: Path):
    LOG.info(f"generating catalog for {collection_id=} {output=}")
    run(["catgen", collection_id, str(output)], check=True)


def cleanup(output: Path):
    """Remove anything not in the required outputs."""
    outputs = [
        output.name,
        output.name.replace(".nc", ".json"),
        "catalog.json",
    ]
    for child in Path.cwd().iterdir():
        if child.is_dir():
            LOG.info(f"removing directory {child} and contents")
            shutil.rmtree(child)
            continue
        if child.name not in outputs:
            LOG.info(f"removing {child}")
            child.unlink()
    return


if __name__ == "__main__":
    import argparse

    parser = argparse.ArgumentParser()
    parser.add_argument("--verbose", action="store_true")
    parser.add_argument("--input", type=Path)
    parser.add_argument("--collection_id")
    args = parser.parse_args()

    logging.basicConfig(level=logging.INFO, format="%(name)s -- %(message)s")
    LOG.setLevel(logging.DEBUG if args.verbose else logging.INFO)

    if not args.input.is_dir() or not args.input.exists():
        parser.error(f"Invalid input directory: {args.input}")

    for path in args.input.glob("*.json"):
        LOG.debug("%s:\n%s", path, json.dumps(json.load(open(path)), indent=2))

    inputs = Inputs.from_dir(args.input)
    for k, v in asdict(inputs).items():
        LOG.info("input %s -> %s", k, v.absolute())

    output = pipeline(inputs)

    generate_catalog(args.collection_id, output)
    cleanup(output)