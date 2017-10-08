#!/usr/bin/perl
foreach (<DATA>)
{
	print $_;
}
__DATA__
#!/bin/bash
#2011_07_28_15:57:33   星期四   add by greshem
#==========================================================================
#挂载0
lvmchange 
device_mapper_lvm_usage.pl 
vgscan
vgchange -ay
fdisk -l
#只有加载了 这些模块才可以 正常的挂载 Vol的分区.
modprobe  ahci
modprobe  dm-mem-cache
modprobe  dm-mirror
modprobe  dm-mod
modprobe  dm-raid45
modprobe  dm-snapshot
modprobe  libata

########################################################################
#挂载.
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
#把 /boot/initrd-2.6.23.1-42.fc8.img 后缀名 修改成cpio 
#对 cpio 的处理 可以 用 file_type_cmd_dump.pl, 有对应的命令的提示.
#==========================================================================
#创建 卷组 
vgcreate vg0 /dev/sda1 /dev/sda2 #建立新的卷
vgdisplay vg0 
vgscan 
#==========================================================================
#pv 添加到 卷组中去.
vgextend vg0 /dev/sda3
pvcreate /dev/sdb1 /dev/sdb2 /dev/sdb3 #对磁盘初始化.
pvcreate  /dev/hdb1 #对磁盘初始化

#==========================================================================
#逻辑卷 创建
lvcreate -n logic_volume_name -L 1G  vg0

#==========================================================================
#扩充逻辑卷
lvextend -L +3G /dev/VolGroup00/LogVol00
ext2online -v /dev/VolGroup00/LogVol00
resize2fs

#==========================================================================
#vgchange -a n  #卸载, 不是 删除   uninstall , not delete 
