###########################################################

#2010_12_21_14:57:32 add by greshem
#1. dhcpd tftp qianlong  nwserv  logtrans 都设置好. 
#2. svn cvs 都可以设置好. 
#2008-01-16添加对于多网卡的检测，
#可以处理行情服务器等服务配置
#文件
#自动处理多网卡情况的网段的分配,主IP是用eth0的
##############################
#
#
##########################################################
#!/bin/sh
IP=
strstr() {
  [ "${1#*$2*}" = "$1" ] && return 1
  return 0
}
get_set_ip()
{
[ -z $1 ]&& echo $0 eth* 
strstr $1 eth || exit 0

local  ip_from_file ip_from_command
IP=
ip_from_file=
ip_from_command=
#get_ip
NETCONFIG=/etc/sysconfig/network-scripts/ifcfg-$1
if [ -f $NETCONFIG ];then
     ip_from_file=$(cat $NETCONFIG |grep IPADDR |awk -F= '{print $2}')
   # ip_from_command=$(ifconfig |egrep 'inet addr\:192\.168\.[0-9]{1,3}\.[0-9]{1,3}' |sed 's/.*inet\ addr\:\(.*\)\ \ Bcast.*/\1/g')
     ip_from_command=$(ifconfig |sed -e "/./{H;$!d}" -e "x;/$1/!d" |egrep 'inet addr\:[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' |sed 's/.*inet\ addr\:\(.*\)\ \ Bcast.*/\1/g')

     if   [ -z "$ip_from_file" -a -z "$ip_from_command" ];then
	echo " $1 have no ip from_file from_command all zero "
     elif [ -z "$ip_from_file" -a ! -z "$ip_from_command" ];then
	IP=$ip_from_command
     elif [ -n "$ip_from_file" -a -z "$ip_from_command" ];then
	IP=$ip_from_file
     else 
	 if [ ip_from_command != ip_from_file ];then
		IP=$ip_from_command
	 else
		IP=$ip_from_command
	 fi
     fi
	echo $IP	
 else
	echo error: $NETCONFIG does not exists,will creat it
	touch $NETCONFIG
 fi
#set_ip
chmod 777 $NETCONFIG 
if ! grep IPADDR $NETCONFIG;then
	echo IPADDR=$IP>>$NETCONFIG 
fi
if ! grep BOOTPROTO  $NETCONFIG;then
	echo BOOTPROTO=static>>$NETCONFIG 
fi
if ! grep IPADDR $NETCONFIG;then
	echo IPADDR=$IP>>$NETCONFIG
fi
if ! grep NETMASK $NETCONFIG;then
	echo $(ipcalc -m $IP)  >>$NETCONFIG
fi
if  grep BOOTPROTO=dhcp  $NETCONFIG;then
	sed 's/BOOTPROTO=dhcp/BOOTPROTO=static/g' $NETCONFIG
fi
if ! grep BOOTPROTO=static  $NETCONFIG;then
	echo BOOTPROTO=static>>$NETCONFIG
fi
sed -i "/IPADDR/{s/.*/IPADDR=$IP/g}" $NETCONFIG
sed -i "/ONBOOT/{s/no/yes/g}" $NETCONFIG

}
###############################################################################
####################################################################
##获取本机eth0 的IP,并确定本机的IP,
 get_set_ip eth1  
###############################################################################
####################################################################
####################################################################
##获取本机eth1 的IP,并确定本机的IP,
get_set_ip eth0   
###############################################################################
####################################################################
##确保xinetd启动tftp服务
echo IP =  $IP
TFTP_CFG=/etc/xinetd.d/tftp
 if [ -f $TFTP_CFG ] ;then
    sed -i '/disable/{s/yes/no/g}' $TFTP_CFG
    echo "tftp can start now "
 else
 echo "error: file $TFTP_CFG  does no exists"
	exit -3
 fi
################################################################################
#######################################################
##设置nfs导出目录
if ! grep client /etc/exports;then
 NFS_EXPORT=/etc/exports
 cat  >$NFS_EXPORT <<EOF 
/nfsroot/ *(sync,rw,no_root_squash)
/tmp5/ *(sync,rw,no_root_squash)
/opt/qianlong/client/ *(sync,rw,no_root_squash)
EOF
fi
####################################################################
####################################################################
##配o置dhcpd.conf设置比较多，处理成和IP相同的网段
DHCP_CFG=/etc/dhcpd.conf
if [ -f $DHCP_CFG ];then
 chmod 777 $DHCP_CFG
 if grep sample $DHCP_CFG;then
 	rm -rf $DHCP_CFG
	echo "it is the sample config ,now remove if"
 fi
