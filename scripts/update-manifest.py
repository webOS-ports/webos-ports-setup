#!/usr/bin/env python

import os
import sys
import argparse
import json

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description="manifest updater")
    parser.add_argument("--verbose", "-v", action="count", default=0)
    parser.add_argument("manifest", metavar="MANIFEST")
    parser.add_argument("-r", "--release-name")
    parser.add_argument("-n", "--next-version", type=int, default=1)

    args = parser.parse_args()

    release_name = ""
    if args.release_name:
        release_name = args.release_name

    manifest = {}

    if os.path.exists(args.manifest):
        with open(args.manifest) as file:
            manifest_raw = file.read()
            if manifest_raw:
                manifest = json.loads(manifest_raw)

    manifest["manifestVersion"] = 2

    if manifest.has_key("changeLog"):
        changeLog = manifest["changeLog"]
    else:
        changeLog = []

    next_version = args.next_version
    for change in changeLog:
        if change["version"] > next_version:
            next_version = change["version"]
        elif change["version"] == next_version:
            next_version += 1

    new_change = {}
    new_change["version"] = next_version
    new_change["release_name"] = release_name
    new_change["changes"] = []

    changeLog.append(new_change)
    manifest["changeLog"] = changeLog
    manifest["platformVersion"] = next_version

    with open(args.manifest, "w") as file:
        file.write(json.dumps(manifest, sort_keys=True, indent=4, separators=(',', ': ')))


