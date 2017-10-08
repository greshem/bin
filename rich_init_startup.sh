#!/bin/bash

#2011_02_25_10:12:21   星期五   add by greshem, 添加了分割线. 

clear

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export PATH=/sbin:/bin:/usr/sbin:/usr/bin
export PS1='\W\$'


get_hwaddr()
{
	hwaddr=$(cat /sys/class/net/eth0/address)
	echo "hwaddr: " >> /root/fulldisk.log -n
	echo ${hwaddr} >> /root/fulldisk.log
	target=$(echo ${hwaddr} | awk -F":" '{print $1}')
	target=${target}$(echo ${hwaddr} | awk -F":" '{print $2}')
	target=${target}$(echo ${hwaddr} | awk -F":" '{print $3}')
	target=${target}$(echo ${hwaddr} | awk -F":" '{print $4}')
	target=${target}$(echo ${hwaddr} | awk -F":" '{print $5}')
	target=${target}$(echo ${hwaddr} | awk -F":" '{print $6}')
	echo ${target}
}



ROLE=
########################################################################
# 选 主辅 机器. 
#

while [ 1 ]; do
	echo "新一代证券营业部多操作系统应用解决方案"
	echo "请选择安装:"
	echo "	1:安装主服务器"
	echo "	2:安装副服务器"
	echo "请输入1或者2后按回车以继续"
	read ch
	if [ "${ch}" != 1 ] && [ "${ch}" != 2 ]; then
		clear
		echo 
		echo "输入不正确，请重新输入"
		continue
	fi
	break
done

if [ "${ch}" == "1" ]; then
	ROLE="master"
else
	ROLE="sub"
fi

clear


echo "ROLE: ${ROLE}" >> /root/fulldisk.log

########################################################################
# 安装rpm包, 以及安全设置的问题.  
#

#tar -zxf /root/pack.tgz -C /root/

unzip -P RICHTECH /root/pack.zip -d /root/ > /dev/null

if ! /root/myunzip; then
	clear
	echo "解压myunzip 不存在. 出现错误"
	#/bin/bash
fi

rpm -vih /root/pack/rpms/${ROLE}.rpm
rpm -vih /root/pack/rpms/ipxutils-2.2.6-10.fc9.i386.rpm 
rpm -vih /root/pack/rpms/ncpfs-2.2.6-10.fc9.i386.rpm
rpm -vih /root/pack/rpms/nwfs-1.6-1.i386.rpm
rpm -vih /root/pack/rpms/system-config-nfs-1.3.23-1.el5.noarch.rpm
rpm -vih /root/pack/rpms/expect-5.43.0-5.1.i386.rpm

