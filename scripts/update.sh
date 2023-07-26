#!/bin/bash

SCRIPTDIR=/OE/layers/scripts

BASE="origin/kirkstone"
BRANCHES="\
  kirkstone \
  jansa/kirkstone \
  jansa/langdale \
  jansa/mickledore \
  jansa/nanbield \
  jansa/scarthgap \
  jansa/nodistro-scarthgap \
"
${SCRIPTDIR}/rebase-multiple.sh ${BASE} "${BRANCHES}" skip_ru
