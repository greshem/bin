#!/usr/bin/perl
foreach (<DATA>)
{
	print $_;
}
__DATA__
rsync -av --exclude=.git/ rsync://rsync.samba.org/ftp/unpacked/rsync rsync

########################################################################
passwd
/usr/bin/rsync -avR --password-file=/etc/test.pwd test@192.168.1.135::WEB2/.5/.4/.0/.4/.5/.5/.7/13950402/ /image  >> file.log

########################################################################
#cpan
mkdir /vm/CPAN
cd /vm
rsync -av --delete mirrors.ibiblio.org::CPAN CPAN/
#
#rsync://mirrors3.kernel.org/mirrors/CPAN
#
########################################################################
#rsync 常见的命令如下
##!/bin/sh
#rsync -v -a -e ssh --exclude='/proc/*' --exlude='/sys/*' CLIENT_IP:/ DISKLESSDIR/root
#rsync -auqz 192.168.3.201::rsync_gmmold $(pwd)
#rsync -auqz 192.168.3.201::qianlong /opt/qianlong/sysdata
#rsync -avz rsync://rsync.gentoo.org/gentoo-portage/ portage
#rsync -av  rsync://rsync.gentoo.org/gentoo-portage/ portage #对于有些网站 对 zip 压缩很反感 就去掉z

#ibm 的 aix 的软件包
rsync -av   rsync://public@www.oss4aix.org/public  oss4aix     
#用户名密码都是public
#
#SYNC="rsync://ftp3.tsinghua.edu.cn/gentoo/gentoo-portage"
#rsync -r -n -t -p -o -g -x -v --progress --ignore-existing -u -c -l -H -D --existing --partial --numeric-ids -z -b 192.168.3.201::rsync_gmmold /tmp6
#
#

#################################
##配置文件. /etc/rsyncd.conf
#################################
uid = nobody
gid = nobody
max connections = 200
timeout = 600
use chroot = no
read only = yes
pid file=/var/run/rsyncd.pid
hosts allow =192.168.3.230 
hosts allow =127.0.0.1
#syslog facility = local7
log file=/var/log/rsyncd.log
#rsync config
#The 'standard' things
[qianlong]                   
path = /opt/qianlong/sysdata
comment =  qianlong_data

########################
#client
#list 
rsync  --list-only  root@192.168.1.16::
rsync  --list-only  root@192.168.1.16::root
rsync  --list-only  root@192.168.1.16::ini_section_as_modules

#sync 
rsync -avz  rsync://192.168.126.130/qianlong bbb
rsync   --bwlimit=500 -avz  rsync://192.168.200.101/qianlong  lenovo

