#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__
########################################################################
#服务端
rpm -ql scsi-target-utils-1.0.1-4.fc13.x86_64 #服务器对应的rpm包.
cat /etc/tgt/targets.conf 
#--------------------------------------------------------------------------
#服务器端的命令如下
/usr/sbin/tgt-admin #perl 脚本, 里面的对于配置文件的解析 f13 64 上有问题, 需要自己修改下.
	tgt-admin -s 
	tgt-admin -e 重新加载 配置文件.
/usr/sbin/tgt-setup-lun #perl
/usr/sbin/tgtadm
/usr/sbin/tgtd
/usr/sbin/tgtimg

#--------------------------------------------------------------------------
#target  的例子.
<target iqn.2008-09.com.example:winxp>
    <direct-store  /var/lib/libvirt/images/windowsxp.img.bak>
        vendor_id "linux"
    </direct-store>
</target>
tgt-admin -s

########################################################################
########################################################################
########################################################################
#客户端  iscsi-initiator-utils
#f8 下用 
rpm -ql iscsi-initiator-utils-6.2.0.865-0.2.fc8
cat /etc/iscsi/initiatorname.iscsi #内部保存的 initiator 的名字.
4个命令你
/sbin/iscsi-iname
/sbin/iscsiadm
/sbin/iscsid
/sbin/iscsistart
#发现服务器的磁盘,
iscsiadm -m discovery -t sendtargets -p 192.168.0.244:3260
iscsiadm -m discovery -t st-         -p  192.168.1.147 -l

#==========================================================================
#发现:
iscsiadm --mode discovery --type sendtargets --portal  192.168.1.73:3260
##有时候发现 iscsiadm  一直再等待, lsof $(pidof iscsiadm ) 发现, 有一个 unix 的socket, 基本就明白了, 
## iscsiadm 和  initiator 的守护进程 通讯的,  需要启动 守护进程,
#
/etc/rc.d/init.d/iscsid start #启动
#
##结果如下:
#192.168.1.73:3260,1 iqn.1994-04.org.netbsd.iscsi-target:target0
#
##
##登陆: 
iscsiadm --mode node --targetname iqn.1994-04.org.netbsd.iscsi-target:target0  --portal 192.168.1.73:3260 --login
##这个时候 通过 fdisk 就可以看出来 增加了一个磁盘
##登出
iscsiadm --mode node --targetname iqn.2001-05.com.doe:test --portal 192.168.1.1:3260 --logout
#

#==========================================================================

########################################################################
########################################################################
########################################################################
########################################################################
#dhcp #注意用:::: 作为分割
dhcp-option=net:diskless,17,"iscsi:192.168.1.147::::iqn.2008.com.linuxce:linuxce.windiskless.20090210124113"


########################################################################
#netbsd-iscsi  target 服务, 
rpm -ql netbsd-iscsi
配置好 /etc/iscsi/targets  配置文件 格式如下.
#extent0		/var/lib/libvirt/images/windowsxp.img	0	100MB # 或者通过 ls -al 获取完整的文件的大小, 之后 整个磁盘就可以用了.
extent0		/var/lib/libvirt/images/windowsxp.img	0	  10737418240
target0		rw	extent0		192.168.0.0/16

lsof -i:3260 
/usr/sbin/iscsi-target #启动服务.
#windows 下 通过控制面板的的程序就可以把磁盘挂载过来了.
