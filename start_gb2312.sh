#!/bin/bash


clear

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export PATH=/sbin:/bin:/usr/sbin:/usr/bin
export PS1='\W\$'

#==========================================================================
function get_hwaddr()
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


########################################################################
#���� �� rtiosrv bsd �������� 
function  Set_main_or_sub_server()
{
	clear
	ROLE=

	while [ 1 ]; do
		echo "��һ��֤ȯӪҵ�������ϵͳӦ�ý������:"
		echo 
		echo -e "\e[49;32;1m��ѡ��װ:\e[0m"
		echo "	1:��װ��������"
		echo "	2:��װ��������"
		echo -e "������\e[49;31;1m[1]\e[0m����\e[49;31;1m[2]\e[0m����ѡ���,��\e[49;33;1m[Enter]\e[0m����"
		read ch
		if [ "${ch}" != 1 ] && [ "${ch}" != 2 ]; then
			clear
			echo "���벻��ȷ,����������"
			echo
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
	echo "ROLE: ${ROLE}" > /root/fulldisk.log
}

#==========================================================================
#��ѹzip ���� ������װ �����Ҫ�Ķ���. 
function Extract_pack_zip_and_copy_install()
{
	#tar -zxf /root/pack.tgz -C /root/
	#unzip -P RICHTECH /root/pack.zip -d /root/ > /dev/null

	if [ ! -f  /root/pack.zip ];then
		echo  "pack.zip �����ڴ���"
		echo  "pack.zip �����ڴ���" >> /var/log/rich_install.log
		exit 
	fi
	if [ ! -d /root/pack ];then
		unzip -P http://www.richtech.net.cn.2010 /root/pack.zip -d /root/ > /dev/null
		#���ؽ�ѹ, ���ڵ�����֤
		#unzip -P http://www.richtech.net.cn.2010 ./pack.zip -d . > /dev/null 
	fi
	########################################################################
	#	myunzip������� unzip -P ��������, �� unzip �Ķ������� c������ȷʵ�е�ѽ�. 
	# if ! /root/myunzip; then
	# 	clear
	# 	echo "��ѹ���ִ���"
	# 	#/bin/bash
	# else
	# 	echo "myunzip ������\n";
	# fi

	########################################################################
	#f13 �� testname ��������, elf��. 
	if grep Goddard /etc/issue;then
		cp /bin/check_ip.pl  /root/pack/testip
		cp /bin/check_node.pl /root/pack/testnode
		cp /bin/check_name.pl /root/pack/testname
	fi

	if [ ! -d /root/pack ];then
		echo "��ѹʧ��,  û�� ���� pack Ŀ¼, ks.cfg �׶�û�а� isolinux.cfg/pack.zip ��������";
		echo "����zip ��"
		echo "����zip ��ɾ��"
		exit 0;
	fi

		#==========================================================================
	rpm -vih /root/pack/rpms/${ROLE}.rpm
	rpm -vih /root/pack/rpms/ipxutils-*.i386.rpm 
	rpm -ivh /root/pack/rpms/nwserv-1.0.i386.rpm --force --nodeps 
	rpm -vih /root/pack/rpms/ncpfs*.i386.rpm --force --nodeps 
	#rpm -vih /root/pack/rpms/nwfs*.i386.rpm
	rpm -vih /root/pack/rpms/system-config-nfs-*.el5.noarch.rpm
	rpm -vih /root/pack/rpms/expect-*.i386.rpm
	
	#for each in $(find /root/pack/rpms/ |grep rpm$)
	#do
	#	rpm -ivh --nodeps --force  $each 
	#done

	rm /usr/share/rtiosrv/RUNONCE* -Rf
	cp /root/pack/${ROLE}/*.ini 	/usr/share/rtiosrv/ -Rf

	#--------------------------------------------------------------------------
	#smb ���.
	cp /root/pack/smb.conf /etc/samba/smb.conf -Rf
	#--------------------------------------------------------------------------

	rm /etc/selinux/config -Rf
	cp /root/pack/selinux_config /etc/selinux/config  -Rf
	rm /etc/sysconfig/iptables -Rf
	cp /root/pack/iptables /etc/sysconfig/ -Rf
	rm /etc/sysconfig/system-config-securitylevel -Rf
	cp /root/pack/system-config-securitylevel /etc/sysconfig/ -Rf

	#--------------------------------------------------------------------------
	#snmpd ���.
	rpm -ivh --force  --nodeps  /root/pack/snmp/lm_sensors-2.10.7-9.el5.i386.rpm 
	rpm -ivh --force  --nodeps  /root/pack/snmp/net-snmp-5.3.2.2-9.el5.i386.rpm 
	cp /root/pack/snmp/snmpd.conf   /etc/snmp/ -Rf 
	chkconfig --level 2345 snmpd on
	service snmpd start
	#--------------------------------------------------------------------------
	gconftool-2 -s /apps/gnome-screensaver/idle_activation_enabled --type bool false
	gconftool-2 -s /apps/gnome-power-manager/ac_sleep_display --type int 0

	#--------------------------------------------------------------------------
	#����ӵ�rtiosrv Ŀ¼.
	if [ ! -d /usr/share/rtiosrv ];then
		mkdir /usr/share/rtiosrv
	fi	
	yes|cp -a -r -f  /root/pack/rtiosrv/* /usr/share/rtiosrv/	
	#--------------------------------------------------------------------------


	#nw_manager ģ�����������Ķ���.
	if [ ! -d /usr/share/nw_manager ];then
		mkdir /usr/share/nw_manager
	fi	
	mkdir /var/log/nwserv/
	mkdir /usr/share/useless/

	yes |cp -a -r -f /root/pack/nw_manager/*  /usr/share/nw_manager
	mv /usr/share/nw_manager/management_UI/nw_manager_no_key /usr/share/useless/
	cp -a -r -f /root/pack/nw_manager/nw_manager_init /etc/init.d/nw_manager
	chkconfig --level 35 nw_manager on
	chmod +x /usr/share/nw_manager/start.sh

	#==========================================================================
	#dell ������װ, ��װ�л���ֺܶ�Ĵ��� ���Ƿ�������ȽϺ�.
	rpm -ivh --nodeps /root/pack/rpms/OEMDRV/rpms/dkms-2.0.22.0-1.noarch.rpm
	rpm -ivh --nodeps /root/pack/rpms/OEMDRV/rpms/netxtreme2-6.0.47-1.dkms.noarch.rpm
	rpm -ivh --nodeps /root/pack/rpms/OEMDRV/rpms/mpt2sas-02.00.03.00-1dkms.noarch.rpm
	rpm -ivh --nodeps /root/pack/rpms/OEMDRV/rpms/tg3-3.110g-1.dkms.noarch.rpm
	rpm -ivh --nodeps /root/pack/rpms/OEMDRV/rpms/megaraid_sas-v00.00.04.31.2-1.noarch.rpm
	rpm -ivh --nodeps /root/pack/rpms/OEMDRV/rpms/ixgbe-2.1.4-sb_dkms.noarch.rpm
	rpm -ivh --nodeps /root/pack/rpms/OEMDRV/rpms/e1000e-1.1.19-sb_dkms.noarch.rpm
	rpm -ivh --nodeps /root/pack/rpms/OEMDRV/rpms/igb-2.3.4-sb_dkms.noarch.rpm
	rpm -ivh --nodeps /root/pack/rpms/OEMDRV/rpms/openipmi-39.1dell-2dkms.noarch.rpm


}


#==========================================================================
#����û������.
#���֧���Ŀ�����.
function Check_netcard()
{
	clear
	if [  -d /sys/class/net/eth0 -o  -d /sys/class/net/eth1 -o  -d /sys/class/net/eth2   -o -d /sys/class/net/eth3 ]; then
		echo "�������ok " >> /var/log/rich_install.log
	else
		clear
		echo "û�з�������eth0 "  >> /var/log/rich_install.log
		echo "û�з�������,�������ģʽ"
		/bin/bash
	fi

	clear
	#echo  "��һ��֤ȯӪҵ�������ϵͳӦ�ý������:"	
	#if [ "${ROLE}" == "master" ]; then
	#	echo " ��������"
	#else
	#	echo " ��������"
	#fi

	#echo ""
}

function check_integer()
{
	int_count=0
	j=0

	while [ ${j} -lt 10 ];
	do
		if [ "${tmp_date}" = "${j}" ]; then
			int_count=1;
		fi
		((j=${j}+1))
	done 
}

function check_date()
{
	i=0
	tmp_date=0
	date_count=0

	if [ ${#date_num} -eq 10 ]; then
		((date_count=${date_count}+1))
	fi

	while [ ${i} -lt 10 ];
	do
		if [ ${i} -ne 4 ] && [ ${i} -ne 7 ]; then
			tmp_date=${date_num:${i}:1}
			check_integer
			if [  ${int_count} -eq 1 ]; then 
				((date_count=${date_count}+1))
			fi
		else
			if [ "${date_num:${i}:1}" = "-" ]; then
                                ((date_count=${date_count}+1))
                        fi
		fi				
		((i=${i}+1))
	done
}

function check_time()
{
        i=0
        tmp_time=0
        time_count=0

        if [ ${#time_num} -eq 8 ]; then
                ((time_count=${time_count}+1))
        fi

        while [ ${i} -lt 8 ];
        do
                if [ ${i} -ne 2 ] && [ ${i} -ne 5 ]; then
                        tmp_time=${time_num:${i}:1}
                        check_integer
                        if [  ${int_count} -eq 1 ]; then
                                ((time_count=${time_count}+1))
                        fi
                else
                        if [ "${time_num:${i}:1}" = ":" ]; then
                                ((time_count=${time_count}+1))
                        fi
                fi
                ((i=${i}+1))
        done
}

#==========================================================================
#����ϵͳʱ��.
function Setup_system_time()
{
	clear
	date_num=
	time_num=

	while [ 1 ]; 
	do
		echo  "��һ��֤ȯӪҵ�������ϵͳӦ�ý������:"
		echo
		echo -e "\e[49;32;1mʱ������:\e[0m"
		echo "��װ�����⵽ϵͳʱ��Ϊ:" $(date);
		echo -e "�밴\e[49;33;1m[Enter]\e[0m����ʱ������ѡ��"
		echo -e "����������������,��ʽΪ\e[49;37;1m[2011-01-01]\e[0m"
		read date_num
	
		if [ ! -z "${date_num}" ]; then
			check_date
			if [ ${date_count} -ne $((${#date_num}+1)) ]; then
				clear
				echo "���벻��ȷ,����������"
				echo
				continue
			fi	
			date -s "${date_num}" > /dev/null 2>&1
			if [ $(echo $?) -ne 0 ] ; then
				clear 
				echo "���벻��ȷ,����������"
				echo
            			continue
        	fi
		fi
        break
    done

	if [ ! -z "${date_num}" ]; then
		while [ 1 ]; 
		do
			echo
			echo -e "������ʱ��,��ʽΪ\e[49;37;1m[12:00:00]\e[0m"
			read time_num

			if [ ! -z "${time_num}" ]; then				
				check_time
				if [ ${time_count} -ne $((${#time_num}+1)) ]; then
               				echo
		                 	echo "���벻��ȷ,����������"
                                	continue
                        	fi
				date -s "${time_num}" > /dev/null 2>&1
            			if [ $(echo $?) -ne 0 ]; then
					echo
                			echo "���벻��ȷ,����������"
                			continue
            			fi
        		fi
        	break
    		done

	fi

	clock -w
	clear
}

#==========================================================================
#����ipx Э�������һЩ��ַ. 
function Setup_ipx_protocol_netaddr()
{

	if [ ! -d /root/pack ];then
		echo "����: Setup_ipx_protocol_netaddr /root/pack Ŀ¼������" 
		echo "����: Setup_ipx_protocol_netaddr /root/pack Ŀ¼������" >> /var/log/rich_install.log
		exit 
	fi

	if [ ! -x /root/pack/testnode ];then
		echo "����: Setup_ipx_protocol_netaddr /root/pack/testnode  ���򲻴���." >> /var/log/rich_install.log
		echo "����: Setup_ipx_protocol_netaddr /root/pack/testnode  ���򲻴���." 
		exit 
	fi

	clear
	int_num=
	tmp=0
	rand_num=
	hex_array=
	hex_num=('A' 'B' 'C' 'D' 'E' 'F' '0' '1' '2' '3' '4' '5' '6' '7' '8' '9')
	
	while [ ${tmp} -lt 8 ]; do
		rand_num=`expr $RANDOM % 16`
		hex_array=${hex_array}${hex_num[${rand_num}]}
		((tmp=${tmp}+1))
	done

	while [ 1 ]; do
		echo "��һ��֤ȯӪҵ�������ϵͳӦ�ý������:"
		echo
		echo -e "\e[49;32;1m�ڲ����������:\e[0m"
		echo -e "��װ���򽫷���\e[49;34;1m[${hex_array}]\e[0m��Ϊ�ڲ������,��\e[49;33;1m[Enter]\e[0m�������"

		echo "�����Զ����ڲ������,������(16����8���ַ�):"
		read int_num	

		if [ -z ${int_num} ]; then
			int_num=${hex_array}
		fi

		if ! /root/pack/testnode ${int_num}; then
			clear
			echo "���Ϸ����ڲ������,�ɽ��ܵ��ַ���0-9, A-F"
			echo
		else
			break
		fi
	done
	clear
}

function Set_bond_or_ip_mode()
{
	if [ ! -d /root/pack ];then
		echo "����: Setup_ipx_protocol_netaddr /root/pack Ŀ¼������" 
		echo "����: Setup_ipx_protocol_netaddr /root/pack Ŀ¼������" >> /var/log/rich_install.log
		exit 
	fi

	if [ ! -x /root/pack/testip ];then
		echo "����: Setup_ipx_protocol_netaddr /root/pack/testip  ���򲻴���." >> /var/log/rich_install.log
		echo "����: Setup_ipx_protocol_netaddr /root/pack/testip  ���򲻴���." 
		exit 
	fi

	clear
	kind=

	while [ 1 ]; do
    		echo "��һ��֤ȯӪҵ�������ϵͳӦ�ý������:"
		echo
		echo -e "\e[49;32;1m�������ã�\e[0m��ѡ��:"
		echo "  1:��������ģʽ(����ģʽ)"
		echo "  2:��������IPģʽ"
		echo -e "������\e[49;31;1m[1]\e[0m����\e[49;31;1m[2]\e[0m����ѡ���,��\e[49;33;1m[Enter]\e[0m����"
        read kind
        if [ "${kind}" != 1 ] && [ "${kind}" != 2 ]; then
        	clear
        	echo "���벻��ȷ������������"
		echo
        	continue
        fi
        break
    done

	if [ "${kind}" == "1" ]; then
		bond_all_adapter
		setup_frame_type
		setup_ipx_netnode
		setup_bond0_ip
	else
		bond_select_adapter
		setup_frame_type
		setup_ipx_netnode
		setup_eth_ip
    	fi

    clear
}

function bond_select_adapter()
{
	clear
	eth_type=
    	i=0
	in=

	while [ 1 ]; do
	i=0
	echo "��һ��֤ȯӪҵ�������ϵͳӦ�ý������:"
        echo
        echo -e "\e[49;32;1m����IPXЭ��\e[0m"
        echo "��ѡ���IPXЭ�������:"
	while [ ${i} -lt 4 ];
    	do
        	if [ -d /sys/class/net/eth${i} ]; then
			echo "	${i}:eth${i}"
		fi
		((i=${i}+1))
    	done
	echo -e "����ѡ���,�밴\e[49;33;1m[Enter]\e[0m����"
	
	read in
	if [ ! -d /sys/class/net/eth${in}  ]; then
		clear
        	echo "���벻��ȷ,����������"
		echo
        	continue
        fi
		break
	
	done
	eth_type=${in}	
	clear
}

function bond_all_adapter()
{
	clear
	eth=
	i=0

	echo "DEVICE=bond0" > /etc/sysconfig/network-scripts/ifcfg-bond0
	echo "BOOTPROTO=none" >> /etc/sysconfig/network-scripts/ifcfg-bond0	
	echo "ONBOOT=yes" >> /etc/sysconfig/network-scripts/ifcfg-bond0
	echo "NETMASK=255.255.255.0" >> /etc/sysconfig/network-scripts/ifcfg-bond0
	echo "IPADDR=192.168.1.6" >> /etc/sysconfig/network-scripts/ifcfg-bond0
	echo "GATEWAY=192.168.1.95" >> /etc/sysconfig/network-scripts/ifcfg-bond0
	echo "TYPE=Ethernet" >> /etc/sysconfig/network-scripts/ifcfg-bond0

	while [ ${i} -lt 4 ];
	do
		if [ -d /sys/class/net/eth${i} ]; then
			echo "DEVICE=eth${i}" > /etc/sysconfig/network-scripts/ifcfg-eth${i}
			echo "BOOTPROTO=none" >> /etc/sysconfig/network-scripts/ifcfg-eth${i}
			echo "ONBOOT=yes" >> /etc/sysconfig/network-scripts/ifcfg-eth${i}
			echo "MASTER=bond0" >> /etc/sysconfig/network-scripts/ifcfg-eth${i}
			echo "SLAVE=yes" >> /etc/sysconfig/network-scripts/ifcfg-eth${i}
			echo "TYPE=Ethernet" >> /etc/sysconfig/network-scripts/ifcfg-eth${i}
		fi
	((i=${i}+1))
	done

	echo "alias bond0 bonding" >> /etc/modprobe.conf
	echo "options bond0 miimon=100 mode=1" >> /etc/modprobe.conf
	clear
}

#==========================================================================
function setup_ipx_netnode()
{
	clear

	#HWADDR=$(get_hwaddr)
	#echo ${hwaddr:4}
	#fixme ˫ ���� bond 
	#������  bond -  netcard  -> bond -> ipx -> tcp
	# 
	#

	while [ 1 ]; do
		echo "��һ��֤ȯӪҵ�������ϵͳӦ�ý������:"
		echo
		echo -e "\e[49;32;1m���������:\e[0m"
		echo -e "��װ��������\e[49;34;1m[$(date +%Y%m%d)]\e[0m��Ϊ�����,��\e[49;33;1m[Enter]\e[0mֱ���������"
		echo "�����Զ��������,������(16����8���ַ�):"
		read net_num

		if [ -z ${net_num} ]; then
			net_num=$(date +%Y%m%d)
		fi

		if ! /root/pack/testnode ${net_num}; then
			clear
			echo "���Ϸ��������,�ɽ��ܵ��ַ���0-9, A-F"
			echo
		else
			break
		fi
	done


	echo "NET_NUM=${net_num}"	> /root/pack/network
	echo "INT_NUM=${int_num}"	>> /root/pack/network


	#if [ "${ROLE}" == "sub" ]; then
	#	chmod +x /root/pack/bindif
	#	cp /root/pack/bindif /etc/init.d/ -Rf
	#	sed -i '17s/^.*$/    ipx_interface add -p bond0 '${frame_type}' 0x'${net_num}'/' /etc/init.d/bindif
	#	chkconfig --add bindif
	#	chkconfig --level 35 bindif on
	#	chkconfig --level 35 nwserv off
	#else
	#	chkconfig --level 35 nwserv on
	#fi



	#==========================================================================
	#д�뵽�����ļ�����ȥ
	#HWADDR=$(get_hwaddr)
	#echo ${hwaddr:4}
	#�ڲ������.
	#sed -i '/^\s*3\s+.*/ {s/^.*$/3	0x'${int_num}' 1/}' /etc/nwserv.conf
	sed -i '/^\s*3\s/ {s/^.*$/3\t0x'${int_num}' 1/}' /etc/nwserv.conf
	#�����.
	if [ "${kind}" == "2" ]; then
		sed -i "/^\s*4\s/ {s/^.*$/4   0x${net_num}  eth${eth_type}  ${frame_type}  1/}" /etc/nwserv.conf
	fi
	if [ "${kind}" == "1" ]; then
		sed -i "/^\s*4\s/ {s/^.*$/4   0x${net_num}  bond0  ${frame_type}  1/}" /etc/nwserv.conf
	fi
}

