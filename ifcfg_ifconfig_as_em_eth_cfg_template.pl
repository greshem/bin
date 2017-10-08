#!/usr/bin/perl
foreach (<DATA>)
{
	print $_;
}
__DATA__

centos7 modify  /boot/grub2/grub.cfg
linux16 /vmlinuz-3.10.0-229.el7.x86_64  line append :   net.ifnames=0 biosdevname=0   biosdevname=0 
net.ifnames=0 biosdevname=0   biosdevname=0

########################################################################
#redhat dhcp 的方式. as6 之后的命令的方式.
DEVICE="em1"
HWADDR="DC:0E:A1:1C:8D:A1"
BOOTPROTO="dhcp"
ONBOOT="no"
NM_CONTROLLED="yes"

########################################################################
#redhat static 的方式.
DEVICE=eth0
ONBOOT=yes
HWADDR="DC:0E:A1:1C:8D:A1"
BOOTPROTO=static
IPADDR=192.168.1.1
NETMASK=255.255.255.0
GATEWAY=192.168.1.254
DNS=8.8.8.8
NM_CONTROLLED="no"

########################################################################
#ubuntu 
cat /etc/network/interfaces  <<EOF
auto lo
iface lo inet loopback

auto eth4
iface  eth4 inet manual
address 172.30.51.10
netmask 2555.255.255.0
gateway 172.30.51.1
EOF

########################################################################
#ubuntu 的桥的设置, 
cat >>  /etc/network/interfaces  <<EOF
auto br1
iface br1 inet static
address 172.30.51.100
netmask 255.255.255.0
gateway 172.30.51.1
bridge_ports eth0
bridge_stp yes
bridge_fd 0
bridge_maxwait 0
EOF

                               

########################################################################
#suse /etc/sysconfig/network/ifcfg-eth0
IPADDR=172.16.10.98
NETMASK=255.255.255.0
GATEWAY=172.16.10.1
NETWORK=172.16.10.0
BROADCAST=172.16.10.255
#IPADDR_2=127.0.0.2/8
#STARTMODE=onboot
#USERCONTROL=no
#FIREWALL=no
#

########################################################################
#redhat   bridge  setup  
#========================================================================== to file ifcfg-br0
DEVICE=br0
TYPE=Bridge
ONBOOT=yes
DELAY=0
BOOTPROTO=static
IPADDR=172.16.10.65
NETMASK=255.255.255.0
GATEWAY=172.16.10.1
DNS=172.16.1.251

#==========================================================================  ifcfg-p7p1

DEVICE=p7p1
ONBOOT=yes
BRIDGE=br0


########################################################################
EOF

