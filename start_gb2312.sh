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
#主备 对 rtiosrv bsd 才有意义 
function  Set_main_or_sub_server()
{
	clear
	ROLE=

	while [ 1 ]; do
		echo "新一代证券营业部多操作系统应用解决方案:"
		echo 
		echo -e "\e[49;32;1m请选择安装:\e[0m"
		echo "	1:安装主服务器"
		echo "	2:安装备服务器"
		echo -e "请输入\e[49;31;1m[1]\e[0m或者\e[49;31;1m[2]\e[0m做出选择后,按\e[49;33;1m[Enter]\e[0m继续"
		read ch
		if [ "${ch}" != 1 ] && [ "${ch}" != 2 ]; then
			clear
			echo "输入不正确,请重新输入"
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
#解压zip 包并 拷贝安装 里面必要的东西. 
function Extract_pack_zip_and_copy_install()
{
	#tar -zxf /root/pack.tgz -C /root/
	#unzip -P RICHTECH /root/pack.zip -d /root/ > /dev/null

	if [ ! -f  /root/pack.zip ];then
		echo  "pack.zip 不存在错误"
		echo  "pack.zip 不存在错误" >> /var/log/rich_install.log
		exit 
	fi
	if [ ! -d /root/pack ];then
		unzip -P http://www.richtech.net.cn.2010 /root/pack.zip -d /root/ > /dev/null
		#本地解压, 便于调试验证
		#unzip -P http://www.richtech.net.cn.2010 ./pack.zip -d . > /dev/null 
	fi
	########################################################################
	#	myunzip用上面的 unzip -P 来代替了, 把 unzip 的动作放在 c语言里确实有点费解. 
	# if ! /root/myunzip; then
	# 	clear
	# 	echo "解压出现错误"
	# 	#/bin/bash
	# else
	# 	echo "myunzip 不存在\n";
	# fi

	########################################################################
	#f13 下 testname 不能运行, elf的. 
	if grep Goddard /etc/issue;then
		cp /bin/check_ip.pl  /root/pack/testip
		cp /bin/check_node.pl /root/pack/testnode
		cp /bin/check_name.pl /root/pack/testname
	fi

	if [ ! -d /root/pack ];then
		echo "解压失败,  没有 生成 pack 目录, ks.cfg 阶段没有把 isolinux.cfg/pack.zip 拷贝过来";
		echo "或者zip 损坏"
		echo "或者zip 被删除"
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
	#smb 添加.
	cp /root/pack/smb.conf /etc/samba/smb.conf -Rf
	#--------------------------------------------------------------------------

	rm /etc/selinux/config -Rf
	cp /root/pack/selinux_config /etc/selinux/config  -Rf
	rm /etc/sysconfig/iptables -Rf
	cp /root/pack/iptables /etc/sysconfig/ -Rf
	rm /etc/sysconfig/system-config-securitylevel -Rf
	cp /root/pack/system-config-securitylevel /etc/sysconfig/ -Rf

	#--------------------------------------------------------------------------
	#snmpd 添加.
	rpm -ivh --force  --nodeps  /root/pack/snmp/lm_sensors-2.10.7-9.el5.i386.rpm 
	rpm -ivh --force  --nodeps  /root/pack/snmp/net-snmp-5.3.2.2-9.el5.i386.rpm 
	cp /root/pack/snmp/snmpd.conf   /etc/snmp/ -Rf 
	chkconfig --level 2345 snmpd on
	service snmpd start
	#--------------------------------------------------------------------------
	gconftool-2 -s /apps/gnome-screensaver/idle_activation_enabled --type bool false
	gconftool-2 -s /apps/gnome-power-manager/ac_sleep_display --type int 0

	#--------------------------------------------------------------------------
	#新添加的rtiosrv 目录.
	if [ ! -d /usr/share/rtiosrv ];then
		mkdir /usr/share/rtiosrv
	fi	
	yes|cp -a -r -f  /root/pack/rtiosrv/* /usr/share/rtiosrv/	
	#--------------------------------------------------------------------------


	#nw_manager 模拟器管理界面的东西.
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
	#dell 驱动安装, 安装中会出现很多的错误 还是放在这里比较好.
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
#看有没有网卡.
#最多支持四块网卡.
function Check_netcard()
{
	clear
	if [  -d /sys/class/net/eth0 -o  -d /sys/class/net/eth1 -o  -d /sys/class/net/eth2   -o -d /sys/class/net/eth3 ]; then
		echo "网卡检测ok " >> /var/log/rich_install.log
	else
		clear
		echo "没有发现网卡eth0 "  >> /var/log/rich_install.log
		echo "没有发现网卡,进入调试模式"
		/bin/bash
	fi

	clear
	#echo  "新一代证券营业部多操作系统应用解决方案:"	
	#if [ "${ROLE}" == "master" ]; then
	#	echo " 主服务器"
	#else
	#	echo " 副服务器"
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
#设置系统时间.
function Setup_system_time()
{
	clear
	date_num=
	time_num=

	while [ 1 ]; 
	do
		echo  "新一代证券营业部多操作系统应用解决方案:"
		echo
		echo -e "\e[49;32;1m时钟配置:\e[0m"
		echo "安装程序检测到系统时间为:" $(date);
		echo -e "请按\e[49;33;1m[Enter]\e[0m跳过时钟配置选项"
		echo -e "否则请输入新日期,格式为\e[49;37;1m[2011-01-01]\e[0m"
		read date_num
	
		if [ ! -z "${date_num}" ]; then
			check_date
			if [ ${date_count} -ne $((${#date_num}+1)) ]; then
				clear
				echo "输入不正确,请重新输入"
				echo
				continue
			fi	
			date -s "${date_num}" > /dev/null 2>&1
			if [ $(echo $?) -ne 0 ] ; then
				clear 
				echo "输入不正确,请重新输入"
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
			echo -e "请输入时间,格式为\e[49;37;1m[12:00:00]\e[0m"
			read time_num

			if [ ! -z "${time_num}" ]; then				
				check_time
				if [ ${time_count} -ne $((${#time_num}+1)) ]; then
               				echo
		                 	echo "输入不正确,请重新输入"
                                	continue
                        	fi
				date -s "${time_num}" > /dev/null 2>&1
            			if [ $(echo $?) -ne 0 ]; then
					echo
                			echo "输入不正确,请重新输入"
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
#设置ipx 协议里面的一些地址. 
function Setup_ipx_protocol_netaddr()
{

	if [ ! -d /root/pack ];then
		echo "错误: Setup_ipx_protocol_netaddr /root/pack 目录不存在" 
		echo "错误: Setup_ipx_protocol_netaddr /root/pack 目录不存在" >> /var/log/rich_install.log
		exit 
	fi

	if [ ! -x /root/pack/testnode ];then
		echo "错误: Setup_ipx_protocol_netaddr /root/pack/testnode  程序不存在." >> /var/log/rich_install.log
		echo "错误: Setup_ipx_protocol_netaddr /root/pack/testnode  程序不存在." 
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
		echo "新一代证券营业部多操作系统应用解决方案:"
		echo
		echo -e "\e[49;32;1m内部网络号配置:\e[0m"
		echo -e "安装程序将分配\e[49;34;1m[${hex_array}]\e[0m作为内部网络号,按\e[49;33;1m[Enter]\e[0m完成配置"

		echo "或者自定义内部网络号,请输入(16进制8个字符):"
		read int_num	

		if [ -z ${int_num} ]; then
			int_num=${hex_array}
		fi

		if ! /root/pack/testnode ${int_num}; then
			clear
			echo "不合法的内部网络号,可接受的字符是0-9, A-F"
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
		echo "错误: Setup_ipx_protocol_netaddr /root/pack 目录不存在" 
		echo "错误: Setup_ipx_protocol_netaddr /root/pack 目录不存在" >> /var/log/rich_install.log
		exit 
	fi

	if [ ! -x /root/pack/testip ];then
		echo "错误: Setup_ipx_protocol_netaddr /root/pack/testip  程序不存在." >> /var/log/rich_install.log
		echo "错误: Setup_ipx_protocol_netaddr /root/pack/testip  程序不存在." 
		exit 
	fi

	clear
	kind=

	while [ 1 ]; do
    		echo "新一代证券营业部多操作系统应用解决方案:"
		echo
		echo -e "\e[49;32;1m网卡配置，\e[0m请选择:"
		echo "  1:多网卡绑定模式(主备模式)"
		echo "  2:多网卡多IP模式"
		echo -e "请输入\e[49;31;1m[1]\e[0m或者\e[49;31;1m[2]\e[0m做出选择后,按\e[49;33;1m[Enter]\e[0m继续"
        read kind
        if [ "${kind}" != 1 ] && [ "${kind}" != 2 ]; then
        	clear
        	echo "输入不正确，请重新输入"
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
	echo "新一代证券营业部多操作系统应用解决方案:"
        echo
        echo -e "\e[49;32;1m配置IPX协议\e[0m"
        echo "请选择绑定IPX协议的网卡:"
	while [ ${i} -lt 4 ];
    	do
        	if [ -d /sys/class/net/eth${i} ]; then
			echo "	${i}:eth${i}"
		fi
		((i=${i}+1))
    	done
	echo -e "做出选择后,请按\e[49;33;1m[Enter]\e[0m继续"
	
	read in
	if [ ! -d /sys/class/net/eth${in}  ]; then
		clear
        	echo "输入不正确,请重新输入"
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
	#fixme 双 网卡 bond 
	#先设置  bond -  netcard  -> bond -> ipx -> tcp
	# 
	#

	while [ 1 ]; do
		echo "新一代证券营业部多操作系统应用解决方案:"
		echo
		echo -e "\e[49;32;1m配置网络号:\e[0m"
		echo -e "安装程序将配置\e[49;34;1m[$(date +%Y%m%d)]\e[0m作为网络号,按\e[49;33;1m[Enter]\e[0m直接完成配置"
		echo "或者自定义网络号,请输入(16进制8个字符):"
		read net_num

		if [ -z ${net_num} ]; then
			net_num=$(date +%Y%m%d)
		fi

		if ! /root/pack/testnode ${net_num}; then
			clear
			echo "不合法的网络号,可接受的字符是0-9, A-F"
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
	#写入到配置文件里面去
	#HWADDR=$(get_hwaddr)
	#echo ${hwaddr:4}
	#内部网络号.
	#sed -i '/^\s*3\s+.*/ {s/^.*$/3	0x'${int_num}' 1/}' /etc/nwserv.conf
	sed -i '/^\s*3\s/ {s/^.*$/3\t0x'${int_num}' 1/}' /etc/nwserv.conf
	#网络号.
	if [ "${kind}" == "2" ]; then
		sed -i "/^\s*4\s/ {s/^.*$/4   0x${net_num}  eth${eth_type}  ${frame_type}  1/}" /etc/nwserv.conf
	fi
	if [ "${kind}" == "1" ]; then
		sed -i "/^\s*4\s/ {s/^.*$/4   0x${net_num}  bond0  ${frame_type}  1/}" /etc/nwserv.conf
	fi
}

#==========================================================================
#设置帧类型.
function setup_frame_type()
{
	frame_type=
	clear
	while [ 1 ]; 
	do
		echo "新一代证券营业部多操作系统应用解决方案:"
		echo
		echo -e "\e[49;32;1m配置帧类型:\e[0m"
		echo "	1: 802.2"
		echo "	2: 802.3"
		echo -e "请输入\e[49;31;1m[1]\e[0m或者\e[49;31;1m[2]\e[0m做出选择后,按\e[49;33;1m[Enter]\e[0m继续"
		read ch
		if [ "${ch}" != 1 ] && [ "${ch}" != 2 ]; then
			clear	
			echo "输入不正确,请重新输入"
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
#有些服务需要开启 有些一定要关闭. 
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
	
		echo "新一代证券营业部多操作系统应用解决方案:"
                echo
                echo -e "\e[49;32;1m服务器IP配置：\e[0m"

		while [ 1 ];
		do
			echo "请输入需要设定的IP地址:"		
			read ip                
			if ! /root/pack/testip ${ip}; then
				echo "不合法的IP,请重新输入"
				echo
				continue
			fi
		break
		done

		while [ 1 ]; 
		do
			echo "输入子网掩码:"                
			read netmask                
			if ! /root/pack/testip ${netmask}; then
				echo "不合法的子网掩码,请重新输入"
				echo 
				continue
			fi
		break
		done

		while [ 1 ]; 
		do
			echo "输入默认网关:"
			read gw
			if ! /root/pack/testip ${gw}; then
				echo "不合法的网关地址,请重新输入"
				echo
				continue
			fi
		break
		done

		########################################################################
		# 不让执行ifconfig 了.
		# if ! /sbin/ifconfig bond0 ${ip} netmask ${netmask} > /dev/null 2>&1; then
		# 	if [ ${count} -gt 5 ]; then
		# 		while [ 1 ];
		# 		do
		# 			echo -e "配置失败,请重新开机后再次进行配置, 按\e[49;33;1m[Enter]\e[0m重启服务器"
		# 			read -n1 key
		# 			if [  -z ${key} ]; then		
		# 					reboot
		# 			fi
		# 		done	
		# 	fi
		# 	clear
		# 	echo "配置失败,请检查后重新输入"
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
        echo "新一代证券营业部多操作系统应用解决方案:"
	echo 
        echo -e "\e[49;32;1m请选择要设定IP的网卡:\e[0m"
        while [ ${i} -lt 4 ];
        do
            if [ -d /sys/class/net/eth${i} ]; then
				eth="eth${i}"
                echo "	${i}:eth${i}"
            fi
            ((i=${i}+1))
	done
	echo -e "做出选择后,请按\e[49;33;1m[Enter]\e[0m继续"
	echo -e "直接按\e[49;33;1m[Enter]\e[0m键完成配置"

	read in
	if [ -z ${in} ]; then
		break;
	fi
	
	if [ ! -d /sys/class/net/eth${in} ]; then
        	clear
        	echo "输入不正确,请重新输入"
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
				echo "输入IP地址:"
				read ip
				if ! /root/pack/testip ${ip}; then
					echo "不合法的ip,请重新输入"
					continue
				fi
				break
			done	

			while [ 1 ]; do
				echo
				echo "输入子网掩码:"
				read netmask
				if ! /root/pack/testip ${netmask}; then
					echo "不合法的子网掩码,请重新输入"
					continue
				fi
				break
			done

			while [ 1 ]; do
				echo
				echo "输入默认网关:"
				read gw
				if ! /root/pack/testip ${gw}; then
					echo "不合法的网关地址,请重新输入"
					continue
				fi
				break
			done

			if ! /sbin/ifconfig eth${in} ${ip} netmask ${netmask} > /dev/null 2>&1; then
				if [ ${count} -gt 5 ]; then
					while [ 1 ];
					do
						echo "配置失败,请重新开机后重新配置, 按\e[49;33;1m[Enter]\e[0m键重启"
						read -n1 key
						if [ -z "${key}" ]; then
							reboot
						fi
					done	
				fi
				clear
				echo "配置失败,请检查后重新输入"
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
		echo "错误: Setup_main_ethip /root/pack 目录不存在" >> /var/log/rich_install.log
		echo "错误: Setup_main_ethip /root/pack 目录不存在" 
		exit 
	fi

	if [ ! -x  /root/pack/testip ];then
		echo "错误: Setup_main_ethip /root/pack/testip 不存在" >> /var/log/rich_install.log
		echo "错误: Setup_main_ethip /root/pack/testip 不存在" 
		exit 
	fi


	master_ip=
	master_name=
	if [ "${ROLE}" == "sub" ]; then
		while [ 1 ]; 
		do
			echo "新一代证券营业部多操作系统应用解决方案:"
        		echo
			echo -e "\e[49;32;1m输入已配置的主服务器的IP:\e[0m"
			read master_ip
			if ! /root/pack/testip ${master_ip} ; then
				clear
				echo "不合法的ip地址,请重新输入"
				echo
				continue
			fi
			break
		done

#		clear
#		while [ 1 ]; 
#		do
#			echo "输入已配置的主服务器名:"
#			read master_name
#			if ! /root/pack/testname ${master_name}; then
#				clear
#				echo "不合法的服务器名,服务器名只能由数字和字母构成,且长于6个字符,请重新输入"
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
#修改 root 码. 
function Setup_new_passw_sys()
{
	clear
	if [ ! -x  /root/pack/testpass ];then
		echo "错误: Setup_hostname  /root/pack/testpass 不存在" >> /var/log/rich_install.log
		echo "错误: Setup_hostname  /root/pack/testpass 不存在" 
		exit 
	fi

	pass=
	echo "新一代证券营业部多操作系统应用解决方案:"
	echo
	echo -e "\e[49;32;1m密码设置:\e[0m"
	echo "请准备好纸笔,记录您设置的密码"
	echo "设置的密码包含操作系统root用户密码、samba用户密码、nwserv超级用户密码"
	echo "注意：密码长度要不小于12位, 不包含#号."
	while [ 1 ]; do
		echo "输入新密码："
		read pass
		if [ ${#pass} -lt 12 ]; then
			echo
			echo "密码至少是12位,请重新输入"
			continue
		else
			if ! /root/pack/testpass $pass ;then
			echo "密码含有#号,请重新输入"
				continue;
			fi
			break
		fi
	done

	echo $pass > /tmp/passwd_all
	sed 's/\&/\\\&/g'  /tmp/passwd_all   -i   #把 & 变成 \& 否则最后到 sed 里面的时候 会有歧义发生.
	echo "输入的密码是" $pass >> /var/log/rich_install.log
	#/root/pack/busybox passwd root ${pass} > /dev/null 2>&1
	echo $pass |passwd root --stdin > /dev/null 2>&1



	clear
}

########################################################################
#samba  nwserv密码, 要在pack.zip 解压之后才可以做.
function Setup_new_passw_app()
{
	if [ ! -d /root/pack ];then
		echo "错误: Setup_new_passw_app /root/pack 目录不存在" >> /var/log/rich_install.log
		exit 
	fi
	pass=$(cat /tmp/passwd_all)
	if [ -z $pass ];then
		echo " 错误:  setup_new_passw_app 密码为空" >> /var/log/rich_install.log
	fi

	#==========================================================================
	#nwserv 密码.
	#chmod +x /root/pack/nwmodify
	#/root/pack/nwmodify /etc/nwserv.conf ${pass}
	#修改nwserv 密码. 
	sed -i "/^\s*12\s/{s/.*/12  SUPERVISOR  root    ${pass}/g}" /etc/nwserv.conf

	#==========================================================================
	#samba 密码的修改.
	echo $pass > /tmp/tmp
	echo $pass >> /tmp/tmp
	cat /tmp/tmp | smbpasswd -s  -a root


}



#==========================================================================
#rc.local 的一些处理. 
#这里的一些暗处理, 都去掉.
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
#设置主机名.
function  Setup_hostname()
{
	if [ ! -d /root/pack ];then
		echo "错误: Setup_hostname /root/pack 目录不存在" >> /var/log/rich_install.log
		echo "错误: Setup_hostname /root/pack 目录不存在" 
		exit 
	fi

	if [ ! -x  /root/pack/testname ];then
		echo "错误: Setup_hostname  /root/pack/testname 不存在" >> /var/log/rich_install.log
		echo "错误: Setup_hostname  /root/pack/testname 不存在" 
		exit 
	fi

	name=
	clear
	
	
	while [ 1 ]; 
	do
		echo "新一代证券营业部多操作系统应用解决方案:"
        echo
        echo -e "\e[49;32;1m配置计算机名称:\e[0m"

		echo "请输入名称:"
		read name	
		if ! /root/pack/testname ${name}; then
			echo
			echo "不是合法的计算机名称!"
			echo "正确计算机名称由字母、数字和-组成，且不能单独由数字组成,长度不能超过16个字符"
			echo
			continue
		else
			break
		fi
	done

	if [   ! -f  /etc/nwserv.conf ];then
		echo "错误: Setup_hostname /etc/nwserv.conf  文件不存在" >> /var/log/rich_install.log
	fi

	sed -i "/^\s*2\s/ {s/^.*$/2    ${name}/}" /etc/nwserv.conf
	#fixme 注意 " ' 的区别 ^\s*2\s   写成  ^\s*2\s+   就没法通过了. 
	#sed -i '/^\s*2\s/ {s/^.*$/2    ${name}/}' /etc/nwserv.conf
	#cat /etc/sysconfig/network | sed -e '/HOSTNAME/d' > /etc/sysconfig/network 
	sed  '/HOSTNAME/d' -i /etc/sysconfig/network 
	echo "HOSTNAME=${name}" >> /etc/sysconfig/network
}

#==========================================================================
#bsd的配置文件的处理. 
function Setup_richtech_bsd()
{

	if [ ! -d /root/pack ];then
		echo "错误: Setup_richtech_bsd /root/pack 目录不存在" >> /var/log/rich_install.log
		exit 
	fi

	echo "########################################" >> /var/log/rich_install.log 
	echo "BSD 配置 开始 " >> /var/log/rich_install.log
	echo "主备模式是 " $ROLE >> /var/log/rich_install.log

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


	echo "template.ini  BootServer 替换成 $ip " >> /var/log/rich_install.log
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
		echo "当前帧 为 802.2 " >>  /var/log/rich_install.log
		cp /vld/sys/pxelinux/dzh3/dzh3_802_2.img /vld/sys/pxelinux/dzh3/dzh3.img  >>/var/log/rich_install.log

		cp /vld/sys/pxelinux/dzhplus/dzhplus_802_2.img /vld/sys/pxelinux/dzhplus/dzhplus.img >>/var/log/rich_install.log

		cp /vld/sys/pxelinux/lon/lon_802_2.img  /vld/sys/pxelinux/lon/lon.img >>/var/log/rich_install.log

	else
		echo "当前帧 为 802.3 " >>  /var/log/rich_install.log
		cp /vld/sys/pxelinux/dzh3/dzh3_802_3.img /vld/sys/pxelinux/dzh3/dzh3.img  >>/var/log/rich_install.log

		cp /vld/sys/pxelinux/dzhplus/dzhplus_802_3.img /vld/sys/pxelinux/dzhplus/dzhplus.img >>/var/log/rich_install.log

		cp /vld/sys/pxelinux/lon/lon_802_3.img  /vld/sys/pxelinux/lon/lon.img >>/var/log/rich_install.log

	fi
}
#自选股服务器的问题.
function Stock_sync()
{
	if [ ! -f /usr/share/rtiosrv/server/Server ];then
		echo "stock_sync 没有 Server 文件" >> 	/var/log/rich_install.log
	fi
	if [ ! -f /usr/share/rtiosrv/server/ServerConfig ];then
		echo "stock_sync 没有 ServerConfig 文件" >> 	/var/log/rich_install.log
	fi
	#fixme可执行权限 chmod +x  点击还是用 gedit 打开二进制 ,chmod 777 就可以了.
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
#光盘上附带的700m 的东西解压, 现在开始被废弃 掉了. 
function Diskless_image_extract()
{
	clear
	echo "新一代证券营业部多操作系统应用解决方案:"
	echo
	#echo "第七步：解压镜像文件,可能需要5－10分钟..."
	#tar -xzf /root/disk.tgz -C /vld/disks/
	chmod -R 755 /vld 
}

#==========================================================================
#清空工作. 
function Cleanup()
{
	echo "配置已完成,系统正在重新启动"
	sed -i 's/id:3:initdefault/id:5:initdefault/g' /etc/inittab
	cd /
	echo "删除 /start 文件";
	rm /start -Rf
	#mv /boot/grub/grub.conf /boot/grub/grub.conf.bakme
	#mv /boot/grub/grub.conf.bak /boot/grub/grub.conf
	echo "删除 其他临时文件"
	rm -Rf  /root/myunzip /root/disk.tgz /root/start  /root/pack.zip
	#删除这个文件. 
	rm -f /.richtech

	#zhcon 默认不不让启动.
	#1.  不启动 zhcon.
	sed -i  '/^zhcon/{s/.*/touch . /g}' /root/.bashrc
	#2. 假如父进程 是 gnome-session  kconsole xterm 的时候不启动 zhcon.
	#对应的 ks.cfg 已经做了修改了.

	#把终端 tty1 重新启动mingetty, 
	sed -i  '/^1:2345:respawn/{s/.*/1:2345:respawn:\/sbin\/mingetty tty1/g}' /etc/inittab -i
	#tty 切换成 
	#sed -i  '/^1:2345:respawn/{s/.*/1:2345:respawn:\/usr\/bin\/zhcon_console \/bin\/start_gb2312.sh /g}' /etc/inittab -i
	echo "sleep 2秒"
	sleep 2
	reboot -f
	/bin/bash
	/bin/bash
}

#读取 /root/pack/network 再配置网络.
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
		echo  $CFG_FILE "已经 被 bond0 绑定 不用再去配置 ip 了"  >> /var/log/rich_install.log
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
#再把  /tmp/tmp 的内容粘贴到这里. 
#mainloop
#get_hwaddr()

#设置主备, 相对于bsd来说.
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
