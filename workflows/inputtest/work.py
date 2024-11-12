#!/usr/bin/env python3
import argparse
import json
import logging
from pathlib import Path

from pystac import Catalog, ItemCollection

log = logging

parser = argparse.ArgumentParser()
parser.add_argument("file1", type=Path)
parser.add_argument("catalog", type=Path)
args = parser.parse_args()


def find_catalog_inputs(fpath: Path, inputs: dict[str, str]) -> dict[str, Path]:
    """Find inputs in a catalog returning mapping of input name to local path"""
    # file name to input name
    input_names = {v: k for k, v in inputs.items()}
    outputs = {}
    # Load JSON just to figure out what kind of catalog we're dealing with
    data = json.load(fpath.open())
    if data.get("type", "") == "FeatureCollection":
        avail_items = list(ItemCollection.from_dict(data).items)
    else:
        # Loading from dict requires href for relative catalogs
        avail_items = list(
            Catalog.from_dict(data, href=str(fpath)).get_items(recursive=True)
        )
    for item in avail_items:
        for asset in item.assets.values():  # don't care about asset name
            if asset.href.startswith("/"):
                # Support absolute catalog paths
                path = Path(asset.href)
            else:
                # Assume asset href relative to catalog
                path = fpath.parent / Path(asset.href)
            if path.name in inputs:
                outputs[input_names[path.name]] = path
    return outputs


inputs = {"file1": args.file1}
for name, path in find_catalog_inputs(args.catalog, inputs).items():
    print(f"{input=} {path=}")
    assert path.exists(), f"catalog {input=} {path=} does not exist"
