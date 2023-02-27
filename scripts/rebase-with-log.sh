#!/bin/bash

pushd `dirname $0` > /dev/null
SCRIPTDIR=`pwd -P`
popd > /dev/null

BRANCH=$1
BASE=$2

#echo "================================================================="
echo "Updating `pwd` branch '${BRANCH}' on top of '${BASE}'"
git checkout ${BRANCH} >/dev/null 2>/dev/null || git checkout -b ${BRANCH} ${BASE}
CHANGES1=`git log --oneline ..${BASE} | wc -l`
if [ ${CHANGES1} -gt 0 ] ; then
  echo "==== ${BRANCH} => ${BASE} ===="
  cmd="git log --reverse --oneline ..${BASE}"
  echo "${cmd}"; ${cmd} | tee
  echo "===="
fi
CHANGES=`git log --oneline ${BASE}.. | wc -l`
if [ ${CHANGES} -gt 0 ] ; then
  echo "==== ${BASE} => ${BRANCH} ===="
  cmd="git log --reverse --oneline ${BASE}.."
  echo "${cmd}"; ${cmd} | tee
  echo "===="
fi
if git status | grep -q Untracked || [ ${CHANGES1} -gt 0 -o ${CHANGES} -gt 0 ] ; then
  git status
  echo "TYPE 'n' to update in shell";
  read A
  if [ "$A" = "n" ]; then
    export debian_chroot="update-${BRANCH}"
    bash
  fi
fi

if [ ${CHANGES} -gt 0 ] ; then
  cmd="git rebase -i ${BASE}"
  ${cmd}
  #echo "Rebase of branch '$BRANCH' done"
  echo "${cmd}"
  echo "TYPE 'n' to resolve in shell";
  read A
  if [ "$A" = "n" ]; then
    export debian_chroot="rebase-${BRANCH}"
    bash
  fi
else
  # There is nothing to fail
  git rebase ${BASE} | grep -v "Current branch ${BRANCH} is up to date."
  if [ ${PIPESTATUS[0]} -gt 0 ] ; then
    export debian_chroot="rebase-${BRANCH}"
    bash
  fi
  #echo "Rebase of branch '${BRANCH}' done"
fi
