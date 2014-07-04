#!/bin/bash -e

pushd `dirname $0` > /dev/null
SCRIPTDIR=`pwd -P`
popd > /dev/null

BRANCH=$1
BASE=l/${BRANCH}

BUILD_BRANCH=$2
BUILD_BASE=l/${BUILD_BRANCH}

BASE_LAYERS=$3
BUILD=$4

echo "================================================================="
echo "Updating '${BUILD}' build environment"
echo "================================================================="
git ru
${SCRIPTDIR}/rebase-with-log.sh ${BUILD_BRANCH} ${BUILD_BASE} ${BUILD}/build
#echo "Finished updating '${BUILD}' build environment"

for LAYER in ${BASE_LAYERS}; do
  if [ -d ${LAYER} ] ; then
    cd ${LAYER}
    #echo "================================================================="
    #echo "Updating '${BUILD}/${LAYER}'"
    #echo "================================================================="
    git ru
    ${SCRIPTDIR}/rebase-with-log.sh ${BRANCH} ${BASE} ${BUILD}/${LAYER}
    #echo "Finished updating '${BUILD}/${LAYER}'"
    cd ..
  else
    git clone --shared -b ${BRANCH} /OE/layers/${LAYER} ${LAYER}
    cd ${LAYER} && git remote rename origin l && cd ..
  fi
done
