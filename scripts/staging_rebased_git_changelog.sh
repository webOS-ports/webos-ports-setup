#!/bin/bash
# some branches in oe-core and meta-oe are rebased often
# so to provide something like changelog we're saving
# last "base" revision in .git/last_rev_in_up
# and then listing commits prev_base..new_base
# and then listing commits after new_base with rebase prefix

if [[ $# -lt 2 ]] ; then
  echo "Usage: $0 git_repo branch base_repo_url [CHANGELOG_FORMAT] [CHANGELOG_FORMAT_REBASE]"
  exit 1
fi

GIT_REPO=$1
BRANCH=$2
BASE_REPO_URL=$3
CHANGELOG_FORMAT="%h %ci %aN%n        %s%n"
CHANGELOG_FORMAT_REBASE="rebase: %h %ci %aN%n                %s%n"

if [[ $# -gt 4 ]] ; then
  CHANGELOG_FORMAT=$4
  if [[ $# -eq 5 ]] ; then
    CHANGELOG_FORMAT_REBASE=$5
  else
    echo "Usage: $0 git_repo branch base_repo_url [CHANGELOG_FORMAT] [CHANGELOG_FORMAT_REBASE]"
    exit 2
  fi
fi

if [[ ! -d ${GIT_REPO} ]] ; then
  echo "Git repository ${GIT_REPO} doesn't exist"
  echo 3
fi

cd ${GIT_REPO}

# only when it succeeds we need to call git remote update *again*, otherwise we assume it was called before this script
git remote add up ${BASE_REPO_URL} 2>/dev/null && git remote update

PREV_REV_IN_UP=`cat .git/last_rev_in_up 2>/dev/null || echo up/master`
NUMBER_OF_PATCHES_NOT_UP=`git rev-list up/master.. | wc -l`
LAST_REV_IN_UP=`git show --oneline --format="%H" HEAD~${NUMBER_OF_PATCHES_NOT_UP} | head -n 1`
echo ${LAST_REV_IN_UP} > .git/last_rev_in_up
echo "git log ${PREV_REV_IN_UP}..${LAST_REV_IN_UP} --pretty=format:\"${CHANGELOG_FORMAT}\""
PAGER= git log ${PREV_REV_IN_UP}..${LAST_REV_IN_UP} --pretty=format:"${CHANGELOG_FORMAT}"
echo "git log ${LAST_REV_IN_UP}..${BRANCH} --pretty=format:\"${CHANGELOG_FORMAT_REBASE}\""
PAGER= git log ${LAST_REV_IN_UP}..${BRANCH} --pretty=format:"${CHANGELOG_FORMAT_REBASE}"

