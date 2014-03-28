#!/bin/bash

. scripts/staging_header.sh

if [[ $# -ne 2 ]] ; then
  echo "Usage: $0 remote staging_number"
  echo "       It will rsync stuff from ${STAGING_DIR}/staging_number to ${PUBLIC_DIR} on remote server"
  exit 1
fi

REMOTE=$1
STAGING_NUMBER=$2

if [[ 1${STAGING_NUMBER} -ge 1${CURRENT_STAGING} ]] ; then
  echo "Cannot sync newer or equal staging_number as current (${CURRENT_STAGING} in ${CURRENT_STAGING_FILE})"
fi

if [ -z "${REMOTE}" ]; then
  echo "ERROR: You need to provide remote"
  exit 2
fi

SOURCE_DIR=${STAGING_DIR}/${STAGING_NUMBER}
TARGET_DIR=${PUBLIC_DIR}

DATE=`date`
DATE_CLOSED=`ssh ${REMOTE} tail -n1 ${SOURCE_DIR}/info.${STAGING_NUMBER}`

ssh ${REMOTE} "echo -e \"Merged to public feed\n'''Status:''' Closed (${DATE_CLOSED}) and merged to public feed (${DATE})\n${DATE}\" | tee -a ${SOURCE_DIR}/info.${STAGING_NUMBER}"

ssh ${REMOTE} rsync -avir ${SOURCE_DIR}/* ${TARGET_DIR}

# sync ipk feed and remove missing, in this case we can, because all supported MACHINEs were built before staging was closed
ssh ${REMOTE} rsync -avi --delete ${SOURCE_DIR}/ipk/ ${TARGET_DIR}/ipk/
