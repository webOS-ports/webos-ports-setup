#!/bin/bash

. scripts/staging_header.sh

NEW=`expr ${CURRENT_STAGING} + 1 | awk '{ printf("%03d", $0) }'`
DATE=`date`
REMOTE=$1

if [ -z "$REMOTE" ]; then
  echo "ERROR: you need to provide remote URL"
  exit 2
fi

echo "Closing ${STAGING_DIR}/${CURRENT_STAGING} and creating new ${STAGING_DIR}/${NEW}"
echo "Closing testing feed number: ${CURRENT_STAGING}"    | tee -a ${SOURCE_DIR}/info.${CURRENT_STAGING}
echo "'''Status:''' Closed (${DATE}), ready for test"     | tee -a ${SOURCE_DIR}/info.${CURRENT_STAGING}
echo "${DATE}"                                            | tee -a ${SOURCE_DIR}/info.${CURRENT_STAGING}

# one more sync to be sure everything was uploaded and update info file
scripts/staging_sync.sh ${SOURCE_DIR} ${REMOTE}:${STAGING_DIR}/wip

ssh ${REMOTE} mv ${STAGING_DIR}/wip ${STAGING_DIR}/${CURRENT_STAGING}
ssh ${REMOTE} mkdir ${STAGING_DIR}/wip
ssh ${REMOTE} ln -snf ${CURRENT_STAGING} ${STAGING_DIR}/latest

export TAG=webOS-ports/thud/${CURRENT_STAGING};
[ -e scripts/oebb.sh ] && ( OE_SOURCE_DIR=${CURRENT_DIR}/${CURRENT_PROJECT} scripts/oebb.sh tag ${TAG} )
# only for dirs with possible r-w access
for i in meta-webos-ports; do
  cd ${CURRENT_PROJECT}/$i;
  git push origin ${TAG};
  cd -;
done;
cd ${CURRENT_PROJECT}/buildhistory;
git tag -a -m "${TAG}" ${TAG};
git push origin ${TAG};
cd -;
# cannot do this, because prservice is running on different host
# cp ../PRservice/prserv.sqlite3 ~/web/shr-core-staging/${TAG}/prserv.sqlite3.${TAG}

# move current source aside
mv ${SOURCE_DIR} ${SOURCE_DIR}.${CURRENT_STAGING}
mkdir -p ${SOURCE_DIR}
ln -sf info.${NEW} ${SOURCE_DIR}/info
echo ${NEW} > ${SOURCE_DIR}/info.id
echo "Opening testing feed number: ${NEW}"                | tee -a ${SOURCE_DIR}/info.${NEW}
echo "'''Status:''' Building, '''NOT''' ready for test"   | tee -a ${SOURCE_DIR}/info.${NEW}
echo "${DATE}"                                            | tee -a ${SOURCE_DIR}/info.${NEW}

echo ${NEW} > ${CURRENT_STAGING_FILE}
echo "Please update manually with staging_update.sh"
