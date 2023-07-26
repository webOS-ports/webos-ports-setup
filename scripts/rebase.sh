#!/bin/bash

SCRIPTDIR=/OE/layers/scripts

RELEASE="master"
BUILD="nodistro"

BUILD_BRANCH="jansa/nodistro-scarthgap"
BRANCH="jansa/${RELEASE}"
BASE_LAYERS=" \
  meta-openembedded \
  meta-qt5 \
  meta-qt6 \
  meta-clang \
  meta-raspberrypi \
  openembedded-core \
  meta-browser \
  meta-python2 \
  meta-clang \
  meta-virtualization \
  meta-security \
  meta-smartphone \
  bitbake \
"

${SCRIPTDIR}/update-layers.sh ${BRANCH} ${BUILD_BRANCH} "${BASE_LAYERS}" build-${BUILD}-${RELEASE}
