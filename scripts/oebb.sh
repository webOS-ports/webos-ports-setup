#!/bin/bash

# Original script done by Don Darling
# Later changes by Koen Kooi and Brijesh Singh

# Revision history:
# 20090902: download from twiki
# 20090903: Weakly assign MACHINE and DISTRO
# 20090904:  * Don't recreate local.conf is it already exists
#            * Pass 'unknown' machines to OE directly
# 20090918: Fix /bin/env location
#           Don't pass MACHINE via env if it's not set
#           Changed 'build' to 'bitbake' to prepare people for non-scripted usage
#           Print bitbake command it executes
# 20091012: Add argument to accept commit id.
# 20091202: Fix proxy setup
# 20120813: minimal version just to checkout/update/changelog layers from layers.txt, used by webos scripts instead of git submodules
#
# For further changes consult 'git log' or browse to:
#   http://git.angstrom-distribution.org/cgi-bin/cgit.cgi/setup-scripts/
# to see the latest revision history

# Use this till we get a maintenance branch based of the release tag

###############################################################################
# OE_BASE    - The root directory for all OE sources and development.
###############################################################################
OE_BASE=${PWD}

###############################################################################
# SET_ENVIRONMENT() - Setup environment variables for OE development
###############################################################################
function set_environment()
{
    export OE_BASE
    export OE_LAYERS_TXT=${OE_SOURCE_DIR}/conf/layers.txt
}

###############################################################################
# UPDATE_ALL() - Make sure everything is up to date
###############################################################################
function update_all()
{
    set_environment
    update_oe
}

###############################################################################
# CLEAN_OE() - Delete TMPDIR
###############################################################################
function clean_oe()
{
    set_environment
    echo "Cleaning ${OE_BUILD_TMPDIR}"
    rm -rf ${OE_BUILD_TMPDIR}
}


###############################################################################
# UPDATE_OE() - Update OpenEmbedded distribution.
###############################################################################
function update_oe()
{
    #manage layers with layerman
    env gawk -v command=update -f ${OE_BASE}/scripts/layers.awk ${OE_LAYERS_TXT} 
}

###############################################################################
# tag_layers - Tag all layers with a given tag
###############################################################################
function tag_layers()
{
    set_environment
    env gawk -v command=tag -v commandarg=$TAG -f ${OE_BASE}/scripts/layers.awk ${OE_LAYERS_TXT}
    echo $TAG >> ${OE_BASE}/tags
}

###############################################################################
# changelog - Display changelog for all layers with a given tag
###############################################################################
function changelog()
{
	set_environment
	env gawk -v command=changelog -v commandarg=$TAG -f ${OE_BASE}/scripts/layers.awk ${OE_LAYERS_TXT} 
}

###############################################################################
# layer_info - Get layer info
###############################################################################
function layer_info()
{
	set_environment
	rm -f ${OE_SOURCE_DIR}/info.txt
	env gawk -v command=info -f ${OE_BASE}/scripts/layers.awk ${OE_LAYERS_TXT}
	echo
	echo "Showing contents of ${OE_SOURCE_DIR}/info.txt:"
	echo
	cat ${OE_SOURCE_DIR}/info.txt
	echo
}

###############################################################################
# checkout - Checkout all layers with a given tag
###############################################################################
function checkout()
{
set_environment
env gawk -v command=checkout -v commandarg=$TAG -f ${OE_BASE}/scripts/layers.awk ${OE_LAYERS_TXT} 
}


###############################################################################
# Build the specified OE packages or images.
###############################################################################

# FIXME: convert to case/esac

if [ $# -gt 0 ]
then
    if [ $1 = "update" ]
    then
        update_all
        exit 0
    fi

    if [ $1 = "info" ]
    then
        layer_info
        exit 0
    fi

    if [ $1 = "tag" ]
    then
        if [ -n "$2" ] ; then
            TAG="$2"
        else
            TAG="$(date -u +'%Y%m%d-%H%M')"
        fi
        tag_layers $TAG
        exit 0
    fi

    if [ $1 = "changelog" ]
    then
        if [ -z $2 ] ; then
            echo "Changelog needs an argument"
            exit 1
        else
            TAG="$2"
        fi
        changelog
        exit 0
    fi
    
    if [ $1 = "checkout" ]
    then
        if [ -z $2 ] ; then
            echo "Checkout needs an argument"
            exit 1
        else
            TAG="$2"
        fi
        checkout
        exit 0
    fi

    if [ $1 = "clean" ]
    then
        clean_oe
        exit 0
    fi
fi

# Help Screen
echo ""
echo "Usage: $0 update"
echo "       $0 tag [tagname]"
echo "       $0 changelog <tagname>"
echo "       $0 checkout <tagname>"
echo "       $0 clean"
