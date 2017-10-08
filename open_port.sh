#!/bin/sh
strstr() {
  [ "${1#*$2*}" = "$1" ] && return 1
  return 0
}

get_set_ip()
{
[ -z $1 ]&& echo $0 eth* 
strstr $1 eth || exit 0

local IP ip_from_file ip_from_command
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
	echo "have no ip"
	exit 5
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
if ! grep BOOTPROTO  $NETCONFIG;then
	echo BOOTPROTO=static>>$NETCONFIG 
else
 if  grep BOOTPROTO=static  $NETCONFIG;then
	echo " "
 fi
 if  grep BOOTPROTO=dhcp  $NETCONFIG;then
	sed 's/BOOTPROTO=dhcp/BOOTPROTO=static/g' $NETCONFIG
 fi
fi

if ! grep IPADDR $NETCONFIG;then
	echo IPADDR=$IP>>$NETCONFIG 
fi

if ! grep NETMASK $NETCONFIG;then
	echo $(ipcalc -m $IP)  >>$NETCONFIG
fi

sed -i "/IPADDR/{s/.*/IPADDR=$IP/g}" $NETCONFIG
sed -i "/ONBOOT/{s/no/yes/g}" $NETCONFIG
sed -i "/NETMASK/{s/.*/$(ipcalc -m $IP)/g}" $NETCONFIG
}
####################################################################################################
if [ ! $1  -eq  67 ];then
nmap -sS -oG open_ssh_port -p$1 192.168.3.*    
else
nmap -sU -oG open_ssh_port -p$1 192.168.3.*
fi
echo 22 80 21 45
echo 2049-nfs 67_udp dhcpd 
echo 69 tftp  445 samba 9000
grep open open_ssh_port
