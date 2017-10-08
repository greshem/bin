#!/bin/sh
#fdisk -l |sed -e  '/./{H;$!d}'  -e 'x;/16699/!d'

for each in $(cat init  |grep fdisk |sh |grep ^\/ |awk '{print $1}'); 
do 
	if [ ! -d $(basename $each) ];then 
		mkdir /mnt/$(basename $each);
	fi ; 
	mount -t vfat $each $(basename $each) -o iocharset=gb2312;
done


ntfs-3g /dev/sda1 /mnt/sda1 
mount -t vfat /dev/sda1 /mnt/sda1
mount -t vfat /dev/sdb1 /mnt/sdb1
mount -t vfat /dev/sdb2 /mnt/sdb2
mount -t vfat /dev/sdb3 /mnt/sdb3
mount -t vfat /dev/sdb4 /mnt/sdb4
mount -t vfat /dev/sda5 /mnt/sda5
mount -t vfat /dev/sda6 /mnt/sda6
mount -t nfs 192.168.3.189:/usr/source/as5.0 /nfs -o nolock
mount -t nfs 192.168.3.200:/tmp5 /nfs200 -o nolock
mount -t cifs -o username=qzj,password=qzj //192.168.3.253/ProgramsVSS /root/vss
mount -t nfs 192.168.3.223:/tmp5 /nfs223
mount -t smbfs -o username=administrator,password=123456 //192.168.3.222/srvcontrol /smbfs222_srvcontrol/
mount -t smbfs -o username=administrator,password=123456 //192.168.3.222/rttools /smbfs222
mount -t smbfs -o username=administrator,password=123456 //192.168.3.47/baidump3 /smbfs47
mount -t cifs -o username=administrator,password=123456 //192.168.3.47/baidump3 /smbfs47
mount -t smbfs -o username=administrator,password=123456 //192.168.3.222/linux3X /smbfs222
mount -t smbfs -o username=administrator,password=q******************************n //192.168.3.234/qianlong_all /smbfs234
mount -t smbfs -o username=administrator,password=cjhltql //192.168.10.131/测试发布/linux setup /smbfs
mount -t cifs -o username=administrator,password=cjhltql //192.168.10.131/测试发布/linux setup /smbfs
mount -t cifs -o username=administrator,password=cjhltql //192.168.10.131/测试发布/ /smbfs
mount -t smbfs -o username=administrator,password=q******************************n //192.168.3.47/rttool /smbfs47
mount -t smbfs -o username=administrator,password=q******************************n //192.168.3.47/3xlinux /smbfs47_2/
mount -t smbfs -o username=administrator,password=q******************************n //192.168.3.47/backup /smbfs47
mount -t nfs 192.168.3.230:/tmp6 /nfs -o nolock
mount -t smbfs -o username=administrator,password=q******************************n //192.168.3.47/lonld_l2 /smbfs47_3/
sshfs administrator@192.168.3.47:/ /sshfs47