fi
     if [ -n "$IP" ];then
	subnet1=$(echo $IP|cut -d .  -f 1)
	echo subnet1 $subnet1
	subnet2=$(echo $IP|cut -d .  -f 2)
	echo subnet2 $subnet2
	subnet3=$(echo $IP|cut -d .  -f 3)
	echo  subnet3 $subnet3
	subnet4=$(echo $IP|cut -d .  -f 4)
	echo  subnet4 $subnet4
	if [ -f $DHCP_CFG ] ;then
###################################1
#		ip a class
###################################1
		if [ $subnet1  -gt 0 -a $subnet1 -lt 128 ];then
				echo echo subnet $subnet1 \>1 \<127
		 #广播地址
		 sed -i "/broadcast-address/{s/[0-9]\{1,3\}\(\.[0-9]\{1,3\}\)\{3\}/$subnet1\.255\.255\.255/g}" $DHCP_CFG
		 #路由地址
		 sed -i   "/option\ routers/{s/[0-9]\{1,3\}\(\.[0-9]\{1,3\}\)\{3\}/$subnet1\.$subnet2\.$subnet3\.254/g}" $DHCP_CFG
		 #子网
		 sed -i            "/subnet-mask/{s/[0-9]\{1,3\}\(\.[0-9]\{1,3\}\)\{3\}/255\.0\.0\.0/g}"  $DHCP_CFG
		 #tftp服务器地址
		 sed -i       "/next-server/{s/[0-9]\{1,3\}\(\.[0-9]\{1,3\}\)\{3\}/$IP/g}" $DHCP_CFG
		 #地址池
		 sed -i     "/dynamic-bootp/{s/[0-9]\{1,3\}\(\(\.[0-9]\{1,3\}\)\{3\}\)/$subnet1\1/g}" $DHCP_CFG
		 sed -i "/netmask/{s/.*/subnet $subnet1.0.0.0 netmask 255.0.0.0 \{/g}" $DHCP_CFG
		 sed -i '/NETMASK/{s|.*|NETMASK=255.0.0.0|g}' /etc/sysconfig/network-scripts/ifcfg-eth0
	
		fi
#######################################################
#	        #ip b class
###################################1
		if [ $subnet1  -gt 127 -a $subnet1 -lt 192 ];then
				echo subnet1 $subnet1 \>127 \<191
		 #广播地址
		 sed -i "/broadcast-address/{s/[0-9]\{1,3\}\(\.[0-9]\{1,3\}\)\{3\}/$subnet1\.$subnet2\.255\.255/g}" $DHCP_CFG
		 #路由地址
		 sed -i   "/option\ routers/{s/[0-9]\{1,3\}\(\.[0-9]\{1,3\}\)\{3\}/$subnet1\.$subnet2\.$subnet3\.254/g}" $DHCP_CFG
		 #子网
		 #sed -i            "/subnet/{s/[0-9]\{1,3\}\(\.[0-9]\{1,3\}\)\{3\}/$subnet1\.$subnet2\.0\.0/g}"  $DHCP_CFG
		 sed -i            "/subnet-mask/{s/[0-9]\{1,3\}\(\.[0-9]\{1,3\}\)\{3\}/255\.255\.0\.0/g}"  $DHCP_CFG
		 #tftp服务器地址
		 sed -i       "/next-server/{s/[0-9]\{1,3\}\(\.[0-9]\{1,3\}\)\{3\}/$IP/g}" $DHCP_CFG
		 #地址池
		 sed -i     "/dynamic-bootp/{s/[0-9]\{1,3\}\.[0-9]\{1,3\}\(\(\.[0-9]\{1,3\}\)\{2\}\)/$subnet1\.$subnet2\1/g}" $DHCP_CFG
		 sed -i "/netmask/{s/.*/subnet $subnet1.$subnet2.0.0 netmask 255.255.0.0 \{/g}" $DHCP_CFG
		 sed -i '/NETMASK/{s|.*|NETMASK=255.255.0.0|g}' /etc/sysconfig/network-scripts/ifcfg-eth0
		fi
