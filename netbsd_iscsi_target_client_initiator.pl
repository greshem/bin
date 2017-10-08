#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__
########################################################################
#netbsd-iscsi  target ����, 
rpm -ql netbsd-iscsi
#���ú� /etc/iscsi/targets  �����ļ� ��ʽ����.
#extent0		/var/lib/libvirt/images/windowsxp.img	0	100MB # ����ͨ�� ls -al ��ȡ�������ļ��Ĵ�С, ֮�� �������̾Ϳ�������.
extent0		/var/lib/libvirt/images/windowsxp.img	0	  10737418240
target0		rw	extent0		192.168.0.0/16

lsof -i:3260 
/usr/sbin/iscsi-target #��������.
#windows �� ͨ���������ĵĳ���Ϳ��԰Ѵ��̹��ع�����.
########################################################################



########################################################################
#�ͻ���.
#==========================================================================
#����:
iscsiadm --mode discovery --type sendtargets --portal  192.168.1.73:3260
#�������:
#192.168.1.73:3260,1 iqn.1994-04.org.netbsd.iscsi-target:target0

##ע��: ��ʱ���� iscsiadm  һֱ�ٵȴ�, lsof $(pidof iscsiadm ) ����, ��һ�� unix ��socket,, 
# �ƶϳ� iscsiadm �Ǻ�  initiator ���ػ����� ͨѶ��, ���� ��Ҫ���� �ػ�����.

/etc/rc.d/init.d/iscsid start #����

#��ʼ���Ӵ���: 
#��½: 
iscsiadm --mode node --targetname iqn.1994-04.org.netbsd.iscsi-target:target0  --portal 192.168.1.73:3260 --login
##���ʱ�� ͨ�� fdisk �Ϳ��Կ����� ������һ������
##�ǳ�
iscsiadm --mode node --targetname iqn.2001-05.com.doe:test --portal 192.168.1.1:3260 --logout
#
#==========================================================================


