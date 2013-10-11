#!/bin/bash

. scripts/staging_header.sh

echo "Updating sources" | tee -a ${SOURCE_DIR}/info
date        | tee -a ${SOURCE_DIR}/info
make update | tee -a ${SOURCE_DIR}/info
