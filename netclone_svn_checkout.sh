#!/bin/bash - 
#===============================================================================
#
#          FILE:  netclone_svn_checkout.sh
# 
#         USAGE:  ./netclone_svn_checkout.sh 
# 
#   DESCRIPTION:  ȡ�� netclone �ڱ����޸ġ� 
# 
#       OPTIONS:  ---
#  REQUIREMENTS:  ---
#          BUGS:  ---
#         NOTES:  ---
#        AUTHOR: qianzhongje@gmail.com
#       COMPANY: FH Südwestfalen, Iserlohn
#       CREATED: 2010��08��03.
#      REVISION:  ---
#===============================================================================

set -o nounset                              # Treat unset variables as an error

svn   --username greshem   --password richqzj co http://192.168.1.90/svn/rich_netclone2/trunk


