# INHERIT like this doesn't work anymore, if you want to use 
# externalsrc, gitver or gitpkgv features you have to alter the recipe itself (add .bbappend)
# INHERIT_append_pn-luna-sysmgr = "externalsrc gitpkgv"
# SRCREV_pn-luna-sysmgr = "${GITSHA}"

# S_pn-luna-sysmgr = "/OE/projects/${PN}"
# SRCPV_pn-luna-sysmgr = "1+LOCAL"

#enable this if you have patches in SRC_URI and it's git:// 
#otherwise default will overwrite your local changes when applying patches
#PATCHTOOL_pn-luna-sysmgr = "patch"
#other option is to empty SRC_URI
#SRC_URI_pn-luna-sysmgr = ""
#but then be sure you have also SRCPV set to something
#SRCREV_pn-luna-sysmgr = "LOCAL"
#LOCALCOUNT_pn-luna-sysmgr = "1"
#SRCPV_pn-luna-sysmgr = "${LOCALCOUNT}+${SRCREV}"
