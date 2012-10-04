# Makefile for the webos-ports development system
# Licensed under the GPL v2 or later

MAKEFLAGS = -swr

BRANCH_COMMON = master

URL_COMMON = "git://github.com/webOS-ports/webos-ports-setup.git"

UPDATE_CONFFILES_ENABLED = "0"
RESET_ENABLED = "0"

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
	if [ -d webos-ports ] ; then \
		if ! diff -q webos-ports/conf/bblayers.conf common/conf/bblayers.conf ; then \
			echo -e "\\033[1;31m" "WARNING: you have different bblayers.conf, please sync it from common directory or call update-conffiles to replace all config files with new versions" ; \
			echo -e "\\e[0m" ; \
		fi ; \
		if ! diff -q webos-ports/conf/layers.txt common/conf/layers.txt; then \
			echo -e "\\033[1;31m" "WARNING: you have different layers.txt, please sync it from common directory or call update-conffiles to replace all config files with new versions" ; \
			echo -e "\\e[0m" ; \
		fi ; \
		if ! diff -q webos-ports/conf/site.conf common/conf/site.conf; then \
			echo -e "\\033[1;31m" "WARNING: you have different site.conf, please sync it from common directory or call update-conffiles to replace all config files with new versions" ; \
			echo -e "\\e[0m" ; \
		fi ; \
		[ -e scripts/oebb.sh ] && ( OE_SOURCE_DIR=`pwd`/webos-ports scripts/oebb.sh update ) ; \
		if [ "${RESET_ENABLED}" = "1" ] ; then \
			[ -e scripts/oebb.sh ] && ( OE_SOURCE_DIR=`pwd`/webos-ports scripts/oebb.sh reset ) ; \
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
	@echo "preparing webos-ports tree"
	[ -d webos-ports ] || ( mkdir -p webos-ports )
	[ -e downloads ] || ( mkdir -p downloads )
	[ -d scripts ] || ( cp -ra common/scripts scripts )
	[ -e webos-ports/setup-env ] || ( cd webos-ports ; ln -sf ../common/setup-env . )
	[ -e webos-ports/setup-local ] || ( cd webos-ports ; cp ../common/setup-local . )
	[ -e webos-ports/downloads ] || ( cd webos-ports ; ln -sf ../downloads . )
	[ -d webos-ports/conf ] || ( cp -ra common/conf webos-ports/conf )
	[ -e webos-ports/conf/topdir.conf ] || echo "TOPDIR='`pwd`/webos-ports'" > webos-ports/conf/topdir.conf
	[ -e scripts/oebb.sh ] && ( OE_SOURCE_DIR=`pwd`/webos-ports scripts/oebb.sh update )
	touch webos-ports/.configured

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
update-conffiles: webos-ports/.configured
	@echo "syncing webos-ports config files up to date"
	cp common/conf/auto.conf webos-ports/conf/auto.conf
	cp common/conf/bblayers.conf webos-ports/conf/bblayers.conf
	cp common/conf/layers.txt webos-ports/conf/layers.txt
	cp common/conf/site.conf webos-ports/conf/site.conf
	cp common/scripts/* scripts/

# End of Makefile
