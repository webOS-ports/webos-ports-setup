#!/bin/bash

[ $# -ge 1 ] && LAYERS_DIR=$1 || LAYERS_DIR=~

pushd `dirname $0` > /dev/null
SCRIPT_DIR=`pwd -P`
popd > /dev/null

MSG=${SCRIPT_DIR}/commit-message.txt
RU="git remote update origin"
[ $# -lt 2 -o "$2" != "ru" ] && RU=""

echo -e "conf/layers.txt: Use latest revisions" > ${MSG}

cat conf/layers.txt  | grep -v HEAD | while IFS="," read DIR URL BRANCH REV; do
NREV=`cd ${LAYERS_DIR}/$DIR; $RU 1>&2; git log origin/$BRANCH | head -n1 | awk '{ print $2 }'`
echo "DIR=$DIR URL=$URL BRANCH=$BRANCH REV=$REV NREV=$NREV" >&2
if [ $REV != ${NREV} ] ; then
    echo -e "\n$DIR: ${REV}..${NREV}" >> ${MSG}
    cd ${LAYERS_DIR}/$DIR
    git log --oneline ${REV}..${NREV} >> ${MSG}
    cd -
    sed -i "s/$REV/$NREV/g" conf/layers.txt
fi
done

git commit -s conf/layers.txt -t ${MSG}