#==========================================================================
#����֡����.
function setup_frame_type()
{
	frame_type=
	clear
	while [ 1 ]; 
	do
		echo "��һ��֤ȯӪҵ�������ϵͳӦ�ý������:"
		echo
		echo -e "\e[49;32;1m����֡����:\e[0m"
		echo "	1: 802.2"
		echo "	2: 802.3"
		echo -e "������\e[49;31;1m[1]\e[0m����\e[49;31;1m[2]\e[0m����ѡ���,��\e[49;33;1m[Enter]\e[0m����"
		read ch
		if [ "${ch}" != 1 ] && [ "${ch}" != 2 ]; then
			clear	
			echo "���벻��ȷ,����������"
			echo
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
}


#==========================================================================
#��Щ������Ҫ���� ��Щһ��Ҫ�ر�. 
function Chkconfig_service()
{
	#chkconfig --level 35 network off
	chkconfig --level 35 sendmail off
	chkconfig --level 35 smb on
	chkconfig --level 35 iptables on
	chkconfig --level 35 nfs on
	chkconfig --level 35 bluetooth off
	chkconfig --level 35 pcscd off
	chkconfig --level 35 cups off
	chkconfig --add nwserv
	chkconfig --level 35 nwserv on
	chkconfig --level 35 smb on
	chkconfig --level 35 nw_manager on

	
}

