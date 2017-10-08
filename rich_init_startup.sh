#!/bin/bash

#2011_02_25_10:12:21   ������   add by greshem, ����˷ָ���. 

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
# ѡ ���� ����. 
#

while [ 1 ]; do
	echo "��һ��֤ȯӪҵ�������ϵͳӦ�ý������"
	echo "��ѡ��װ:"
	echo "	1:��װ��������"
	echo "	2:��װ��������"
	echo "������1����2�󰴻س��Լ���"
	read ch
	if [ "${ch}" != 1 ] && [ "${ch}" != 2 ]; then
		clear
		echo 
		echo "���벻��ȷ������������"
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
# ��װrpm��, �Լ���ȫ���õ�����.  
#

#tar -zxf /root/pack.tgz -C /root/

unzip -P RICHTECH /root/pack.zip -d /root/ > /dev/null

if ! /root/myunzip; then
	clear
	echo "��ѹmyunzip ������. ���ִ���"
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
# �������. 
#
if [ ! -d /sys/class/net/eth0 ]; then
	clear
	echo "û�з����������������ģʽ"
	/bin/bash
fi

clear
echo -n "��һ��֤ȯӪҵ�������ϵͳӦ�ý������:"
if [ "${ROLE}" == "master" ]; then
	echo " ��������"
else
	echo " ��������"
fi

echo ""

net_num=
int_num=


########################################################################
# �ڲ������. 
#

while [ 1 ]; do
	echo "��һ��:�����ڲ������(8λ16���ƣ���12ABCD34)��"
	echo "��������Ĭ��ʹ��MAC��ַ��8λ��Ϊ�ڲ������"
	read int_num	

	if [ -z ${int_num} ]; then
		HWADDR=$(get_hwaddr)
		int_num=${HWADDR:4}
	fi

	if ! /bin/check_node.pl  ${int_num}; then
		clear
		echo "���Ϸ�������ţ��ɽ��ܵ��ַ���0-9, A-F, a-f"
		echo
	else
		break
	fi
done


clear
echo "��һ��֤ȯӪҵ�������ϵͳӦ�ý������:"

#HWADDR=$(get_hwaddr)
#echo ${hwaddr:4}

########################################################################
# ��������IPXЭ��.
#

while [ 1 ]; 
do
	echo "�ڶ�������һ����������IPXЭ��"
	echo "����8λ16��������ţ�"
	read net_num
	#if ! /root/pack/testnode ${net_num}; then
	if ! /bin/check_node.pl  ${net_num}; then
		clear
		echo "���Ϸ�������ţ��ɽ��ܵ��ַ���0-9, A-F, a-f"
		echo
	else
		break
	fi
done


echo "NET_NUM=${net_num}"	> /root/pack/network
echo "INT_NUM=${int_num}"	>> /root/pack/network

frame_type=
clear
echo "��һ��֤ȯӪҵ�������ϵͳӦ�ý������:"

########################################################################
# ������: ѡ��֡����
#

while [ 1 ]; 
do
	echo "��������ѡ��֡����"
	echo "	1: 802.2"
	echo "	2: 802.3"
	echo "������1����2�󰴻س��Լ���"
	read ch
	if [ "${ch}" != 1 ] && [ "${ch}" != 2 ]; then
		clear	
		echo
		echo "���벻��ȷ������������"
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
# ���Ĳ�: �ڶ�����������TCP/IPЭ��
#

echo "��һ��֤ȯӪҵ�������ϵͳӦ�ý������:"
if [ -d /sys/class/net/eth1 ]; then
	eth="eth1"
	echo "���Ĳ����ڶ�����������TCP/IPЭ��"
else
	eth="eth0"
	echo "���Ĳ�����һ����������TCP/IPЭ��"
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
		echo "����IP��ַ��"
		read ip
		if ! /bin/check_ip.pl ${ip}; then
			echo "���Ϸ���ip,����������"
			continue
		fi
		break
	done	

	while [ 1 ]; 
	do
		echo "�����������룺"
		read nm
		if ! /bin/check_ip.pl ${nm}; then
			echo "���Ϸ����������룬����������"
			continue
		fi
		break
	done

	while [ 1 ]; 
	do
		echo "����Ĭ�����أ�"
		read gw
		if ! /bin/check_ip.pl  ${gw}; then
			echo "���Ϸ������ص�ַ������������"
			continue
		fi
		break
	done

	if ! /sbin/ifconfig ${eth} ${ip} netmask ${nm} > /dev/null 2>&1; then
		if [ ${count} -gt 5 ]; then
			echo "����ʧ�ܣ������¿�������������, ���س�������"
			read key
			reboot
			break
		fi
		clear
		echo "����ʧ�ܣ��������������"
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
echo "��һ��֤ȯӪҵ�������ϵͳӦ�ý������:"
if [ "${ROLE}" == "sub" ]; then
	while [ 1 ]; do
		echo "���������õ�����������IP:"
		read master_ip
		if ! /bin/check_ip.pl ${master_ip} ; then
			clear
			echo "���Ϸ���ip��ַ������������"
			continue
		fi
		break
	done

	clear
	while [ 1 ]; do
		echo "���������õ�����������:"
		read master_name
		if ! /bin/check_name.pl ${master_name}; then
			clear
			echo "���Ϸ��ķ�����������������ֻ�������ֺ���ĸ���ɣ��ҳ���6���ַ�,����������"
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
# ���岽: ����root��samba,��nwserv����
#


echo "��һ��֤ȯӪҵ�������ϵͳӦ�ý������:"
echo "���岽������root��samba,��nwserv����"
echo "ע�⣺���볤��Ҫ����6λ"
pw1=
while [ 1 ]; do
	echo "���������룺"
	read pw1 
	if [ ${#pw1} -lt 6 ]; then
		echo "����������6λ������������"
		continue
	else
		break
	fi
done

/root/pack/busybox passwd root ${pw1} > /dev/null 2>&1

########################################################################
#sed replace nwserv.conf ��������� 
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
# �����������ñ�����
#

echo "��һ��֤ȯӪҵ�������ϵͳӦ�ý������:"
echo "�����������ñ�����"

name=
while [ 1 ]; do
	echo "�����뱾����:"
	read name	
	if ! /bin/check_name.pl ${name}; then
		echo "���Ϸ��Ļ�������������Ӧ�ɴ�Сд��ĸ���������,�ҳ���Ҫ����6���ַ�"
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
#  ���߲�����ѹ�����ļ�,������Ҫ5��10����... 
#

echo "��һ��֤ȯӪҵ�������ϵͳӦ�ý������:"
echo "���߲�����ѹ�����ļ�,������Ҫ5��10����..."
tar -xzf /root/disk.tgz -C /vld/disks/
chmod -R 755 /vld 
echo "��������ɣ�ϵͳ������������"

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
