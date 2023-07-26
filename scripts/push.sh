#!/bin/sh

export DATE=`date "+%Y-%m-%d"`
for B in kirkstone langdale mickledore nanbield nodistro-nanbield scarthgap nodistro-scarthgap; do
#     git tag -a -f -m "${B}-${DATE}" "${B}-${DATE}" ${B}
#     git push -f shr ${B}-${DATE} ${B} jansa/${B}
     git push -f origin jansa/${B}
done
