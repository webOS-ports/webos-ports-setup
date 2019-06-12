#!/bin/bash

if [[ $# -ne 2 ]] ; then
  echo "Usage: $0 source_dir target_dir"
  echo "          source_dir: /workspace/webos-ports/tmp-glibc/deploy"
  echo "          target_dir: user@server:web/webos-ports"
  exit 1
fi

SOURCE_DIR=$1
TARGET_DIR=$2

if [ ! -d ${SOURCE_DIR}/images ] ; then
  echo "ERROR: ${SOURCE_DIR}/images doesn't exist"
  exit 2
fi

echo "Syncing deploy dir from ${SOURCE_DIR} to ${TARGET_DIR}"

# count missing md5sums
cd ${SOURCE_DIR}/images
for IMG_FILE in */*.ext2 */*.ext4 */*.zip */*.bin */*.ubi */*.ubifs */*.img */*.jffs2 */*.sum.jffs2 */*.jffs2.nosummary */*.tgz */*.tar.gz */*.tar.bz2 */*.udfu */*.fastboot */*.cpio.gz */*.rpi-sdimg */*.wic.gz */*.wic.bmap; do
  if [ -e ${IMG_FILE} -a ! -h ${IMG_FILE} -a \( ! -e ${IMG_FILE}.md5 -o ${IMG_FILE}.md5 -ot ${IMG_FILE} \) ] ; then
    echo MD5: ${IMG_FILE}
    md5sum ${IMG_FILE} | sed 's#  .*/#  #g' > ${IMG_FILE}.md5
  fi
done

# sync images ipk licenses tools
cd ../ #${SOURCE_DIR}
rsync -avir . ${TARGET_DIR}

# sync ipk feed and remove missing
#rsync -avi --delete ipk/ ${TARGET_DIR}/ipk/
