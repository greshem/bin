# returns OK if $1 contains $2
strstr() {
  [ "${1#*$2*}" = "$1" ] && return 1
  return 0
}

eth_count() 
{
 [ -f /proc/net/dev ]|| mount -t proc proc /proc
  number=$(grep -c eth /proc/net/dev)
   echo  $number 
}
is_ip()
{
 local ret;
 ret=$(echo $1 |sed -n '/\(\(\(1\?[0-9]\?[0-9]\)\|\(2\([0-4][0-9]\|5[0-5]\)\)\)\.\)\{3\}\(\(1\?[0-9]\?[0-9]\)\|\(2\([0-4][0-9]\|5[0-5]\)\)\)$/p' )
  [ -z $ret ]&& echo "not ip" || echo " is ip"
   
}
get_field1()
{
 local ret;
  echo $1|cut -d\. -f1
}
get_field2()
{
 local ret;
  echo $1|cut -d\. -f2
}
get_field3()
{
 local ret;
  echo $1|cut -d\. -f3
}
get_field4()
{
 local ret;
  echo $1|cut -d\. -f4
}
####
####################################################################################################
#Usage get_set_ip eth1 
#or get_set_ip eth0
###############################
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
#通过ifconfig 设置好ip 然后设置好整个系统的ip分配
do_network()
{
 echo Usage $0 number_of_netcards
}
###############################################################################
####################################################################
##确保xinetd启动tftp服务
do_xinetd()
{
TFTP_CFG=/etc/xinetd.d/tftp
 if [ -f $TFTP_CFG ] ;then
    sed -i '/disable/{s/yes/no/g}' $TFTP_CFG
    echo "tftp can start now "
 else
 echo "error: file $TFTP_CFG  does no exists"
	exit -3
 fi
}
################################################################################
#######################################################
##设置nfs导出目录
do_nfs()
{
if ! grep client /etc/exports;then
 NFS_EXPORT=/etc/exports
 cat  >$NFS_EXPORT <<EOF 
/nfsroot/ *(sync,rw,no_root_squash)
/tmp5/ *(sync,rw,no_root_squash)
/opt/qianlong/client/ *(sync,rw,no_root_squash)
EOF
fi
}
####################################################################
##/opt/qianlong/service/market/cfg/*
##服务器配置文件目录
do_qianlong_srv()
{
QIANLONG_CFG_PATH=/opt/qianlong/service/market/cfg
#数据服务器datasrv.ini 的SERVERADDRESS=
if [ -f $QIANLONG_CFG_PATH/datasrv.ini ];then
	sed -i "/SERVERADDRESS/{s/\(.*\)=\(.*\)/\1 = $IP/g}" $QIANLONG_CFG_PATH/datasrv.ini
else 
	echo "$QIANLONG_CFG_PATH/datasrv.ini does not exist "
	exit -1
fi
#行情服务器infosrv.ini 的SERVERADDRESS=
if [ -f $QIANLONG_CFG_PATH/infosrv.ini ];then
	sed -i "/SERVERADDRESS/{s/\(.*\)=\(.*\)/\1 = $IP/g}" $QIANLONG_CFG_PATH/infosrv.ini
else 
	echo "$QIANLONG_CFG_PATH/infosrv.ini does not exist "
	exit -1
fi
#行情服务器infosrv.ini 的SRVADDRESS_0=
if [ -f $QIANLONG_CFG_PATH/infosrv.ini ];then
	sed -i "/SRVADDRESS_0/{s/\(.*\)=\(.*\)/\1 = $IP/g}" $QIANLONG_CFG_PATH/infosrv.ini
else 
	echo "$QIANLONG_CFG_PATH/infosrv.ini does not exist "
	exit -1
fi
＃点对点服务器
if [ -f $QIANLONG_CFG_PATH/scclient.ini ];then
	sed -i "/Ip/{s/\(.*\)=\(.*\)/\1 = $IP/g}" $QIANLONG_CFG_PATH/scclient.ini
else 
	echo "$QIANLONG_CFG_PATH/scclient.ini does not exist "
	exit -1
fi
＃用户权限
USERINFOTABLE=/opt/qianlong/right/userinfotable.dat
if [ -f $USERINFOTABLE ];then
 chmod 777 $USERINFOTABLE 
else
 echo "WARNGING: $USERINFOTABLE does not exist "
fi
}
################################################################################
#######################################################
####################################################################
####################################################################
##设置tftp服务下的传入内核的参数 一 默认nfs 启动，二 nfs服务器IP 三 服务器上的NFS导出的目录

do_tftp_boot()
{
PXELINUX=/tftpboot/pxelinux.cfg/default
[[ -f $PXELINUX ]] && chmod 777 $PXELINUX
[[ -d /tftpboot/pxelinux.cfg ]] && chmod 777 /tftpboot/pxelinux.cfg
if [  -f $PXELINUX  ];then
	sed -i '/default/{s/default.*/default  2/}' $PXELINUX
      if [ -n "$IP" ];then
#	sed -i "/nfsroot/{s|nfsroot[:space:]*=[:space:]*192\.168\(\.[0-9]\{1,3\}\)\{2\}:/\(.*\)[:space:]+|$IP:\/opt\/qianlong\/clinet\/lonld\ |g}" $PXELINUX
	sed -i "s|nfsroot\ *=[0-9\.]*:\(\/[a-zA-Z0-9]*\)\{1,\}|nfsroot=$IP:/opt/qianlong/client\ |g" $PXELINUX
      fi
else
	echo "$PXELINUX dose not exist "
	exit -1
fi
}
####################################################################
####################################################################
##londld 客户端的net.ini的配置
do_lonld()
{
CLIENT_PATH=/opt/qianlong/client/lonld
if [ -f $CLIENT_PATH/net.ini ];then
	sed -i "/RegSvrAddr1/{s/\(.*\)=\(.*\)/\1 = $IP/g}" $CLIENT_PATH/net.ini
else 
	echo "$CLIENT_PATH/net.ini does not exist "
	exit -1
fi
}
####################################################################
 
####################################################################
do_web_passwd()
{
 WEB_PASSWD=/var/www/html/password.conf
if [ -f $WEB_PASSWD ];then
 chmod 777 $WEB_PASSWD
else
 echo "WARNGING: $WEB_PASSWD does not exist "
fi
}
####################################################################
do_ncurses_lib()
{
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
}
#########################################################
do_bash_completion()
{
if [  -f /etc/bash_completion ];then
 if ! grep /etc/bash_completion /etc/bashrc;then
  echo . /etc/bash_completion >>/etc/bashrc
 fi
else 
	echo "NOTICE: bash_complete does not exists"
fi
}
####################################################
