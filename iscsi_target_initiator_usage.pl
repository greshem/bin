#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__
########################################################################
#�����
rpm -ql scsi-target-utils-1.0.1-4.fc13.x86_64 #��������Ӧ��rpm��.
cat /etc/tgt/targets.conf 
#--------------------------------------------------------------------------
#�������˵���������
/usr/sbin/tgt-admin #perl �ű�, ����Ķ��������ļ��Ľ��� f13 64 ��������, ��Ҫ�Լ��޸���.
	tgt-admin -s 
	tgt-admin -e ���¼��� �����ļ�.
/usr/sbin/tgt-setup-lun #perl
/usr/sbin/tgtadm
/usr/sbin/tgtd
/usr/sbin/tgtimg

#--------------------------------------------------------------------------
#target  ������.
<target iqn.2008-09.com.example:winxp>
    <direct-store  /var/lib/libvirt/images/windowsxp.img.bak>
        vendor_id "linux"
    </direct-store>
</target>
tgt-admin -s

########################################################################
########################################################################
########################################################################
#�ͻ���  iscsi-initiator-utils
#f8 ���� 
rpm -ql iscsi-initiator-utils-6.2.0.865-0.2.fc8
cat /etc/iscsi/initiatorname.iscsi #�ڲ������ initiator ������.
4��������
/sbin/iscsi-iname
/sbin/iscsiadm
/sbin/iscsid
/sbin/iscsistart
#���ַ������Ĵ���,
iscsiadm -m discovery -t sendtargets -p 192.168.0.244:3260
iscsiadm -m discovery -t st-         -p  192.168.1.147 -l

#==========================================================================
#����:
iscsiadm --mode discovery --type sendtargets --portal  192.168.1.73:3260
##��ʱ���� iscsiadm  һֱ�ٵȴ�, lsof $(pidof iscsiadm ) ����, ��һ�� unix ��socket, ������������, 
## iscsiadm ��  initiator ���ػ����� ͨѶ��,  ��Ҫ���� �ػ�����,
#
/etc/rc.d/init.d/iscsid start #����
#
##�������:
#192.168.1.73:3260,1 iqn.1994-04.org.netbsd.iscsi-target:target0
#
##
##��½: 
iscsiadm --mode node --targetname iqn.1994-04.org.netbsd.iscsi-target:target0  --portal 192.168.1.73:3260 --login
##���ʱ�� ͨ�� fdisk �Ϳ��Կ����� ������һ������
##�ǳ�
iscsiadm --mode node --targetname iqn.2001-05.com.doe:test --portal 192.168.1.1:3260 --logout
#

#==========================================================================

########################################################################
########################################################################
########################################################################
########################################################################
#dhcp #ע����:::: ��Ϊ�ָ�
dhcp-option=net:diskless,17,"iscsi:192.168.1.147::::iqn.2008.com.linuxce:linuxce.windiskless.20090210124113"


########################################################################
#netbsd-iscsi  target ����, 
rpm -ql netbsd-iscsi
���ú� /etc/iscsi/targets  �����ļ� ��ʽ����.
#extent0		/var/lib/libvirt/images/windowsxp.img	0	100MB # ����ͨ�� ls -al ��ȡ�������ļ��Ĵ�С, ֮�� �������̾Ϳ�������.
extent0		/var/lib/libvirt/images/windowsxp.img	0	  10737418240
target0		rw	extent0		192.168.0.0/16

lsof -i:3260 
/usr/sbin/iscsi-target #��������.
#windows �� ͨ���������ĵĳ���Ϳ��԰Ѵ��̹��ع�����.
