#!/usr/bin/perl
foreach (<DATA>)
{
	print $_;
}
__DATA__
#!/bin/bash
#ע���: 
#1. ��Ҫ��  /tdxbstarpro/var/linux/bin/usr/bin/bash ���������� /tdxbstarpro/var/linux/bin/bash
#2.	/tdxbstarpro/var/linux/bin/usr/bin/sh ���������� /tdxbstarpro/var/linux/bin/sh
#3.	init������ļ�. 
#4.	ip �Լ��޸�. 
#5.	/tdxbstarpro/var/linux/dev/  ���� ������ /opt/qianlong/client/dev/  һ��Ҫ��devĿ¼.
#6.	��������ļ��ı����ǲ��� UTF8
#7.	��������Ҫ��  /vld/pxelinux/ Ŀ¼�� �� qianlong ���ں�, /vld/pxelinux/pxelinux.cfg/default ��Ҫ ��� tdx ��������,
#	nfs ��ip ��Ҫ����
#	����: 
#	label 2 tdx
#		kernel temp_kernel
#		append root=/dev/nfs nfsroot=172.16.8.241:/tdxbstarpro/var/linux/         panic=5         ip=dhcp vga=0x301  init=/init
#8. ����ļ��ĵ�path Ϊ /tdxbstarpro/var/linux/init
	
	
mount -o remount,rw /
cd vip2000
BOOTSERVER="172.16.8.241"
RAM_NFS=$BOOTSERVER:/mnt/ram
USERDATA_NFS=$BOOTSERVER:/tdx/userdata
mount -t nfs $RAM_NFS /tmp/ram
mount -t nfs $USERDATA_NFS /tmp/userdata

while [ 1 ];
do
#bash alwaysdoit
	./vip2000
	sleep 10;
done

