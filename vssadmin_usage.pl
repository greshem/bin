#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__
1. #要启用本地C盘的卷影副本功能，并且将该卷的副本保存到E盘上，卷影副本存储空间的大小设置为900mb
vssadmin add shadowstorage /for=c: /on=e: /maxsize=900mb 
2. # 对C盘禁用卷影副本，可以执行命令 (windows 7中不支持该命令)
vssadmin delete shadowstorage /for=c:
3. # 查看C盘卷影复本存储关联
vssadmin list shadowstorage /for=c:
4.  为C盘上的共享文件创建快照
vssadmin create shadow /for=c:
vssadmin create shadow /for=c: /autoretry=6 #如果创建失败就会在60秒之后重新执行快照创建操作
5.  删除卷影 最老的快照.
vssadmin delete shadows /for=C: /oldest
#删除某个id 的卷影
vssadmin delete shadows /shadow={3a9bdea8-88f8-488a-b7d6-19c519ea6dfc}
6. 查看C盘的卷影
vssadmin list shadow /for=c:
7.快速恢复卷
vssadmin revert shadow /shadow={3a9bdea8-88f8-488a-b7d6-19c519ea6dfc}