rm /usr/share/rtiosrv/RUNONCE* -Rf
cp /root/pack/${ROLE}/*.ini /usr/share/rtiosrv/ -Rf

cp /root/pack/smb.conf /etc/samba/smb.conf -Rf
rm /etc/selinux/config -Rf
cp /root/pack/config /etc/selinux/ -Rf
rm /etc/sysconfig/iptables -Rf
cp /root/pack/iptables /etc/sysconfig/ -Rf
rm /etc/sysconfig/system-config-securitylevel -Rf
cp /root/pack/system-config-securitylevel /etc/sysconfig/ -Rf
gconftool-2 -s /apps/gnome-screensaver/idle_activation_enabled --type bool false
gconftool-2 -s /apps/gnome-power-manager/ac_sleep_display --type int 0

clear
########################################################################
# 网卡检测. 
#
if [ ! -d /sys/class/net/eth0 ]; then
	clear
	echo "没有发现网卡，进入调试模式"
	/bin/bash
fi

clear
echo -n "新一代证券营业部多操作系统应用解决方案:"
if [ "${ROLE}" == "master" ]; then
	echo " 主服务器"
else
	echo " 副服务器"
fi

echo ""

net_num=
int_num=


########################################################################
# 内部网络号. 
#

while [ 1 ]; do
	echo "第一步:输入内部网络号(8位16进制，如12ABCD34)："
	echo "不输入则默认使用MAC地址后8位作为内部网络号"
	read int_num	

	if [ -z ${int_num} ]; then
		HWADDR=$(get_hwaddr)
		int_num=${HWADDR:4}
	fi

	if ! /bin/check_node.pl  ${int_num}; then
		clear
		echo "不合法的网络号，可接受的字符是0-9, A-F, a-f"
		echo
	else
		break
	fi
done


clear
echo "新一代证券营业部多操作系统应用解决方案:"

#HWADDR=$(get_hwaddr)
#echo ${hwaddr:4}

########################################################################
# 网卡设置IPX协议.
#

while [ 1 ]; 
do
	echo "第二步：第一块网卡配置IPX协议"
	echo "输入8位16进制网络号："
	read net_num
	#if ! /root/pack/testnode ${net_num}; then
	if ! /bin/check_node.pl  ${net_num}; then
		clear
		echo "不合法的网络号，可接受的字符是0-9, A-F, a-f"
		echo
	else
		break
	fi
done


echo "NET_NUM=${net_num}"	> /root/pack/network
echo "INT_NUM=${int_num}"	>> /root/pack/network

frame_type=
clear
echo "新一代证券营业部多操作系统应用解决方案:"

########################################################################
# 第三步: 选择帧类型
#

while [ 1 ]; 
do
	echo "第三步：选择帧类型"
	echo "	1: 802.2"
	echo "	2: 802.3"
	echo "请输入1或者2后按回车以继续"
	read ch
	if [ "${ch}" != 1 ] && [ "${ch}" != 2 ]; then
		clear	
		echo
		echo "输入不正确，请重新输入"
		continue
	fi
	break
done


if [ "${ch}" == 1 ]; then
	frame_type="802.2"
else
	frame_type="802.3"
fi

echo "FRAME_TYPE=${frame_type}" >> /root/pack/network


chkconfig --level 35 network off
chkconfig --level 35 sendmail off
chkconfig --level 35 smb on
chkconfig --level 35 iptables on
chkconfig --level 35 nfs on
chkconfig --level 35 bluetooth off
chkconfig --level 35 pcscd off
chkconfig --level 35 cups off
chkconfig --add nwserv
chkconfig --level 35 nwserv off


if [ "${ROLE}" == "sub" ]; then
	chmod +x /root/pack/bindif
	cp /root/pack/bindif /etc/init.d/ -Rf
	sed -i '17s/^.*$/    ipx_interface add -p eth0 '${frame_type}' 0x'${net_num}'/' /etc/init.d/bindif
	chkconfig --add bindif
#	chkconfig --level 35 bindif on
#	chkconfig --level 35 nwserv off
#else
#	chkconfig --level 35 nwserv on
fi



#HWADDR=$(get_hwaddr)
#echo ${hwaddr:4}
sed -i '2s/^.*$/3	0x'${int_num}' 1/' /etc/nwserv.conf
sed -i '3s/^.*$/4   0x'${net_num}'  eth0  '${frame_type}'  1/' /etc/nwserv.conf


clear
eth=


########################################################################
# 第四步: 第二块网卡配置TCP/IP协议
#

echo "新一代证券营业部多操作系统应用解决方案:"
if [ -d /sys/class/net/eth1 ]; then
	eth="eth1"
	echo "第四步：第二块网卡配置TCP/IP协议"
else
	eth="eth0"
	echo "第四步：第一块网卡配置TCP/IP协议"
fi

ip=
nm=
gw=
declare -i count=0

while [ 1 ]; do
	count+=1
	if=
	nm=
	gw=

	while [ 1 ]; 
	do
		echo "输入IP地址："
		read ip
		if ! /bin/check_ip.pl ${ip}; then
			echo "不合法的ip,请重新输入"
			continue
		fi
		break
	done	

	while [ 1 ]; 
	do
		echo "输入子网掩码："
		read nm
		if ! /bin/check_ip.pl ${nm}; then
			echo "不合法的子网掩码，请重新输入"
			continue
		fi
		break
	done

	while [ 1 ]; 
	do
		echo "输入默认网关："
		read gw
		if ! /bin/check_ip.pl  ${gw}; then
			echo "不合法的网关地址，请重新输入"
			continue
		fi
		break
	done

	if ! /sbin/ifconfig ${eth} ${ip} netmask ${nm} > /dev/null 2>&1; then
		if [ ${count} -gt 5 ]; then
			echo "配置失败，请重新开机后重新配置, 按回车键重启"
			read key
			reboot
			break
		fi
		clear
		echo "配置失败，请检查后重新输入"
		continue
	fi

	break
done

echo "ADDRESS=${ip}" >> /root/pack/network
echo "NETMASK=${nm}" >> /root/pack/network
echo "GATEWAY=${gw}" >> /root/pack/network

clear
master_ip=
master_name=
echo "新一代证券营业部多操作系统应用解决方案:"
if [ "${ROLE}" == "sub" ]; then
	while [ 1 ]; do
		echo "输入已配置的主服务器的IP:"
		read master_ip
		if ! /bin/check_ip.pl ${master_ip} ; then
			clear
			echo "不合法的ip地址，请重新输入"
			continue
		fi
		break
	done

	clear
	while [ 1 ]; do
		echo "输入已配置的主服务器名:"
		read master_name
		if ! /bin/check_name.pl ${master_name}; then
			clear
			echo "不合法的服务器名，服务器名只能由数字和字母构成，且长于6个字符,请重新输入"
			continue
		fi
		break
	done

	clear
	target=$(echo ${master_name} | tr a-z A-Z)
	cat /root/pack/chkipx.sh | sed -e "s/XXX/${target}/g" > /usr/bin/chkipx.sh
	chmod +x /usr/bin/chkipx.sh
	cp /root/pack/chk /root/Desktop/ -Rf
fi

sleep 1
clear

########################################################################
# 第五步: 配置root，samba,及nwserv密码
#


echo "新一代证券营业部多操作系统应用解决方案:"
echo "第五步：配置root，samba,及nwserv密码"
echo "注意：密码长度要大于6位"
pw1=
while [ 1 ]; do
	echo "输入新密码："
	read pw1 
	if [ ${#pw1} -lt 6 ]; then
		echo "密码至少是6位，请重新输入"
		continue
	else
		break
	fi
done

/root/pack/busybox passwd root ${pw1} > /dev/null 2>&1

########################################################################
#sed replace nwserv.conf 里面的密码 
chmod +x /root/pack/nwmodify
/root/pack/nwmodify /etc/nwserv.conf ${pw1}


cp /etc/rc.d/rc.local /root/ -Rf


echo "if [ -x /root/pack/nw.sh ]; then" >> /etc/rc.d/rc.local
echo "	/root/pack/nw.sh"				>> /etc/rc.d/rc.local
echo "	mv /root/pack/nw.sh /root/pack/trash/ -f"	>> /etc/rc.d/rc.local
echo "fi"								>> /etc/rc.d/rc.local


echo "if [ -x /root/pack/ex.sh ]; then"	>> /etc/rc.d/rc.local
echo "	/root/pack/ex.sh ${pw1}"			>> /etc/rc.d/rc.local
echo "	mv /root/pack/ex.sh /root/pack/trash/ -f"	>> /etc/rc.d/rc.local
echo "	cp /root/pack/rc.local /etc/rc.d/rc.local -Rfv"	>> /etc/rc.d/rc.local
echo "fi" 							>> /etc/rc.d/rc.local
echo "rm /root/pack* /root/disk* /root/start -Rf" >> /etc/rc.d/rc.local
echo "mv /root/rc.local /etc/rc.d -vf" >> /etc/rc.d/rc.local

clear



clear
########################################################################
# 第六步：配置本机名
#

echo "新一代证券营业部多操作系统应用解决方案:"
echo "第六步：配置本机名"

name=
while [ 1 ]; do
	echo "请输入本机名:"
	read name	
	if ! /bin/check_name.pl ${name}; then
		echo "不合法的机器名，机器名应由大小写字母和数字组成,且长度要长于6个字符"
		continue
	else
		break
	fi
done

cat /etc/sysconfig/network | sed -e '/HOSTNAME/d' > /etc/sysconfig/network 
echo "HOSTNAME=${name}" >> /etc/sysconfig/network


if [ "${ROLE}" == "sub" ]; then
	sed -e "s/MasterIp=/MasterIp=${master_ip}/g" /root/pack/${ROLE}/option.ini > /usr/share/rtiosrv/option.ini
else
	echo "[${ip}]"		>> /usr/share/rtiosrv/server.ini	
	echo "ServerIp=${ip}"	>> /usr/share/rtiosrv/server.ini
fi

echo "[AllocIP]"	>> /usr/share/rtiosrv/option.ini
echo "dynamicIP=0"	>> /usr/share/rtiosrv/option.ini
echo "IpList=${ip}"	>> /usr/share/rtiosrv/option.ini
echo -n "StartIp=${ip%.*}" >> /usr/share/rtiosrv/option.ini
echo ".11"	>> /usr/share/rtiosrv/option.ini
echo -n "StopIp=${ip%.*}"  >> /usr/share/rtiosrv/option.ini
echo ".254" >> /usr/share/rtiosrv/option.ini


echo -n "IpAddr=${ip%.*}"	>> /usr/share/rtiosrv/template.ini
echo ".10"	>> /usr/share/rtiosrv/template.ini
echo "GateWay=${gw}"	>> /usr/share/rtiosrv/template.ini
echo "Netmask=${nm}"	>> /usr/share/rtiosrv/template.ini

cp /root/pack/moniosrv /usr/share/rtiosrv/ -Rf
chmod 777 /usr/share/rtiosrv/moniosrv 


if [ ! -d /vld ]; then
	mkdir /vld
fi

mkdir /vld/disks
mkdir /vld/restore
mkdir /vld/wks
mkdir /vld/sys
mkdir /vld/sys/login
cp /root/pack/login/* /vld/sys/login/  -Rf
cp /root/pack/Terminal /root/Desktop/ -Rf
cp /root/pack/bakup /vld -Rf
cp /root/pack/tools/* /root/Desktop/ -Rf


clear

########################################################################
#  第七步：解压镜像文件,可能需要5－10分钟... 
#

echo "新一代证券营业部多操作系统应用解决方案:"
echo "第七步：解压镜像文件,可能需要5－10分钟..."
tar -xzf /root/disk.tgz -C /vld/disks/
chmod -R 755 /vld 
echo "配置已完成，系统正在重新启动"

cd /
rm /start -Rf
sleep 2
mv /boot/grub/grub.conf /boot/grub/grub.conf.bakme
mv /boot/grub/grub.conf.bak /boot/grub/grub.conf
rm -Rf  /root/myunzip /root/disk.tgz /root/start  /root/pack.zip
sed -i 's/id:3:initdefault/id:5:initdefault/g' /etc/inittab
reboot -f
/bin/bash
/bin/bash
