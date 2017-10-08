#!/usr/bin/perl
foreach (<DATA>)
{
	print $_;
}
__DATA__


vgextend   centos /dev/sdb
lvdisplay 

lvextend  -L +2048g /dev/centos/home  

mount  |grep home

xfs_growfs  /dev/centos/home  