#==========================================================================
function setup_bond0_ip()
{
	eth=
	ip=
	netmask=
	gw=
	declare -i count=0

	clear
	while [ 1 ]; 
	do
		count+=1
		if=
		netmask=
		gw=
	
		echo "��һ��֤ȯӪҵ�������ϵͳӦ�ý������:"
                echo
                echo -e "\e[49;32;1m������IP���ã�\e[0m"

		while [ 1 ];
		do
			echo "��������Ҫ�趨��IP��ַ:"		
			read ip                
			if ! /root/pack/testip ${ip}; then
				echo "���Ϸ���IP,����������"
				echo
				continue
			fi
		break
		done

		while [ 1 ]; 
		do
			echo "������������:"                
			read netmask                
			if ! /root/pack/testip ${netmask}; then
				echo "���Ϸ�����������,����������"
				echo 
				continue
			fi
		break
		done

		while [ 1 ]; 
		do
			echo "����Ĭ������:"
			read gw
			if ! /root/pack/testip ${gw}; then
				echo "���Ϸ������ص�ַ,����������"
				echo
				continue
			fi
		break
		done

		########################################################################
		# ����ִ��ifconfig ��.
		# if ! /sbin/ifconfig bond0 ${ip} netmask ${netmask} > /dev/null 2>&1; then
		# 	if [ ${count} -gt 5 ]; then
		# 		while [ 1 ];
		# 		do
		# 			echo -e "����ʧ��,�����¿������ٴν�������, ��\e[49;33;1m[Enter]\e[0m����������"
		# 			read -n1 key
		# 			if [  -z ${key} ]; then		
		# 					reboot
		# 			fi
		# 		done	
		# 	fi
		# 	clear
		# 	echo "����ʧ��,�������������"
		# 	echo
		# 	continue
		# fi
		break
	done

		echo "DEVICE=bond0" > /etc/sysconfig/network-scripts/ifcfg-bond0
		echo "BOOTPROTO=none" >> /etc/sysconfig/network-scripts/ifcfg-bond0
		echo "ONBOOT=yes" >> /etc/sysconfig/network-scripts/ifcfg-bond0
		echo "NETMASK=${netmask}" >> /etc/sysconfig/network-scripts/ifcfg-bond0
		echo "IPADDR=${ip}" >> /etc/sysconfig/network-scripts/ifcfg-bond0
		echo "GATEWAY=${gw}" >> /etc/sysconfig/network-scripts/ifcfg-bond0
		echo "TYPE=Ethernet" >> /etc/sysconfig/network-scripts/ifcfg-bond0		

        echo "ADDRESS=${ip}" >> /root/pack/network
        echo "NETMASK=${netmask}" >> /root/pack/network
        echo "GATEWAY=${gw}" >> /root/pack/network
}

