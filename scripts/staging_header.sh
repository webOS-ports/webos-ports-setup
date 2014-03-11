CURRENT_STAGING_FILE=scripts/.staging_dir

if [[ ! -e ${CURRENT_STAGING_FILE} ]] ; then
  echo "Current staging dir is not defined, no ${CURRENT_STAGING_FILE}"
  exit 1
fi

CURRENT_DIR=`pwd`
CURRENT_PROJECT=webos-ports
CURRENT_STAGING=`cat ${CURRENT_STAGING_FILE}`
SOURCE_DIR=${CURRENT_PROJECT}/tmp-eglibc/deploy
STAGING_DIR=htdocs/builds/${CURRENT_PROJECT}-staging
PUBLIC_DIR=htdocs/builds/${CURRENT_PROJECT}
