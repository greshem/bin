#!/bin/bash - 
#===============================================================================
#
#          FILE:  netclone_svn_checkout.sh
# 
#         USAGE:  ./netclone_svn_checkout.sh 
# 
#   DESCRIPTION:  取出 netclone 在本地修改。 
# 
#       OPTIONS:  ---
#  REQUIREMENTS:  ---
#          BUGS:  ---
#         NOTES:  ---
#        AUTHOR: qianzhongje@gmail.com
#       COMPANY: FH S眉dwestfalen, Iserlohn
#       CREATED: 2010年08月03.
#      REVISION:  ---
#===============================================================================

set -o nounset                              # Treat unset variables as an error

svn   --username greshem   --password richqzj co http://192.168.1.90/svn/rich_netclone2/trunk


