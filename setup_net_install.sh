#!/bin/sh
#2008-02-15 之后把限制的东西全部修改掉
#必备条件是一定要有as4.0 Update4 的镜像拷贝
#######################################
#把正确的as4.0 update4 的光盘 放到位
############################
#缺省为 189 上的 nfs导出目录
###################
 [[ -f /bin/echo_color ]] && . /bin/echo_color
function check_file()
{
	 [[ ! -f $1 ]]&&echo_color 49 31 "ERROR: $1 file not exist,you should copy the readhat as4.0 update4 iso to current dir" &&return 0
}
if  check_file as4.0_U4_dvd.iso;then
echo "we will get the iso from 192.168.3.189"
mount -t nfs 192.168.3.189:/usr/source/as5.0 /nfs
cd /nfs
pwd=$(pwd)
else

	qloop as4.0_U4_dvd.iso
	pwd=$(pwd)
fi
##########
#没有添加对光盘的检查，.discinfo中的内容
####################################
find dir/ |grep pxeboot
cp dir/images/pxeboot/initrd.img /tftpboot/initrd_as4.4.initrd
cp dir/images/pxeboot/vmlinuz /tftpboot/vmlinuz_as4.4.vmlinuz
if ! grep label.*as4.4 /tftpboot/pxelinux.cfg/default;then
	sed -i '$a \label as4.4\n kernel vmlinuz_as4.4.vmlinuz \n append initrd=initrd_as4.4.initrd \n' /tftpboot/pxelinux.cfg/default
###################
#kickstart文件来实现自动化安装
# 格式是 nfs:192.168.3.189:/export/dir/kickstart.file
#######################
#sed -i '$a \label as4.4\n kernel vmlinuz_as4.4.vmlinuz \n append initrd=initrd_as4.4.initrd ks=nfs:192.168.3.47:/mnt/sdb1/ks1.cfg\n' /tftpboot/pxelinux.cfg/default
#ks=ip:/$(pwd)/ks.cfg
	sed -i '/default/{s/.*/default as4.4/g}' /tftpboot/pxelinux.cfg/default
else
	echo "your system have seems to support the pxe install"
fi
#################
#grew -w 区别别 nfs nfsroot
###############
if  grep -w $pwd /etc/exports;then
 echo " $pwd have exists in the /etc/exports"
else
echo "$pwd *(sync,rw,no_root_squash)" >>/etc/exports
fi

umount /nfs/dir

###################
#生成kickstart 文件
###################
cat > kickstart.file << EOF
# Kickstart file automatically generated by anaconda.

install
#cdrom
nfs --server=192.168.3.47 --dir=/mnt/sdb1
lang en_US.UTF-8
keyboard us
network --device eth0 --bootproto static --ip 192.168.3.225 --netmask 255.255.255.0 --gateway 192.168.3.254 --nameserver 202.96.209.5,202.96.209.133 --hostname localhost
rootpw --iscrypted $1$nhMl2eL6$ys/0JK5q6eb.U2dLvHjdK1
firewall --disabled
authconfig --enableshadow --enablemd5
selinux --disabled
timezone Asia/Shanghai
bootloader --location=mbr 
clearpart --all 
autopart
zerombr yes
reboot

%packages
@legacy-network-server
@smb-server
@web-server

%post
chkconfig sendmail off
[ -x /system/install ] && cd /system && ./install

EOF

echo -e "\033[49;31m you should do as flows \033[0m"
echo -e "\033[49;31m service xinetd restart :tftp server\033[0m"
echo -e "\033[49;31m service dhcpd restart \033[0m"
echo -e "\033[49;31m service portmap restart \033[0m"
echo -e "\033[49;31m service nfs restart  \033[0m"