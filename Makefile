# Makefile for the webos-ports development system
# Licensed under the GPL v2 or later

MAKEFLAGS = -swr

BRANCH_COMMON = morphis/work

URL_COMMON = "git://github.com/webOS-ports/webos-ports-setup.git"

UPDATE_CONFFILES_ENABLED = "0"
RESET_ENABLED = "0"

SETUP_DIR = "webos-ports"

ifneq ($(wildcard config.mk),)
include config.mk
endif

.PHONY: show-config
show-config:
	@echo "BRANCH_COMMON          ${BRANCH_COMMON}"
	@echo "URL_COMMON             ${URL_COMMON}"
	@echo ""

.PHONY: update
update: 
	if [ "${CHANGELOG_ENABLED}" = "1" ] ; then \
		${MAKE} changelog ; \
	fi
	[ ! -e common ]       || ${MAKE} update-common 
	if [ "${UPDATE_CONFFILES_ENABLED}" = "1" ] ; then \
		${MAKE} update-conffiles ; \
	fi
	if [ -d ${SETUP_DIR} ] ; then \
		if ! diff -q ${SETUP_DIR}/conf/bblayers.conf common/conf/bblayers.conf ; then \
			echo -e "\\033[1;31mWARNING: You have different bblayers.conf.\\n         Please sync it from common directory or call update-conffiles to replace all config files with new versions.\\e[0m"; \
		fi ; \
		if ! diff -q ${SETUP_DIR}/conf/layers.txt common/conf/layers.txt; then \
			echo -e "\\033[1;31mWARNING: You have different layers.txt.\\n         Please sync it from common directory or call update-conffiles to replace all config files with new versions.\\e[0m"; \
		fi ; \
		if ! diff -q ${SETUP_DIR}/conf/site.conf common/conf/site.conf; then \
			echo -e "\\033[1;31mWARNING: You have different site.conf\\n         Please sync it from common directory or call update-conffiles to replace all config files with new versions.\\e[0m"; \
		fi ; \
		[ -e scripts/oebb.sh ] && ( OE_SOURCE_DIR=`pwd`/${SETUP_DIR} scripts/oebb.sh update ) ; \
		if [ "${RESET_ENABLED}" = "1" ] ; then \
			[ -e scripts/oebb.sh ] && ( OE_SOURCE_DIR=`pwd`/${SETUP_DIR} scripts/oebb.sh reset ) ; \
		fi; \
	fi

.PHONY: setup-common
.PRECIOUS: common/.git/config
setup-common common/.git/config:
	[ -e common/.git/config ] || \
	( echo "setting up common (Makefile)"; \
	  git clone ${URL_COMMON} common && \
	  rm -f Makefile && \
	  ln -s common/Makefile Makefile )
	( cd common && \
	  git checkout ${BRANCH_COMMON} 2>/dev/null || \
	  git checkout --no-track -b ${BRANCH_COMMON} origin/${BRANCH_COMMON} )
	touch common/.git/config

.PHONY: setup-%
setup-%:
	${MAKE} $*/.configured

.PRECIOUS: webos-ports/.configured
webos-ports/.configured: common/.git/config
	@echo "preparing ${SETUP_DIR} tree"
	[ -d ${SETUP_DIR} ] || ( mkdir -p ${SETUP_DIR} )
	[ -e downloads ] || ( mkdir -p downloads )
	[ -d scripts ] || ( cp -ra common/scripts scripts )
	[ -e ${SETUP_DIR}/setup-env ] || ( cd ${SETUP_DIR} ; ln -sf ../common/setup-env . )
	[ -e ${SETUP_DIR}/setup-local ] || ( cd ${SETUP_DIR} ; cp ../common/setup-local . )
	[ -e ${SETUP_DIR}/downloads ] || ( cd ${SETUP_DIR} ; ln -sf ../downloads . )
	[ -d ${SETUP_DIR}/conf ] || ( cp -ra common/conf ${SETUP_DIR}/conf )
	[ -e ${SETUP_DIR}/conf/topdir.conf ] || echo "TOPDIR='`pwd`/${SETUP_DIR}'" > ${SETUP_DIR}/conf/topdir.conf
	[ -e scripts/oebb.sh ] && ( OE_SOURCE_DIR=`pwd`/${SETUP_DIR} scripts/oebb.sh update )
	touch ${SETUP_DIR}/.configured

.PHONY: update-common
update-common: common/.git/config
	@echo "updating common (Makefile)"
	( cd common ; \
	  git clean -d -f ; git reset --hard ; git fetch ; \
	  git checkout ${BRANCH_COMMON} 2>/dev/null || \
	  git checkout --no-track -b ${BRANCH_COMMON} origin/${BRANCH_COMMON} ; \
	  git reset --hard origin/${BRANCH_COMMON}; \
	)
	( echo "replacing Makefile with link to common/Makefile"; \
	  rm -f Makefile && \
	  ln -s common/Makefile Makefile )

.PHONY: update-conffiles
update-conffiles:
	[ -d ${SETUP_DIR}/conf ] && ( \
	  echo "syncing ${SETUP_DIR} config files up to date"; \
	  cp common/conf/auto.conf ${SETUP_DIR}/conf/auto.conf; \
	  cp common/conf/bblayers.conf ${SETUP_DIR}/conf/bblayers.conf; \
	  cp common/conf/layers.txt ${SETUP_DIR}/conf/layers.txt; \
	  cp common/conf/site.conf ${SETUP_DIR}/conf/site.conf; \
	  cp common/scripts/* scripts/; \
	)

# End of Makefile
