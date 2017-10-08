#!/usr/bin/perl
my $pattern=shift;

usage($pattern);

gen_etc_qemu_ifup();
gen_etc_qemu_ifdown();

gen_ifcfg_cfg_master();
gen_ifcfg_cfg_slave();


system("chmod +x /etc/qemu-if*");




########################################################################
#设置主网卡
sub gen_ifcfg_cfg_master()
{
	print <<EOF
#========================================================================== to file ifcfg-br0
TYPE=Bridge
ONBOOT=yes
DELAY=0
BOOTPROTO=none
IPADDR=192.168.1.100
NETMASK=255.255.255.0
GATEWAY=192.168.1.1
DNS=8.8.8.8
NM_CONTROLLED=no
IPV6INIT=no
USERCTL=no
PREFIX=24
EOF
;
}

#==========================================================================
#设置辅助网卡的参数.
sub   gen_ifcfg_cfg_slave()
{
	print <<EOF
#==========================================================================  ifcfg-p7p1
ONBOOT=yes
BRIDGE=br0
NM_CONTROLLED=no

BOOTPROTO=none
TYPE=Ethernet
HWADDR=00:18:8b:80:0c:82
IPADDR=0.0.0.0
IPV6INIT=no
USERCTL=no
EOF
;
}

sub usage()
{
	print <<EOF
#==========================================================================
# 桥接方式的 建立.
brctl addbr  br0  		#
brctl addif  br0 eth1 	# 把自己正常存在的网卡 加入 到 br0 上面去.
dhclient br0 			#

#--------------------------------------------------------------------------
EOF
;


}

sub  gen_etc_qemu_ifup()
{
	if( -f "/etc/qemu-ifup")
	{
		print ("#/etc/qemu-ifup exists , will not create it  \n");
		return ;
	}
	open(FILE, ">/etc/qemu-ifup") or die("open /etc/qemu-ifup error \n");
	print FILE <<EOF
#!/bin/sh
set -x
switch=\$(/sbin/ip route list | awk '/^default / { print \$5 }')
echo \$1
tunctl -t \$1  #tap 设备的添加.
/sbin/ifconfig \$1 0.0.0.0 up
/usr/sbin/brctl addif \${switch} \$1
#ovs-vsctl add-port br2 \$1

EOF
;
	close(FILE);
	print ("#create  /etc/qemu-ifup OK \n");

}

sub gen_etc_qemu_ifdown()
{

	if( -f "/etc/qemu-ifdown")
	{
		print ("#/etc/qemu-ifdown exists , will not create it  \n");
		return ;
	}
	open(FILE, ">/etc/qemu-ifdown") or die("open /etc/qemu-ifdown error \n");
	print FILE <<EOF

#!/bin/sh


switch=\$(/sbin/ip route list | awk '/^default / { print \$5 }')
/usr/sbin/brctl delif \$switch \$1
/sbin/ifconfig \$1 0.0.0.0 down
#ovs-vsctl del-port br2 \$1

EOF
;
	close(FILE);
	print ("#create  /etc/qemu-ifdown OK \n");

}
__DATA__


__DATA__
########################################################################
#2012_03_01   星期四   mdf by greshem , harry 
# 建立下面的文件 fedora13 默认是存在的, ubutun 可能默认存在.
cat > /etc/qemu-ifup <<EOF
#!/bin/sh
switch=\$(/sbin/ip route list | awk '/^default / { print \$5 }')
/sbin/ifconfig \$1 0.0.0.0 up
/usr/sbin/brctl addif \${switch} \$1
EOF

########################################################################

cat > /etc/qemu-ifdown <<EOF
#!/bin/sh
# NOTE: This script is intended to run in conjunction with qemu-ifup
#       which uses the same logic to find your bridge/switch
switch=\$(/sbin/ip route list | awk '/^default / { print \$5 }')
/usr/sbin/brctl delif \$switch \$1
/sbin/ifconfig \$1 0.0.0.0 down
EOF

set -x
echo $1
tunctl  $1
/usr/sbin/brctl addif br0 $1
ifconfig $1 up 

