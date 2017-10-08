#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__
########################################################################
#iso_search_file.pl aoe root client 可以找到之前的项目. 2009 年的东西了.
modprobe aoe
modprobe aoe aoe_iflist="eth0 eth1"
mkdir /dev/etherd
aoe-interfaces eth0
aoe-discover
aoe-stat
mke2fs /dev/etherd/e1.1
mkdir /mnt/e1.1
mount /dev/etherd/e1.1 /mnt/e1.1
aoe-revalidate e1.1


########################################################################
#上面的一些步骤都是老版本这样的
#新版本 ls /dev/etherd/ 出现设备的话就去挂载 
之后的块设备的用法 和  mount_img_usage.pl 基本就一样了.

