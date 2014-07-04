#!/bin/bash

SCRIPTDIR=/OE/layers/scripts

BASE="origin/scarthgap"
BRANCHES="\
  scarthgap \
  jansa/scarthgap \
  jansa/styhead \
  jansa/nodistro-styhead \
"
${SCRIPTDIR}/rebase-multiple.sh ${BASE} "${BRANCHES}" skip_ru
