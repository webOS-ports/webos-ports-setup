#!/bin/bash

SCRIPTDIR=/OE/lge/layers/scripts

BASE="origin/master"
BRANCHES="\
  ose-master \
  kirkstone \
  langdale \
  mickledore \
  nanbield \
"
${SCRIPTDIR}/rebase-multiple.sh ${BASE} "${BRANCHES}" $1

BASE="kirkstone"
BRANCHES="\
  kirkstone \
  jansa/kirkstone \
  jansa/langdale \
  jansa/mickledore \
  jansa/nanbield \
"
${SCRIPTDIR}/rebase-multiple.sh ${BASE} "${BRANCHES}" skip_ru

BASE="jansa/kirkstone"
BRANCHES="\
  jansa/kirkstone \
  jansa/nodistro-kirkstone \
  jansa/nodistro-langdale \
  jansa/nodistro-mickledore \
  jansa/nodistro-nanbield \
"
${SCRIPTDIR}/rebase-multiple.sh ${BASE} "${BRANCHES}" skip_ru