#==========================================================================
function setup_eth_ip()
{
	clear
	eth=
	i=0

	while [ 1 ]; do
	i=0
        echo "��һ��֤ȯӪҵ�������ϵͳӦ�ý������:"
	echo 
        echo -e "\e[49;32;1m��ѡ��Ҫ�趨IP������:\e[0m"
        while [ ${i} -lt 4 ];
        do
            if [ -d /sys/class/net/eth${i} ]; then
				eth="eth${i}"
                echo "	${i}:eth${i}"
            fi
            ((i=${i}+1))
	done
	echo -e "����ѡ���,�밴\e[49;33;1m[Enter]\e[0m����"
	echo -e "ֱ�Ӱ�\e[49;33;1m[Enter]\e[0m���������"

	read in
	if [ -z ${in} ]; then
		break;
	fi
	
	if [ ! -d /sys/class/net/eth${in} ]; then
        	clear
        	echo "���벻��ȷ,����������"
			echo
        	continue
	fi

		ip=
		netmask=
		gw=
		declare -i count=0

		while [ 1 ]; do
			count+=1
			if=
			netmask=
			gw=

			while [ 1 ]; do
				echo
				echo "����IP��ַ:"
				read ip
				if ! /root/pack/testip ${ip}; then
					echo "���Ϸ���ip,����������"
					continue
				fi
				break
			done	

			while [ 1 ]; do
				echo
				echo "������������:"
				read netmask
				if ! /root/pack/testip ${netmask}; then
					echo "���Ϸ�����������,����������"
					continue
				fi
				break
			done

			while [ 1 ]; do
				echo
				echo "����Ĭ������:"
				read gw
				if ! /root/pack/testip ${gw}; then
					echo "���Ϸ������ص�ַ,����������"
					continue
				fi
				break
			done

			if ! /sbin/ifconfig eth${in} ${ip} netmask ${netmask} > /dev/null 2>&1; then
				if [ ${count} -gt 5 ]; then
					while [ 1 ];
					do
						echo "����ʧ��,�����¿�������������, ��\e[49;33;1m[Enter]\e[0m������"
						read -n1 key
						if [ -z "${key}" ]; then
							reboot
						fi
					done	
				fi
				clear
				echo "����ʧ��,�������������"
				echo
				continue
			fi
			break
		done

		echo "DEVICE=eth${in}" > /etc/sysconfig/network-scripts/ifcfg-eth${in}
		echo "BOOTPROTO=none" >> /etc/sysconfig/network-scripts/ifcfg-eth${in}
		echo "ONBOOT=yes" >> /etc/sysconfig/network-scripts/ifcfg-eth${in}
		echo "NETMASK=${netmask}" >> /etc/sysconfig/network-scripts/ifcfg-eth${in}
		echo "IPADDR=${ip}" >> /etc/sysconfig/network-scripts/ifcfg-eth${in}
		echo "GATEWAY=${gw}" >> /etc/sysconfig/network-scripts/ifcfg-eth${in}
		echo "TYPE=Ethernet" >> /etc/sysconfig/network-scripts/ifcfg-eth${in}

		echo "ADDRESS=${ip}" >> /root/pack/network
		echo "NETMASK=${netmask}" >> /root/pack/network
		echo "GATEWAY=${gw}" >> /root/pack/network
	clear
	done
}

