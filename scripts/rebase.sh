#!/bin/bash

SCRIPTDIR=/OE/layers/scripts

RELEASE="nanbield"
BUILD="luneos"

BUILD_BRANCH="jansa/${RELEASE}"
BRANCH="jansa/${RELEASE}"
BASE_LAYERS=" \
  meta-webos-ports \
  meta-smartphone \
  meta-openembedded \
  meta-pine64-luneos \
  meta-qt6 \
  meta-clang \
  meta-raspberrypi \
  meta-rockchip \
  meta-rpi-luneos \
  meta-arm \
  openembedded-core \
  bitbake \
"

${SCRIPTDIR}/update-layers.sh ${BRANCH} ${BUILD_BRANCH} "${BASE_LAYERS}" build-${BUILD}-${RELEASE}
