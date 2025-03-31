#!/bin/bash

SCRIPTDIR=/OE/layers/scripts

RELEASE="walnascar"
BUILD="nodistro"

BUILD_BRANCH="jansa/nodistro-${RELEASE}"
BRANCH="jansa/${RELEASE}"
BASE_LAYERS=" \
  meta-openembedded \
  meta-qt5 \
  meta-qt6 \
  meta-clang \
  meta-raspberrypi \
  openembedded-core \
  meta-browser \
  meta-clang \
  meta-virtualization \
  meta-security \
  meta-smartphone \
  meta-webos-ports \
  meta-tensorflow \
  meta-selinux \
  bitbake \
"

${SCRIPTDIR}/update-layers.sh ${BRANCH} ${BUILD_BRANCH} "${BASE_LAYERS}" build-${BUILD}-${RELEASE}
