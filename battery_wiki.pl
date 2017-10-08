#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__
#yum install batti
batti

rpm -ivh suspend-scripts-1.4-1mdk.noarch.rpm
pmsuspend

pm-utils-1.4.1-12.fc16.x86_64
pm-suspend


#==========================================================================
find /sys/ |grep bat -i # 找到battery 的相关的设置.

