#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__
########################################################################
#netbsd-iscsi  target 服务, 
rpm -ql netbsd-iscsi
#配置好 /etc/iscsi/targets  配置文件 格式如下.
#extent0		/var/lib/libvirt/images/windowsxp.img	0	100MB # 或者通过 ls -al 获取完整的文件的大小, 之后 整个磁盘就可以用了.
extent0		/var/lib/libvirt/images/windowsxp.img	0	  10737418240
target0		rw	extent0		192.168.0.0/16

lsof -i:3260 
/usr/sbin/iscsi-target #启动服务.
#windows 下 通过控制面板的的程序就可以把磁盘挂载过来了.
########################################################################



########################################################################
#客户端.
#==========================================================================
#发现:
iscsiadm --mode discovery --type sendtargets --portal  192.168.1.73:3260
#结果如下:
#192.168.1.73:3260,1 iqn.1994-04.org.netbsd.iscsi-target:target0

##注意: 有时候发现 iscsiadm  一直再等待, lsof $(pidof iscsiadm ) 发现, 有一个 unix 的socket,, 
# 推断出 iscsiadm 是和  initiator 的守护进程 通讯的, 所以 需要启动 守护进程.

/etc/rc.d/init.d/iscsid start #启动

#开始连接磁盘: 
#登陆: 
iscsiadm --mode node --targetname iqn.1994-04.org.netbsd.iscsi-target:target0  --portal 192.168.1.73:3260 --login
##这个时候 通过 fdisk 就可以看出来 增加了一个磁盘
##登出
iscsiadm --mode node --targetname iqn.2001-05.com.doe:test --portal 192.168.1.1:3260 --logout
#
#==========================================================================


