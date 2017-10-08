#!/bin/sh
echo ------------------------------------------------------------------
#网段
echo ------------------------------------------------------------------
NETCONFIG=/etc/sysconfig/network-scripts/ifcfg-eth0
if [ -f $NETCONFIG ];then
	cat  $NETCONFIG
else 
        echo error
fi

#系统服务
echo ------------------------------------------------------------------
TFTP_CFG=/etc/xinetd.d/tftp
if [ -f $TFTP_CFG ];then
	cat $TFTP_CFG|grep disable
else 
        echo error $TFTP_CFG does not exist 
fi

#nfs导出
echo ------------------------------------------------------------------
NFS_EXPORT=/etc/exports
if [ -f $NFS_EXPORT ];then
	cat $NFS_EXPORT
else 
        echo error $NFS_EXPORT does not exist
fi

#dhcp配置
echo ------------------------------------------------------------------
DHCP_CFG=/etc/dhcpd.conf
if [ -f $DHCP_CFG ];then
	cat  $DHCP_CFG|sed '/\([0-9]\{1,3\}\.\)\{3\}/!d'
else 
        echo error $DHCP_CFG does not exist
fi

#pxelinux配置
echo ------------------------------------------------------------------
PXELINUX=/tftpboot/pxelinux.cfg/default
if [ -f $PXELINUX ];then
	cat $PXELINUX|sed '/\([0-9]\{1,3\}\.\)\{3\}/!d'
else 
        echo error $PXELINUX does not exist
fi

#乾隆数据服务
echo ------------------------------------------------------------------
DATASRV_CFG_PATH=/opt/qianlong/service/market/cfg/datasrv.ini
if [ -f $DATASRV_CFG_PATH ];then
	cat $DATASRV_CFG_PATH |sed '/\([0-9]\{1,3\}\.\)\{3\}/!d'
else 
        echo error $DATASRV_CFG_PATH does not exist
fi

#乾隆资讯服务
echo ------------------------------------------------------------------
INFOSRV_CFG_PATH=/opt/qianlong/service/market/cfg/infosrv.ini
if [ -f $INFOSRV_CFG_PATH ];then
	cat $INFOSRV_CFG_PATH |sed '/\([0-9]\{1,3\}\.\)\{3\}/!d'
else 
        echo error $INFOSRV_CFG_PATH does no exist
fi

#乾隆客户端
echo ------------------------------------------------------------------
CLIENT_INI_PATH=/opt/qianlong/client/lonld/net.ini
if [ -f $CLIENT_INI_PATH ];then
	cat $CLIENT_INI_PATH |sed '/\([0-9]\{1,3\}\.\)\{3\}/!d'
else 
        echo error $CLIENT_INI_PATH does not exist
fi
