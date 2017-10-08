#!/bin/sh
rsync -v -a -e ssh --exclude='/proc/*' --exlude='/sys/*' CLIENT_IP:/ DISKLESSDIR/root
rsync -auqz 192.168.3.201::rsync_gmmold $(pwd)
rsync -auqz 192.168.3.201::qianlong /opt/qianlong/sysdata
rsync -avz rsync://rsync.gentoo.org/gentoo-portage/ portage
SYNC="rsync://ftp3.tsinghua.edu.cn/gentoo/gentoo-portage"
rsync -r -n -t -p -o -g -x -v --progress --ignore-existing -u -c -l -H -D --existing --partial --numeric-ids -z -b 192.168.3.201::rsync_gmmold /tmp6
