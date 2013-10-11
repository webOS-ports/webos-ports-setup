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
echo "Closing testing feed number: ${CURRENT_STAGING}"    | tee -a ${SOURCE_DIR}/info
echo "'''Status:''' Closed (${DATE}), ready for test"     | tee -a ${SOURCE_DIR}/info
echo "${DATE}"                                            | tee -a ${SOURCE_DIR}/info

# one more sync to be sure everything was uploaded and update info file
scripts/staging_sync.sh ${SOURCE_DIR} ${REMOTE}:${STAGING_DIR}/wip

ssh ${REMOTE} mv ${STAGING_DIR}/wip ${STAGING_DIR}/${CURRENT_STAGING}
ssh ${REMOTE} mkdir ${STAGING_DIR}/wip
ssh ${REMOTE} ln -snf ${CURRENT_STAGING} ${STAGING_DIR}/latest

# move current source aside
#mv ${SOURCE_DIR} ${SOURCE_DIR}.${CURRENT_STAGING}
#mkdir -p ${SOURCE_DIR}
ln -sf info.${NEW} ${SOURCE_DIR}/info
echo ${NEW} > ${SOURCE_DIR}/info.id
echo "Opening testing feed number: ${NEW}"                | tee -a ${SOURCE_DIR}/info
echo "'''Status:''' Building, '''NOT''' ready for test"   | tee -a ${SOURCE_DIR}/info
echo "${DATE}"                                            | tee -a ${SOURCE_DIR}/info

echo ${NEW} > ${CURRENT_STAGING_FILE}
echo "Please update manually with staging_update.sh"
