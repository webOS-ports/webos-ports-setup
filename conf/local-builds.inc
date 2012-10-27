# you can create own directory with .bb and .bbappend files:
#LOCAL_BUILD_RECIPES = "/OE/webos/webos-ports/local-builds"
#BBFILES += " ${LOCAL_BUILD_RECIPES}/recipes*/*/*.bb ${LOCAL_BUILD_RECIPES}/recipes*/*/*.bbappend"

# then for each locally built recipe create .bbappend like this:
# /OE/webos/webos-ports/local-builds/recipes-webos/luna-sysmgr/luna-sysmgr.bbappend:
# inherit externalsrc gitpkgv
# S = "/OE/webos/projects/${PN}"
# B = "${S}"
# SRCPV = "LOCAL"
# PKGV = "LOCAL+gitr${GITPKGV}"

# more info:
# INHERIT like this doesn't work anymore, if you want to use 
# externalsrc, gitver or gitpkgv features you have to alter the recipe itself (add .bbappend)
# INHERIT_append_pn-luna-sysmgr = "externalsrc gitpkgv"
# SRCREV_pn-luna-sysmgr = "${GITSHA}"

#enable this if you have patches in SRC_URI and it's git:// 
#otherwise default will overwrite your local changes when applying patches
#PATCHTOOL_pn-luna-sysmgr = "patch"
#other option is to empty SRC_URI, already done by externalsrc
#SRC_URI_pn-luna-sysmgr = ""
#but then be sure you have also SRCPV set to something
#SRCREV_pn-luna-sysmgr = "LOCAL"
#LOCALCOUNT_pn-luna-sysmgr = "1"
#SRCPV_pn-luna-sysmgr = "${LOCALCOUNT}+${SRCREV}"