#==========================================================================
function Setup_main_ethip()
{
	clear

	if [ ! -d /root/pack ];then
		echo "����: Setup_main_ethip /root/pack Ŀ¼������" >> /var/log/rich_install.log
		echo "����: Setup_main_ethip /root/pack Ŀ¼������" 
		exit 
	fi

	if [ ! -x  /root/pack/testip ];then
		echo "����: Setup_main_ethip /root/pack/testip ������" >> /var/log/rich_install.log
		echo "����: Setup_main_ethip /root/pack/testip ������" 
		exit 
	fi


	master_ip=
	master_name=
	if [ "${ROLE}" == "sub" ]; then
		while [ 1 ]; 
		do
			echo "��һ��֤ȯӪҵ�������ϵͳӦ�ý������:"
        		echo
			echo -e "\e[49;32;1m���������õ�����������IP:\e[0m"
			read master_ip
			if ! /root/pack/testip ${master_ip} ; then
				clear
				echo "���Ϸ���ip��ַ,����������"
				echo
				continue
			fi
			break
		done

#		clear
#		while [ 1 ]; 
#		do
#			echo "���������õ�����������:"
#			read master_name
#			if ! /root/pack/testname ${master_name}; then
#				clear
#				echo "���Ϸ��ķ�������,��������ֻ�������ֺ���ĸ����,�ҳ���6���ַ�,����������"
#				continue
#			fi
#			break
#		done

		clear
		target=$(echo ${master_name} | tr a-z A-Z)
		cat /root/pack/chkipx.sh | sed -e "s/XXX/${target}/g" > /usr/bin/chkipx.sh
		chmod +x /usr/bin/chkipx.sh
	fi
}

