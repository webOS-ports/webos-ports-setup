CURRENT_STAGING_FILE=scripts/.staging_dir

if [[ ! -e ${CURRENT_STAGING_FILE} ]] ; then
  echo "Current staging dir is not defined, no ${CURRENT_STAGING_FILE}"
  exit 1
fi

CURRENT_STAGING=`cat ${CURRENT_STAGING_FILE}`
SOURCE_DIR=webos-ports/tmp-eglibc/deploy
STAGING_DIR=htdocs/builds/webos-ports-staging
PUBLIC_DIR=htdocs/builds/webos-ports
