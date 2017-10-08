#!/usr/bin/perl
foreach (<DATA>)
{
	print $_;
}
__DATA__
#!/bin/bash
#2011_07_28_15:57:33   ������   add by greshem
#==========================================================================
#����0
lvmchange 
device_mapper_lvm_usage.pl 
vgscan
vgchange -ay
fdisk -l
#ֻ�м����� ��Щģ��ſ��� �����Ĺ��� Vol�ķ���.
modprobe  ahci
modprobe  dm-mem-cache
modprobe  dm-mirror
modprobe  dm-mod
modprobe  dm-raid45
modprobe  dm-snapshot
modprobe  libata

########################################################################
#����.
device_mapper_lvm_usage.pl 
fdisk -l
file  /dev/VolGroup00/LogVol01 
file /dev/VolGroup00/LogVol01 
file /dev/mapper/VolGroup00-LogVol00 
file /dev/mapper/VolGroup00-LogVol01 
mkdir /mnt/logvol01
mount -t ext3 	/dev/mapper/VolGroup00-LogVol01 /mnt/tmp/
mount -t ext3 	/dev/mapper/VolGroup00-LogVol01 /mnt/tmp/
mount -t ext3   /dev/VolGroup00/LogVol01  /mnt/logvol01
mount -t ext3   /dev/VolGroup00/LogVol01  /mnt/logvol01

mkdir /mnt/lvm
mount -t ext3   /dev/VolGroup00/LogVol00  /mnt/lvm

########################################################################
#�� /boot/initrd-2.6.23.1-42.fc8.img ��׺�� �޸ĳ�cpio 
#�� cpio �Ĵ��� ���� �� file_type_cmd_dump.pl, �ж�Ӧ���������ʾ.
#==========================================================================
#���� ���� 
vgcreate vg0 /dev/sda1 /dev/sda2 #�����µľ�
vgdisplay vg0 
vgscan 
#==========================================================================
#pv ��ӵ� ������ȥ.
vgextend vg0 /dev/sda3
pvcreate /dev/sdb1 /dev/sdb2 /dev/sdb3 #�Դ��̳�ʼ��.
pvcreate  /dev/hdb1 #�Դ��̳�ʼ��

#==========================================================================
#�߼��� ����
lvcreate -n logic_volume_name -L 1G  vg0

#==========================================================================
#�����߼���
lvextend -L +3G /dev/VolGroup00/LogVol00
ext2online -v /dev/VolGroup00/LogVol00
resize2fs

#==========================================================================
#vgchange -a n  #ж��, ���� ɾ��   uninstall , not delete 
