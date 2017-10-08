#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__
#2012_03_09_18:03:48   ������   add by greshem
#����������� ����һ��Сʱ ���������  openvswitch ���÷�.
#==========================================================================
#ȥ��ϵͳĬ�ϵ���, ����Ҫ �����ǻ��openvswitch �� �Ż������ͻ��.
lsmod | grep bridge
rmmod bridge

#==========================================================================
#openvswitch �ں˱���, as5 as6 ����ɹ�  f13 f16 �����ʧ��, ����û��ʲôӰ��.
#M= ��ʾģ���·��.
cd  /root/openvswitch-1.0.1/datapath/linux-2.6/
make -C /lib/modules/$(uname -r)/build M=$(pwd)  modules      
insmod /root/openvswitch-1.0.1/datapath/linux-2.6/openvswitch_mod.ko
insmod /root/openvswitch-1.0.1/datapath/linux-2.6/brcompat_mod.ko

#openvswitch ����, ��װ.
cd  /root/openvswitch-1.0.1/
./configure && make install

#����openvswitch ������
if [ ! -f   /etc/ovs-vswitchd.conf.db ];then
	ovsdb-tool create /etc/ovs-vswitchd.conf.db  /root/openvswitch-1.0.1/vswitchd/vswitch.ovsschema
fi
ovs-vswitchd unix:/var/run/openvswitch/db.sock --pidfile --detach
ovsdb-server /etc/ovs-vswitchd.conf.db  --remote=punix:/var/run/openvswitch/db.sock --detach

#==========================================================================
#��ʼ��������.
ifconfig
ifconfig br100
ifconfig br100 up
ifconfig em3 up

lsmod bridge
lsmod | grep bridge
lsmod | grep open  				#openvswith ��ģ���Ȼ����, �������.
ovs-vsctl -h
ovs-vsctl add-br br100			#��� br100����.
ovs-vsctl add-port br100 em3 	#������� BGP �����绷������, �Լ�������Ҫȷ���õ�.
#ovs-vsctl add-port br100 tap0	#��� tap0 ��ȥ, ��һ���Ǳ�Ҫ, Ĭ��qemu������ʱ��Ĭ��, ���ú�������, �� /etc/qemu-ifup ��.
ovs-vsctl get bridge br100
ovs-vsctl list br
ovs-vsctl list port


#==========================================================================
#qemu-kvm ������ʱ��� ���������ļ�,  /etc/qemu-ifdown, ������
#����ű���д����, ��BGP ����֮��.
cat > /etc/qemu-ifup_ovs <<EOF
#!/bin/sh
/sbin/ifconfig br100 up #���� br100 
switch=br100
/sbin/ifconfig $1 0.0.0.0 up
/bin/ovs-vsctl del-port ${switch} $1
/bin/ovs-vsctl add-port  ${switch} $1
/bin/ovs-vsctl set port $1 tag=351
EOF
;

#--------------------------------------------------------------------------
#�������ú���֮�� ��ʼ�����������. ���������.
#ubuntu.sh ע��һ��,  ָ����  /etc/qemu-ifup_ovs �Ľű�.
qemu-kvm -hda  ubuntu_lvm_20G_amd64.img    -m 4096  -localtime -vnc 0.0.0.0:3   -net nic,macaddr=00:e0:12:33:44:38  -net tap,script=/etc/qemu-ifup_ovs       -daemonize 

cd /var/lib/libvirt/images/ubuntu_srv_20G_lvm/
bash ubuntu.sh


#==========================================================================
#ubuntu ����� ���������Ļ� ���� ���������������, ���濪ʼ�Ų�������.


#==========================================================================
#as6 ����, tap0  �豸��������,  ������������Ų�.
#tunctl ���� tap0 ���߼�� 
tunctl -b tap0
tunctl -d br100
tunctl -h
tunctl -p br100
tunctl -t br100
tunctl -t tap0
yum search tunctl
yum install tunctl
yum install  tunctl
rpm -ivh dir/Packages/tunctl-1.5-3.el6.x86_64.rpm  

#==========================================================================
#ubuntu ������,  ��½ ����.
#��vncviewer.exe ��½ ubuntu �����������,   ȥ��������.
vncviewer.exe  172.30.51.10:5903
#linux 
vncviewer  172.30.51.10:5903
#ͨ��ifconfig �鿴����,  ���ú�����֮�� �� ���������֮�� �Զ����ú�IP.

#���dns ������, ���ԵĻ���������.
cat  >> /etc/resolv.conf <<EOF
nameserver 8.8.4.4
EOF

#�������
route add default gw ip_of_gateway
ping 172.30.51.10 #������������������û��.



#==========================================================================
#as6 ��������, ��� ʵ�ʵ��������� em3 ����û������.
vi ifcfg-em3 #���� ������������ û������ �༭֮�� ��������Ϊ����.
sed '/ONBOOT/{s/no/yes/}' /etc/sysconfig/network-scripts/ifcfg-em3 -i
#f13 as6 ֮�� ����Ĭ�ϵ����������ֶ������emN��.



#==========================================================================
#as6 ���������� openvswitch ������, ���Ǵ�����ʧ��, ���Ž��в���
ovs-vsctl add-br br101
ovs-vsctl add-br br102

ovs-vsctl del-br br100
ovs-vsctl del-br br101
ovs-vsctl del-br br102

ovs-vsctl del-br br100

#==========================================================================
#as6  �ϵ� osv ����������ʧ�� , ������� ���ݿ� ����������.
ps -ef | grep ovs #������û����������
rm /etc/ovs-vswitchd.conf.db -f  #ɾ��openvswitch �����ݿ� ��������һ��.
rmmod bridge

ovsdb-tool create /etc/ovs-vswitchd.conf.db  /root/openvswitch-1.0.1/vswitchd/vswitch.ovsschema
ovs-vswitchd unix:/var/run/openvswitch/db.sock --pidfile --detach
ovsdb-server /etc/ovs-vswitchd.conf.db  --remote=punix:/var/run/openvswitch/db.sock --detach

#==========================================================================
