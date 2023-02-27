#!/bin/bash

pushd `dirname $0` > /dev/null
SCRIPTDIR=`pwd -P`
popd > /dev/null

BASE=$1
BRANCHES=$2
SKIP_RU=$3

FIRST_BRANCH=`echo ${BRANCHES} | cut -d\  -f 1`

if [ -z "${SKIP_RU}" ]; then
  git ru
fi
git checkout ${FIRST_BRANCH} || git checkout -b ${FIRST_BRANCH} ${BASE}
git rebase ${BASE};

for BRANCH in ${BRANCHES}; do
  ${SCRIPTDIR}/rebase-with-log.sh ${BRANCH} ${BASE}
  BASE=${BRANCH};
done
