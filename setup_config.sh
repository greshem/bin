#!/bin/sh
############################################################
#2008-01-16添加对于多网卡的检测，
#可以处理行情服务器等服务配置
#文件
#自动处理多网卡情况的网段的分配,主IP是用eth0的
##############################
# 20100628, 添加 dhcpd的配置界面, 全推送的处理。 
#
##########################################################

IP=
strstr() {
  [ "${1#*$2*}" = "$1" ] && return 1
  return 0
}
function msgbox()
{
	dialog --msgbox  "$@" 10 20
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
sed -i '/HWADDR/d'  $NETCONFIG
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
# comment this line, gujinguo 20100715
#sed -i "/ONBOOT/{s/no/yes/g}" $NETCONFIG

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
function DHCP_config()
{
	start="20"
	end="250"
	if [ -f "/bin/start_end" ]; then
		start=$(grep start /bin/start_end | awk -F"=" '{print $2}')
		end=$(grep end /bin/start_end | awk -F"=" '{print $2}')
	fi	
	dhcpd_conf="/tmp/dhcpd_conf";
	dhcpdIP=$( grep IPADDR /etc/sysconfig/network-scripts/ifcfg-eth0  |awk -F"=" '{print $2}'  )
	prefix_dhcpdIP=$(echo $IP | awk -F. '{print $1"."$2"."$3"."}')
	dhcpdIP_start=$prefix_dhcpdIP$start
	dhcpdIP_end=$prefix_dhcpdIP$end
	
	if [ -f "/bin/start_end" ]; then
		#option routers  192.168.3.234
		routeIP=$(/bin/getIPStrDhcpd.pl route)
		# option subnet-mask 255.255.255.0;
		netMask=$(/bin/getIPStrDhcpd.pl subnet-mask); 
		#subnet 192.168.3.0 netmask 255.255.255.0 {
		netRange=$(/bin/getIPStrDhcpd.pl subnet);
		# broadcast-address
		broadCast=$( /bin/getIPStrDhcpd.pl broadcast); 
	else
		#option routers  192.168.3.234
		routeIP=$prefix_dhcpdIP"1"
		# option subnet-mask 255.255.255.0;
		netMask=$(/bin/getIPStrDhcpd.pl subnet-mask); 
		#subnet 192.168.3.0 netmask 255.255.255.0 {
		netRange=$prefix_dhcpdIP"0";
		# broadcast-address
		broadCast=$prefix_dhcpdIP"255"; 
	fi

	dialog  --ok-label "Submit"           --help-button           --item-help           --backtitle "乾隆应用程序安装设置向导,           用上下键进行切换修改"           \
--form "DHCP设置" 20 60  \
0         \
"dhcp服务地址:	"  1 1 "$dhcpdIP"  		1 18 16 0  "dhcp服务器地址"         	\
"终端开始地址:  "  2 1 "$dhcpdIP_start"  2 18 16 0  "地址池的开始地址"         \
"终端结束地址:  "  3 1 "$dhcpdIP_end"  	3 18 16 0  "地址池的结束地址 "         \
"终端网关地址:  "  4 1 "$routeIP"  	4 18 16 0  "上级路由的地址， 选择具有路由功能和本机可以连通的机器。  "         \
"终端子网掩码:  "  5 1 "$netMask"  		5 18 16 0  "类似于255.255.255.0 "         	\
"分配子网网段:  "  6 1 "$netRange"  		6 18 16 0  "类似于 192.168.3.0, 10.1.1.0, 最后一个数值为0.  "         	\
"终端广播地址:  "  7 1 "$broadCast"  		7 18 16 0  "类似于 192.168.3.255 , 10.1.1.255 的IP地址。  " 2> /tmp/dhcpd_conf

sync
#exit 1;
dhcpdIP=$(sed -ne '1p' /tmp/dhcpd_conf);
if  /bin/CheckType.pl ip $dhcpdIP;then
	echo "is Ip";	
else
		msgbox "DHCPD $dhcpdIP 不是正确IP地址。 "; 
	return 0;
fi

dhcpdIP_start=$(sed -ne '2p' /tmp/dhcpd_conf);
dhcpdIP_end=$(sed -ne '3p' /tmp/dhcpd_conf);

routeIP=$(sed -ne '4p' /tmp/dhcpd_conf);
if [ -z $routeIP ];then
#msgbox "route 空";
echo 
else
#msgbox "route $routeIP";
	if  /bin/CheckType.pl ip $routeIP;then
		echo "is Ip";	
	else
		msgbox "routeIP $routeIP 不是正确IP地址。 "; 
		return 0;
	fi

fi

netMask=$(sed -ne '5p' /tmp/dhcpd_conf);
if [ -z $netMask ];then
#msgbox "netMask 为空";
echo 
else
#msgbox "netMask $netMask";
	if  /bin/CheckType.pl ip $netMask;then
		echo "is Ip";	
	else
		msgbox "netMask $netMask 不是正确IP地址。 "; 
		return 0;
	fi

fi

netRange=$(sed -ne '6p' /tmp/dhcpd_conf);
if [ -z $netRange ];then
#msgbox "netrange 空";
echo 
else
#msgbox "netrange $netRange";
	if  /bin/CheckType.pl ip $netRange;then
		echo "is Ip";	
	else
		msgbox "netRange $netRange 不是正确IP地址。 "; 
		return 0;
	fi

fi

broadCast=$(sed -ne '7p' /tmp/dhcpd_conf);
if [ -z $broadCast ];then
#	msgbox "broadcast 空";
echo 
else
#	msgbox "broadcast  $broadCast";
	if  /bin/CheckType.pl ip $broadCast;then
		echo "is Ip";	
	else
		msgbox "broadCast $boradCast 不是正确IP地址。 "; 
		return 0;
	fi

fi
start=$(echo $dhcpdIP_start | awk -F . '{print $4}')
end=$(echo $dhcpdIP_end | awk -F . '{print $4}')
echo "start=$start"> /bin/start_end
echo "end=$end">> /bin/start_end
echo $routeIP> /tmp/22
echo $netMask>> /tmp/22
echo $netRange>> /tmp/22
echo $broadCast>>/tmp/22
#if [ x"$routeIP"==x -o x"$netMask"==x  -o x"$netRange"==x -o x"$broadCast"==x ];then
if [ -z "$routeIP" -o -z "$netMask"  -o -z "$netRange"  -o -z "$broadCast" ];then
# -o -z $netRange -o -z $broadCast  ];then
	msgbox " 请输入所有的选项";
	return 0;
fi

#if [  ];then
# -o -z $netRange -o -z $broadCast  ];then
#	msgbox " 请输入所有的选项";
#	return 0;
#fi

DHCP_CFG="/etc/dhcpd.conf";
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
option subnet-mask $netMask;
option broadcast-address $broadCast;
option domain-name "qianlong";
option routers 	$routeIP;
option vendor-class-identifier "PXEClient";
vendor-option-space PXE; 
option PXE.mtftp-ip 0.0.0.0;
	
ddns-update-style none;
	
subnet $netRange  netmask $netMask {
	      	range dynamic-bootp $dhcpdIP_start  $dhcpdIP_end;
default-lease-time 1600;
max-lease-time 3200;
next-server $dhcpdIP;
filename "pxelinux.0";
	
}
EOF
 chmod 777 $DHCP_CFG

	return 1;
}

while [ 1 ];
do
DHCP_config 
if [  $?  -eq 1 ];then
	break;
fi
done

####################################################################
# 20100628 添加全推送的处理方式。 

if [ -f /.slave_master ];then
	if grep slave /.slave_master ;then
dialog --title "选择主备安装  上下键选择， 空格键确认。 " --radiolist "选择主备安装" 20 60 15 \
  "master" "主用LINUX服务器" off  \
  "slave"  "备用LINUX服务器" on 2> /.slave_master
	else	

#	if   grep master /.slave_master ;then
dialog --title "选择主备安装  上下键选择， 空格键确认。 " --radiolist "选择主备安装" 20 60 15 \
  "master" "主用LINUX服务器" on  \
  "slave"  "备用LINUX服务器" off 2> /.slave_master
	fi
else
dialog --title "选择主备安装  上下键选择， 空格键确认。 " --radiolist "选择主备安装" 20 60 15 \
  "master" "主用LINUX服务器" on  \
  "slave"  "备用LINUX服务器" off 2> /.slave_master
fi

#dialog --title "选择主备安装  上下键选择， 空格键确认。 " --radiolist "选择主备安装" 20 60 15 \
#  "master" "主用LINUX服务器" on  \
#  "slave"  "备用LINUX服务器" off 2> /.slave_master

function  netDcdConfig()
{

#	dialog  --inputbox "请输入全推送广播地址" 10  30 2> .netdcd_ip_addr
#	netDcdIp=$(cat .netdcd_ip_addr)
#	if  /bin/CheckType.pl ip $netDcdIp;then
#		echo "is Ip";	
#	else
#		msgbox "$netDcdIp 不是正确IP地址。 "; 
#		return 0;
#	fi
	netDcdIp=$(/bin/getIPStrDhcpd.pl broad)
	rm -f  .netdcd_ip_addr
	sed -i "/IP_0/{s/.*/IP_0=$netDcdIp/}" 	/opt/qianlong/service/market/cfg/netdcd.ini
	#IPCOUNT 保证为1. 
	sed -i "/IPCOUNT/{s/.*/IPCOUNT=1/}" /opt/qianlong/service/market/cfg/netdcd.ini

	if [ -f /.slave_master ];then
		if grep slave /.slave_master ;then
			sed -i '/Port/{s/.*/Port=9998/}' 	/opt/qianlong/service/market/cfg/netdcd.ini
		fi

		if   grep master /.slave_master ;then
			sed -i '/Port/{s/.*/Port=9999/}' 	/opt/qianlong/service/market/cfg/netdcd.ini
		fi
	fi
	return 1;
}
while [ 1 ]
do
	netDcdConfig
	if [ $? -eq 1 ];then
		break;
	fi
done
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
#grub_pxe
GRUBPXE=/tftpboot/menu.lst/default
[[ -f $GRUBPXE ]] && chmod 777 $GRUBPXE
if [  -f $GRUBPXE  ];then
	sed -i '/default/{s/default.*/default  1/}' $GRUBPXE
      if [ -n "$IP" ];then
#	sed -i "/nfsroot/{s|nfsroot[:space:]*=[:space:]*192\.168\(\.[0-9]\{1,3\}\)\{2\}:/\(.*\)[:space:]+|$IP:\/opt\/qianlong\/clinet\/lonld\ |g}" $PXELINUX
	sed -i "s|nfsroot\ *=[0-9\.]*:\(\/[a-zA-Z0-9]*\)\{1,\}|nfsroot=$IP:/opt/qianlong/client\ |g" $GRUBPXE
      fi
else
	echo "$GRUBPXE dose not exist "
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
####################################################
#	samba_add_share.sh /opt/
########################################################
 service portmap restart
 service nfs restart
 service xinetd restart
 service dhcpd start
 #l2dcd start
 #srvplat start