#==========================================================================
#�޸� root ��. 
function Setup_new_passw_sys()
{
	clear
	if [ ! -x  /root/pack/testpass ];then
		echo "����: Setup_hostname  /root/pack/testpass ������" >> /var/log/rich_install.log
		echo "����: Setup_hostname  /root/pack/testpass ������" 
		exit 
	fi

	pass=
	echo "��һ��֤ȯӪҵ�������ϵͳӦ�ý������:"
	echo
	echo -e "\e[49;32;1m��������:\e[0m"
	echo "��׼����ֽ��,��¼�����õ�����"
	echo "���õ������������ϵͳroot�û����롢samba�û����롢nwserv�����û�����"
	echo "ע�⣺���볤��Ҫ��С��12λ, ������#��."
	while [ 1 ]; do
		echo "���������룺"
		read pass
		if [ ${#pass} -lt 12 ]; then
			echo
			echo "����������12λ,����������"
			continue
		else
			if ! /root/pack/testpass $pass ;then
			echo "���뺬��#��,����������"
				continue;
			fi
			break
		fi
	done

	echo $pass > /tmp/passwd_all
	sed 's/\&/\\\&/g'  /tmp/passwd_all   -i   #�� & ��� \& ������� sed �����ʱ�� �������巢��.
	echo "�����������" $pass >> /var/log/rich_install.log
	#/root/pack/busybox passwd root ${pass} > /dev/null 2>&1
	echo $pass |passwd root --stdin > /dev/null 2>&1



	clear
}

########################################################################
#samba  nwserv����, Ҫ��pack.zip ��ѹ֮��ſ�����.
function Setup_new_passw_app()
{
	if [ ! -d /root/pack ];then
		echo "����: Setup_new_passw_app /root/pack Ŀ¼������" >> /var/log/rich_install.log
		exit 
	fi
	pass=$(cat /tmp/passwd_all)
	if [ -z $pass ];then
		echo " ����:  setup_new_passw_app ����Ϊ��" >> /var/log/rich_install.log
	fi

	#==========================================================================
	#nwserv ����.
	#chmod +x /root/pack/nwmodify
	#/root/pack/nwmodify /etc/nwserv.conf ${pass}
	#�޸�nwserv ����. 
	sed -i "/^\s*12\s/{s/.*/12  SUPERVISOR  root    ${pass}/g}" /etc/nwserv.conf

	#==========================================================================
	#samba ������޸�.
	echo $pass > /tmp/tmp
	echo $pass >> /tmp/tmp
	cat /tmp/tmp | smbpasswd -s  -a root


}



#==========================================================================
#rc.local ��һЩ����. 
#�����һЩ������, ��ȥ��.
function Setup_rc_init()
{
	# cp /etc/rc.d/rc.local /root/ -Rf
	# echo "if [ -x /root/pack/nw.sh ]; then" >> /etc/rc.d/rc.local
	# echo "	/root/pack/nw.sh"				>> /etc/rc.d/rc.local
	# echo "	mv /root/pack/nw.sh /root/pack/trash/ -f"	>> /etc/rc.d/rc.local
	# echo "fi"								>> /etc/rc.d/rc.local


	# echo "if [ -x /root/pack/ex.sh ]; then"	>> /etc/rc.d/rc.local
	# echo "	/root/pack/ex.sh ${pw1}"			>> /etc/rc.d/rc.local
	# echo "	mv /root/pack/ex.sh /root/pack/trash/ -f"	>> /etc/rc.d/rc.local
	# echo "	cp /root/pack/rc.local /etc/rc.d/rc.local -Rfv"	>> /etc/rc.d/rc.local
	# echo "fi" 							>> /etc/rc.d/rc.local
	# echo "rm /root/pack* /root/disk* /root/start -Rf" >> /etc/rc.d/rc.local
	# echo "mv /root/rc.local /etc/rc.d -vf" >> /etc/rc.d/rc.local

	clear
}
#==========================================================================
#����������.
function  Setup_hostname()
{
	if [ ! -d /root/pack ];then
		echo "����: Setup_hostname /root/pack Ŀ¼������" >> /var/log/rich_install.log
		echo "����: Setup_hostname /root/pack Ŀ¼������" 
		exit 
	fi

	if [ ! -x  /root/pack/testname ];then
		echo "����: Setup_hostname  /root/pack/testname ������" >> /var/log/rich_install.log
		echo "����: Setup_hostname  /root/pack/testname ������" 
		exit 
	fi

	name=
	clear
	
	
	while [ 1 ]; 
	do
		echo "��һ��֤ȯӪҵ�������ϵͳӦ�ý������:"
        echo
        echo -e "\e[49;32;1m���ü��������:\e[0m"

		echo "����������:"
		read name	
		if ! /root/pack/testname ${name}; then
			echo
			echo "���ǺϷ��ļ��������!"
			echo "��ȷ�������������ĸ�����ֺ�-��ɣ��Ҳ��ܵ������������,���Ȳ��ܳ���16���ַ�"
			echo
			continue
		else
			break
		fi
	done

	if [   ! -f  /etc/nwserv.conf ];then
		echo "����: Setup_hostname /etc/nwserv.conf  �ļ�������" >> /var/log/rich_install.log
	fi

	sed -i "/^\s*2\s/ {s/^.*$/2    ${name}/}" /etc/nwserv.conf
	#fixme ע�� " ' ������ ^\s*2\s   д��  ^\s*2\s+   ��û��ͨ����. 
	#sed -i '/^\s*2\s/ {s/^.*$/2    ${name}/}' /etc/nwserv.conf
	#cat /etc/sysconfig/network | sed -e '/HOSTNAME/d' > /etc/sysconfig/network 
	sed  '/HOSTNAME/d' -i /etc/sysconfig/network 
	echo "HOSTNAME=${name}" >> /etc/sysconfig/network
}

#==========================================================================
#bsd�������ļ��Ĵ���. 
function Setup_richtech_bsd()
{

	if [ ! -d /root/pack ];then
		echo "����: Setup_richtech_bsd /root/pack Ŀ¼������" >> /var/log/rich_install.log
		exit 
	fi

	echo "########################################" >> /var/log/rich_install.log 
	echo "BSD ���� ��ʼ " >> /var/log/rich_install.log
	echo "����ģʽ�� " $ROLE >> /var/log/rich_install.log

	if [ "${ROLE}" == "sub" ]; then
		sed -e "s/MasterIp=/MasterIp=${master_ip}/g" /root/pack/${ROLE}/option.ini > /usr/share/rtiosrv/option.ini
		echo "master_ip is " $master_ip >> /var/log/rich_install.log
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
	echo "Netmask=${netmask}" 	>> /usr/share/rtiosrv/template.ini


	#sed -i  "s/BootServer.*/BootServer=$ip/g" /usr/share/rtiosrv/template.ini
	sed -i "/BootServer/{s/.*/BootServer=$ip/g}" /usr/share/rtiosrv/template.ini


	echo "template.ini  BootServer �滻�� $ip " >> /var/log/rich_install.log
	grep BootServer  /usr/share/rtiosrv/template.ini >>  /var/log/rich_install.log




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

	mkdir /vld/sys/bat
	mkdir /vld/sys/pxelinux
	cp -a -r /root/pack/sys/bat/*  /vld/sys/bat/
	cp -a -r /root/pack/sys/pxelinux/*  /vld/sys/pxelinux/

	if [ $frame_type == "802.2" ];then
		echo "��ǰ֡ Ϊ 802.2 " >>  /var/log/rich_install.log
		cp /vld/sys/pxelinux/dzh3/dzh3_802_2.img /vld/sys/pxelinux/dzh3/dzh3.img  >>/var/log/rich_install.log

		cp /vld/sys/pxelinux/dzhplus/dzhplus_802_2.img /vld/sys/pxelinux/dzhplus/dzhplus.img >>/var/log/rich_install.log

		cp /vld/sys/pxelinux/lon/lon_802_2.img  /vld/sys/pxelinux/lon/lon.img >>/var/log/rich_install.log

	else
		echo "��ǰ֡ Ϊ 802.3 " >>  /var/log/rich_install.log
		cp /vld/sys/pxelinux/dzh3/dzh3_802_3.img /vld/sys/pxelinux/dzh3/dzh3.img  >>/var/log/rich_install.log

		cp /vld/sys/pxelinux/dzhplus/dzhplus_802_3.img /vld/sys/pxelinux/dzhplus/dzhplus.img >>/var/log/rich_install.log

		cp /vld/sys/pxelinux/lon/lon_802_3.img  /vld/sys/pxelinux/lon/lon.img >>/var/log/rich_install.log

	fi
}
#��ѡ�ɷ�����������.
function Stock_sync()
{
	if [ ! -f /usr/share/rtiosrv/server/Server ];then
		echo "stock_sync û�� Server �ļ�" >> 	/var/log/rich_install.log
	fi
	if [ ! -f /usr/share/rtiosrv/server/ServerConfig ];then
		echo "stock_sync û�� ServerConfig �ļ�" >> 	/var/log/rich_install.log
	fi
	#fixme��ִ��Ȩ�� chmod +x  ��������� gedit �򿪶����� ,chmod 777 �Ϳ�����.
	chmod 777 /usr/share/rtiosrv/server/Server*
	chmod 777 -R /usr/share/rtiosrv/smbshare

	yes |cp /usr/share/rtiosrv/server/StoreServer2 /etc/init.d/
	chmod +x /etc/init.d/StoreServer2

	if [ ! -d  /vld/users ];then
		mkdir  /vld/users
	fi

	chkconfig --add  StoreServer2  
	chkconfig --level 35 StoreServer2  on  
}

#==========================================================================
#�����ϸ�����700m �Ķ�����ѹ, ���ڿ�ʼ������ ����. 
function Diskless_image_extract()
{
	clear
	echo "��һ��֤ȯӪҵ�������ϵͳӦ�ý������:"
	echo
	#echo "���߲�����ѹ�����ļ�,������Ҫ5��10����..."
	#tar -xzf /root/disk.tgz -C /vld/disks/
	chmod -R 755 /vld 
}

#==========================================================================
#��չ���. 
function Cleanup()
{
	echo "���������,ϵͳ������������"
	sed -i 's/id:3:initdefault/id:5:initdefault/g' /etc/inittab
	cd /
	echo "ɾ�� /start �ļ�";
	rm /start -Rf
	#mv /boot/grub/grub.conf /boot/grub/grub.conf.bakme
	#mv /boot/grub/grub.conf.bak /boot/grub/grub.conf
	echo "ɾ�� ������ʱ�ļ�"
	rm -Rf  /root/myunzip /root/disk.tgz /root/start  /root/pack.zip
	#ɾ������ļ�. 
	rm -f /.richtech

	#zhcon Ĭ�ϲ���������.
	#1.  ������ zhcon.
	sed -i  '/^zhcon/{s/.*/touch . /g}' /root/.bashrc
	#2. ���縸���� �� gnome-session  kconsole xterm ��ʱ������ zhcon.
	#��Ӧ�� ks.cfg �Ѿ������޸���.

	#���ն� tty1 ��������mingetty, 
	sed -i  '/^1:2345:respawn/{s/.*/1:2345:respawn:\/sbin\/mingetty tty1/g}' /etc/inittab -i
	#tty �л��� 
	#sed -i  '/^1:2345:respawn/{s/.*/1:2345:respawn:\/usr\/bin\/zhcon_console \/bin\/start_gb2312.sh /g}' /etc/inittab -i
	echo "sleep 2��"
	sleep 2
	reboot -f
	/bin/bash
	/bin/bash
}

#��ȡ /root/pack/network ����������.
function Setup_network_cfg_file()
{
	[ -r /root/pack/network ] || exit 1
	eval $(grep "ADDRESS=" /root/pack/network)
	eval $(grep "NETMASK=" /root/pack/network)
	eval $(grep "GATEWAY=" /root/pack/network)

	IFACE=
	CFG_FILE=


	if [ -d /sys/class/net/eth1 ]; then
		IFACE=eth1
		sed -i 's/dhcp/static/'	/etc/sysconfig/network-scripts/ifcfg-eth0
	else
		IFACE=eth0
	fi

	CFG_FILE=/etc/sysconfig/network-scripts/ifcfg-${IFACE}

	if grep "BOOTPROTO\s*=\s*none"  $CFG_FILE  ;then 
		echo  $CFG_FILE "�Ѿ� �� bond0 �� ������ȥ���� ip ��"  >> /var/log/rich_install.log
	else
		sed -i '/IPADDR=/d;/NETMASK=/d;/GATEWAY=/d;/ONBOOT=/d;/^$/d' ${CFG_FILE}

		echo "ONBOOT=yes"			>> ${CFG_FILE}
		#echo "BOOTPROTO=static"		>> ${CFG_FILE}
		echo "IPADDR=${ADDRESS}"	>> ${CFG_FILE}
		echo "NETMASK=${NETMASK}"	>> ${CFG_FILE}
		echo "GATEWAY=${GATEWAY}"	>> ${CFG_FILE}

		for i in 2 3 4 5 6; do
			if [ -r /etc/sysconfig/network-scripts/ifcfg-eth${i} ]; then
				sed -i 's/dhcp/static/' /etc/sysconfig/network-scripts/ifcfg-eth${i}
			fi
		done
	fi

	sleep 1

	# if [ -x /usr/bin/chkipx.sh ]; then
	# 	chkconfig --level 35 bindif on
	# else
	# 	chkconfig --level 35 nwserv on
	# fi

}

#==========================================================================
#grep function start_gb2312.sh > /tmp/tmp
#�ٰ�  /tmp/tmp ������ճ��������. 
#mainloop
#get_hwaddr()

#��������, �����bsd��˵.
Set_main_or_sub_server
Setup_new_passw_sys
Extract_pack_zip_and_copy_install
Setup_new_passw_app
Check_netcard
Setup_system_time
Setup_ipx_protocol_netaddr
Set_bond_or_ip_mode
Chkconfig_service
Setup_main_ethip
Setup_rc_init
Setup_hostname
Setup_richtech_bsd
Diskless_image_extract
Stock_sync
Setup_network_cfg_file
Cleanup
