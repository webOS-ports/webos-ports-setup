#!/bin/bash

. scripts/staging_header.sh

mkdir -p ${SOURCE_DIR}
echo "Updating sources" | tee -a ${SOURCE_DIR}/info.${CURRENT_STAGING}
date        | tee -a ${SOURCE_DIR}/info.${CURRENT_STAGING}
make update | tee -a ${SOURCE_DIR}/info.${CURRENT_STAGING}
