#!/bin/sh
#dialog --form qian 40 40 30 test 10 10 10 10 10 10 10
#dialog --form qian 40 40 30 label1 10 10 10 10 10 10 10
strstr() {
  [ "${1#*$2*}" = "$1" ] && return 1
  return 0
}
##################
#
#
##################
#get_set_ip eth? ip netmask gateway nameserver
############################################################################
############################################################################
##################
#	function get_set_ip 
#	@eth0
#	@ipaddr
#	@netmask
#	@gateway
#	@nameserver
###################
get_set_ip()
{
echo $@
[ ! $#  -eq 5 ]  && return 0
[ -z $1 ]&& echo $0 eth* 
strstr $1 eth || return  0

local  NETCONFIG IP NETMASK GATEWAY NAMESERVER 
IP=$2
NETMASK=$3
GATEWAY=$4
NAMESERVER=$5
NETCONFIG=/etc/sysconfig/network-scripts/ifcfg-$1
#NETCONFIG=ifcfg_$1

if [ ! -f $NETCONFIG ];then
	echo error: $NETCONFIG does not exists,will creat it
	touch $NETCONFIG
 fi
#set_ip
chmod 777 $NETCONFIG 
if ! grep DEVICE $NETCONFIG;then
	echo DEVICE=$1 >> $NETCONFIG
fi

if ! grep GATEWAY $NETCONFIG;then
	echo GATEWAY=$GATEWAY >> $NETCONFIG
fi

if ! grep ONBOOT $NETCONFIG;then
	echo ONBOOT=yes >> $NETCONFIG
fi

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
	echo NETMASK=$NETMASK  >>$NETCONFIG
fi
if  grep BOOTPROTO=dhcp  $NETCONFIG;then
	sed 's/BOOTPROTO=dhcp/BOOTPROTO=static/g' $NETCONFIG
fi
if ! grep BOOTPROTO=static  $NETCONFIG;then
	echo BOOTPROTO=static>>$NETCONFIG
fi
if ! grep $NAMESERVER  /etc/resolv.conf;then
	echo nameserver $NAMESERVER >> /etc/resolv.conf
fi
sed -i "/IPADDR/{s/.*/IPADDR=$IP/g}" $NETCONFIG
sed -i "/ONBOOT/{s/no/yes/g}" $NETCONFIG

return 1
}
############################################################################
############################################################################
####################
# main eth?
# @eth? config eth 
#####################
 main() 
{
 [ ! $# -eq 1 ] && return 0 
 
eth=$1;
####################
#	function dialog  
#--form label x y item x y field_len item_len comment ....
####################
#orgine ip  
orgineIP=$( grep IPADDR /etc/sysconfig/network-scripts/ifcfg-eth0  |awk -F"=" '{print $2}'  )
dialog  --ok-label "Submit"           --help-button           --item-help           --backtitle "netcard setting"           \
--form "netcard setting." 20 50 		\
0         \
"IP:" 			1 1 "$orgineIP" 	1 10 16 0 	"ip_addr	"         \
"netmask:"      	2 1 "255.255.255.0"  	2 10 16 0 	"net_mask	"         \
"gateway:"      	3 1 "192.168.3.254"  	3 10 16 0  	"gateway	"         \
"nameserver:"     	4 1 "202.96.69.38" 	4 10 16 0 	"namesever	" 2> error

ip=$(sed -ne '1p' error);
netmask=$(sed -ne '2p' error);
gateway=$(sed -ne '3p' error);
nameserver=$(sed -ne '4p' error);

rm -f error 

#echo ip $ip
#echo netmask $netmask
#echo gateway $gateway
#echo nameserver $nameserver

get_set_ip $eth  $ip $netmask $gateway $nameserver
if [ $? -eq 1 ];then
	dialog --msgbox "$eth setup_success" 10 20 
	echo ok$eth >> eth_setup
else
	dialog --msgbox "$eth setup_failure" 10 20 
	return  1
fi
return 0
}
############################################################################
############################################################################

select_eth()
{
value="dialog --backtitle \"Qianlong Net Setting\" \
	--title \"Configuring network\" \
	--default-item Dialog \
	--menu \"please select netcard to config \" 19 50 6 "
eth_count=$(grep eth -c  /proc/net/dev )
for each in $(seq 0 $(expr $eth_count - 1) )
do
echo $each
value=${value}"eth${each} \"\" "
done
eval   $value 2> error;
eth=$(cat error)
#rm -f error

#echo $eth
}
all_setup()
{
eth_count=$(grep eth -c  /proc/net/dev )
for each in $(seq 0 $(expr $eth_count - 1) )
do
	if ! grep $each eth_setup ;then
		return 1
	fi
done

 return 0
}
############################################################################
############################################################################
#main_loop
while [ 1 ]
do
select_eth 
main $(cat error)
all_setup 
if [ $? -eq 0 ];then
	break
fi
done
rm eth_setup -f 
exit 0
