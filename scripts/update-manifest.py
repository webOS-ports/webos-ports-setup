#!/usr/bin/env python

import os
import sys
import argparse
import json

def update_change_manifest(path, release_name="", next_version=1):
    manifest = {}

    if os.path.exists(path):
        with open(path) as file:
            manifest_raw = file.read()
            if manifest_raw:
                manifest = json.loads(manifest_raw)

    manifest["manifestVersion"] = 2

    if manifest.has_key("changeLog"):
        changeLog = manifest["changeLog"]
    else:
        changeLog = []

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

    with open(path, "w") as file:
        file.write(json.dumps(manifest, sort_keys=True, indent=4, separators=(',', ': ')))

def update_device_manifest(path, machine, version, image, image_md5):
    manifest = {}

    if os.path.exists(path):
        with open(path) as file:
            manifest_raw = file.read()
            if manifest_raw:
                manifest = json.loads(manifest_raw)

    manifest["version"] = 1

    if not manifest.has_key(machine):
        manifest[machine] = {}

    if not manifest[machine].has_key(version):
        manifest[machine][version] = {}

    manifest[machine][version]["url"] = image
    manifest[machine][version]["md5"] = image_md5

    with open(path, "w") as file:
        file.write(json.dumps(manifest, sort_keys=True, indent=4, separators=(',', ': ')))

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description="manifest updater")
    parser.add_argument("manifest", metavar="MANIFEST")
    parser.add_argument("-r", "--release-name", default="")
    parser.add_argument("-n", "--next-version", type=int, default=1)
    parser.add_argument("-c", "--change-manifest", action="store_true", help="Update the change manifest (default)", default=True)
    parser.add_argument("-d", "--device-manifest", action="store_true", help="Update the device manifest")
    parser.add_argument("-v", "--version", help="Version to add a new image for", default="")
    parser.add_argument("-m", "--machine", help="Machine to add a new image for", default="")
    parser.add_argument("--image", help="Image to add for specified machine and version", default="")
    parser.add_argument("--image-md5", help="Image md5 checksum", default="")

    args = parser.parse_args()

    if args.change_manifest and not args.device_manifest:
        update_change_manifest(args.manifest, args.release_name, args.next_version)
    elif args.device_manifest:
        update_device_manifest(args.manifest, args.machine, args.version, args.image, args.image_md5)
    else:
        print "ERROR: Invalid argument combination!"