#######################################################
#		ip c class
###################################1
		if [ $subnet1  -gt 191 -a $subnet1 -lt 223 ];then
				echo subnet1 $subnet1 \>191 \<223
			echo $subnet3
		 #广播地址
		 sed -i "/broadcast-address/{s/[0-9]\{1,3\}\(\.[0-9]\{1,3\}\)\{3\}/$subnet1\.$subnet2\.$subnet3\.255/g}" $DHCP_CFG
		 #路由地址
		 sed -i   "/option\ routers/{s/[0-9]\{1,3\}\(\.[0-9]\{1,3\}\)\{3\}/$subnet1\.$subnet2\.$subnet3\.254/g}" $DHCP_CFG
		 #子网
		 #sed -i            "/subnet/{s/[0-9]\{1,3\}\(\.[0-9]\{1,3\}\)\{3\}/$subnet1\.$subnet2\.$subnet3\.0/g}"  $DHCP_CFG
		 sed -i            "/subnet-mask/{s/[0-9]\{1,3\}\(\.[0-9]\{1,3\}\)\{3\}/255\.255\.255\.0/g}"  $DHCP_CFG
		 #tftp服务器地址
		 sed -i       "/next-server/{s/[0-9]\{1,3\}\(.[0-9]\{1,3\}\)\{3\}/$IP/g}" $DHCP_CFG
		 #地址池
		 sed -i     "/dynamic-bootp/{s/[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\(\.[0-9]\{1,3\}\)/$subnet1\.$subnet2\.$subnet3\1/g}" $DHCP_CFG
		 sed -i "/netmask/{s/.*/subnet $subnet1.$subnet2.$subnet3.0 netmask 255.255.255.0 \{/g}" $DHCP_CFG
		 sed -i '/NETMASK/{s|.*|NETMASK=255.255.255.0|g}' /etc/sysconfig/network-scripts/ifcfg-eth0
		fi
#######################################################
        else 
		echo "warning: file $DHCP_CFG does no exits ;now will create the default"
		cat > $DHCP_CFG <<EOF
option space PXE;
option PXE.mtftp-ip               code 1 = ip-address;  
option PXE.mtftp-cport            code 2 = unsigned integer 16;
option PXE.mtftp-sport            code 3 = unsigned integer 16;
option PXE.mtftp-tmout            code 4 = unsigned integer 8;
option PXE.mtftp-delay            code 5 = unsigned integer 8;
option PXE.discovery-control      code 6 = unsigned integer 8;
option PXE.discovery-mcast-addr   code 7 = ip-address;

allow unknown-clients;
allow bootp;
allow booting;
option subnet-mask 255.255.0.0;
option broadcast-address $subnet1.$subnet2.255.255;
option domain-name "qianlong";
option routers $subnet1.$subnet2.$subnet3.254;
option vendor-class-identifier "PXEClient";
vendor-option-space PXE; 
option PXE.mtftp-ip 0.0.0.0;
	
ddns-update-style none;
	
subnet $subnet1.$subnet2.0.0 netmask 255.255.0.0 {
	      	range dynamic-bootp $subnet1.$subnet2.1.1 $subnet1.$subnet2.254.254;
default-lease-time 1600;
max-lease-time 3200;
next-server $IP;
filename "pxelinux.0";
	
}
EOF
 chmod 777 $DHCP_CFG
 if grep sample $DHCP_CFG;then
 	rm -rf $DHCP_CFG
	echo "it is the sample config ,now remove if"
 fi
 #		exit 0
    	fi
    fi
####################################################################


####################################################################
##/opt/qianlong/service/market/cfg/*
##服务器配置文件目录
QIANLONG_CFG_PATH=/opt/qianlong/service/market/cfg
#datasrv.ini 的SERVERADDRESS=
if [ -f $QIANLONG_CFG_PATH/datasrv.ini ];then
	sed -i "/SERVERADDRESS/{s/\(.*\)=\(.*\)/\1 = $IP/g}" $QIANLONG_CFG_PATH/datasrv.ini
else 
	echo "$QIANLONG_CFG_PATH/datasrv.ini does not exist "
	exit -1
fi
#infosrv.ini 的SERVERADDRESS=
if [ -f $QIANLONG_CFG_PATH/infosrv.ini ];then
	sed -i "/SERVERADDRESS/{s/\(.*\)=\(.*\)/\1 = $IP/g}" $QIANLONG_CFG_PATH/infosrv.ini
else 
	echo "$QIANLONG_CFG_PATH/infosrv.ini does not exist "
	exit -1
fi
#infoser.ini 的SRVADDRESS_0=
if [ -f $QIANLONG_CFG_PATH/infosrv.ini ];then
	sed -i "/SRVADDRESS_0/{s/\(.*\)=\(.*\)/\1 = $IP/g}" $QIANLONG_CFG_PATH/infosrv.ini
