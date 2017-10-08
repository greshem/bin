#!/bin/bash
chntpath=$(which chntpw.static)
if [ -z $chntpath ];then
	echo "chntpw.static not exist, will exist"
	exit -1;
fi
mount.pl 
mount.pl  |sh

#vfat 下是这个目录。 
if [ -d  /mnt/sdb1/windows/system32/config ];then
	cd /mnt/sdb1/windows/system32/config
else
	echo " fat32 windows sys mount failure, change 2 ntfs"
	if [ -d  /mnt/sdb1/WINDOWS/SYSTEM32/CONFIG ];then
		cd /mnt/sdb1/WINDOWS/SYSTEM32/CONFIG
	else
		echo " ntfs windows sys mount failure, die"
		exit -2;
	fi


	exit -1;
fi
#ntfs下是这个目录。 
#cd /mnt/sda1/WINDOWS/SYSTEM32/CONFIG




if [ $1 == 'restore' ];then
	echo "now restore "
	
	cp sam.org  sam
	rm sam.org
	exit -1
fi
if [ ! -f sam.org ];then
cp sam sam.org
fi
chntpw.static sam << EOF
1
y
EOF

