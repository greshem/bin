#!/bin/sh
####################################################################
##检测编译环境，最新安装如何处理，完全安装又如何处理
##处理好dhcp包，下面的检测不够全面
##不同的操作系统处理掉
##文件包tftpboot.tar.gz nfsroot.tar.gz 处理掉
##dhcp.conf 的验证/nfsroot/pxelinux.cfg/default的IP地址的验证
##qum pum 的依赖
##dhcpd.tar.gz的安装
##
##
##
##
##
##
##version 1.1
####################################################################
VERSION=1.1
KERNEL_VER=$(uname -r)
ALL_AS_RPM=/tmp/all_as4.0_rpm
if [ ! -f $ALL_AS_RPM  ];then
   echo "the rpm-list does not exist ,no create it please wait......."
   rpm  -qa > $ALL_AS_RPM  
fi

cat   $ALL_AS_RPM |grep -v client |grep dhcp
if [ $?  -eq 0 ] ;then
       echo "you have install dhcpd rpm ;suggest that you should uninstall it"

	rpm -e dhcp
	if [ $? -eq 0 ];then
	echo " uninstall the dhcpd package "
	echo "now we will install  the tarball dhcpd"
	fi
else
echo  "no dhcpd package foudn ,go on ..."
echo "down ....... 1"
fi
####################################################################
###################################################
grep xinetd $ALL_AS_RPM >/dev/null
if [ !  $?   -eq 0 ];then 
  echo "the xinetd package does don exist,now will download it it /root/as4.0/ \n"
   qum xinetd
else 
  echo "xinetd exits"
  echo "down ...... 2"
fi
####################################################################
####################################################
grep tftp $ALL_AS_RPM  >/dev/null
if [ ! $?  -eq 0 ];then 
  echo "the tftp  package does don exist,now will download it it /root/as4.0/ \n"
   qum tftp
else 
  echo "tftpd exist"
  echo "down ...... 3"
fi

 if [ -f /etc/xinetd.d/tftp ] ;then
    sed -i '/disable/{s/yes/no/g}' /etc/xinetd.d/tftp
    echo "tftp can start now "
 else
 echo "the tftp config file does no exists"
	exit -3
 fi
####################################################################
 grep nfs-utils $ALL_AS_RPM  >/dev/null
if [ ! $? -eq 0 ];then
	echo "the nfs package does not exist,noew will download it in /root/as4.0"
 	qum nfs
else
 echo  "nfs exist "
 echo  "down ...... 4" 
fi
cat /dev/null >/etc/exports
cat  >>/etc/exports <<EOF 
/nfsroot/ *(sync,rw,no_root_squash)
/nfsroot2/ *(sync,rw,no_root_squash)
/nfsroot3/ *(sync,rw,no_root_squash)
/nfsroot4/ *(sync,rw,no_root_squash)
/nfsroot5/ *(sync,rw,no_root_squash)
EOF
####################################################################
 grep portmap $ALL_AS_RPM  > /dev/null
 if [ ! $? -eq 0 ];then
 	echo "the portmap  package does not exist,noew will download it in /root/as4.0"
 	qum portmap
 else
  echo  "port exist "
  echo  "down ...... 5" 
 fi 

####################################################################
if [ -f dhcpd.conf ] ;then
     NETCONFIG=/etc/sysconfig/network-scripts/ifcfg-eth0
     ip=$(cat $NETCONFIG |grep IPADDR |awk -F= '{print $2}')
echo $ip
     if [ -z "$ip" ];then
	echo " cannot get the ip_addr for dhcp server , exit now"
	exit -4
     fi
	sed -i "/next-server/{s/192\.168\(\.[0-9]\{1,3\}\)\{2\}/$ip/g}" dhcpd.conf
        cp -f  dhcpd.conf /etc/
fi
####################################################################
#all the thing is ok now !!
 service portmap restart
 service nfs restart
 service xinetd restart
 kill $(pidof dhcpd)

 if [ ! -f /var/state/dhcp/dhcpd.leases ];then 

  mkdir  -p   /var/state/dhcp/
  touch    /var/state/dhcp/dhcpd.leases
 fi
####
 dhcpd
 if [ $? -eq 0 ];then
    echo "dhcpd start success \n"
 else
    echo "dhcpd failed "
    exit -3
 fi
####################################################################
####################################################################
####################################################################
####################################################################
####################################################################