else 
	echo "$QIANLONG_CFG_PATH/infosrv.ini does not exist "
	exit -1
fi
####################################################################
####################################################################
##设置tftp服务下的传入内核的参数 一 默认nfs 启动，二 nfs服务器IP 三 服务器上的NFS导出的目录


PXELINUX=/tftpboot/pxelinux.cfg/default
[[ -f $PXELINUX ]] && chmod 777 $PXELINUX
[[ -d /tftpboot/pxelinux.cfg ]] && chmod 777 /tftpboot/pxelinux.cfg
if [  -f $PXELINUX  ];then
	sed -i '/default/{s/default.*/default  1/}' $PXELINUX
      if [ -n "$IP" ];then
#	sed -i "/nfsroot/{s|nfsroot[:space:]*=[:space:]*192\.168\(\.[0-9]\{1,3\}\)\{2\}:/\(.*\)[:space:]+|$IP:\/opt\/qianlong\/clinet\/lonld\ |g}" $PXELINUX
	sed -i "s|nfsroot\ *=[0-9\.]*:\(\/[a-zA-Z0-9]*\)\{1,\}|nfsroot=$IP:/opt/qianlong/client\ |g" $PXELINUX
      fi
else
	echo "$PXELINUX dose not exist "
	exit -1
fi
####################################################################
##londld 客户端的net.ini的配置
CLIENT_PATH=/opt/qianlong/client/lonld
if [ -f $CLIENT_PATH/net.ini ];then
	sed -i "/RegSvrAddr1/{s/\(.*\)=\(.*\)/\1 = $IP/g}" $CLIENT_PATH/net.ini
else 
	echo "$CLIENT_PATH/net.ini does not exist "
	exit -1
fi


####################################################################

 USERINFOTABLE=/opt/qianlong/right/userinfotable.dat
if [ -f $USERINFOTABLE ];then
 chmod 777 $USERINFOTABLE 
else
 echo "WARNGING: $USERINFOTABLE does not exist "
fi
####################################################################
 WEB_PASSWD=/var/www/html/password.conf
if [ -f $WEB_PASSWD ];then
 chmod 777 $WEB_PASSWD
else
 echo "WARNGING: $WEB_PASSWD does not exist "
fi

####################################################################
####################################################################
##基本系统已经设置完毕,启动系统服务
#all_the_thing is ok now !!
 kill $(pidof dhcpd)

 if [ ! -f /var/state/dhcp/dhcpd.leases ];then 

  mkdir  -p   /var/state/dhcp/
  touch    /var/state/dhcp/dhcpd.leases
 fi
############################################
if [ -f /usr/src/libmenu.so.5.3_for_2.6 -a -f /usr/src/libform.so.5.3_for_2.6 ];then
 yes |cp /usr/src/libmenu.so.5.3_for_2.6 /usr/lib/
 yes |cp /usr/src/libform.so.5.3_for_2.6 /usr/lib/
else 
 echo "WARNING:can't patch for the libmenu libform ,file does not exit"
fi
cd /usr/lib
rm -rf libmenu.so.5
ln -s libmenu.so.5.3_for_2.6 libmenu.so.5
rm -rf libform.so.5
ln -s libform.so.5.3_for_2.6 libform.so.5
#########################################################
if [  -f /etc/bash_completion ];then
 if ! grep /etc/bash_completion /etc/bashrc;then
  echo . /etc/bash_completion >>/etc/bashrc
 fi
else 
	echo "NOTICE: bash_complete does not exists"
fi
########################################################################
#2010_12_21_14:41:11 add by greshem
#;SrvIP  =192.168.1.73

CONFIG="/root/logtrans/client_src/config.ini"
if [ -f $CONFIG ];then
	sed -i "/SrvIP/{s/\(.*\)=\(.*\)/\1 = $IP/g}" $CONFIG
else 
	echo "$CONFIG does not exist "
	exit -1
fi

CONFIG="/root/logtrans/logtrans_srv_new/config.ini"
if [ -f $CONFIG ];then
	sed -i "/SrvIP/{s/\(.*\)=\(.*\)/\1 = $IP/g}" $CONFIG
else 
	echo "$CONFIG does not exist "
	exit -1
fi

####################################################
 service portmap restart
 service nfs restart
 service xinetd restart
 service dhcpd start
 #l2dcd start
 #srvplat start
