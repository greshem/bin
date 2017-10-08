#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__
#2012_03_09_18:03:48   星期五   add by greshem
#下午和吴智敏 花了一个小时 整理出来的  openvswitch 的用法.
#==========================================================================
#去除系统默认的桥, 很重要 否则还是会跟openvswitch 的 桥会产生冲突的.
lsmod | grep bridge
rmmod bridge

#==========================================================================
#openvswitch 内核编译, as5 as6 编译成功  f13 f16 会编译失败, 不过没有什么影响.
#M= 表示模块的路径.
cd  /root/openvswitch-1.0.1/datapath/linux-2.6/
make -C /lib/modules/$(uname -r)/build M=$(pwd)  modules      
insmod /root/openvswitch-1.0.1/datapath/linux-2.6/openvswitch_mod.ko
insmod /root/openvswitch-1.0.1/datapath/linux-2.6/brcompat_mod.ko

#openvswitch 编译, 安装.
cd  /root/openvswitch-1.0.1/
./configure && make install

#启动openvswitch 服务器
if [ ! -f   /etc/ovs-vswitchd.conf.db ];then
	ovsdb-tool create /etc/ovs-vswitchd.conf.db  /root/openvswitch-1.0.1/vswitchd/vswitch.ovsschema
fi
ovs-vswitchd unix:/var/run/openvswitch/db.sock --pidfile --detach
ovsdb-server /etc/ovs-vswitchd.conf.db  --remote=punix:/var/run/openvswitch/db.sock --detach

#==========================================================================
#开始配置网络.
ifconfig
ifconfig br100
ifconfig br100 up
ifconfig em3 up

lsmod bridge
lsmod | grep bridge
lsmod | grep open  				#openvswith 的模块必然存在, 否则错误.
ovs-vsctl -h
ovs-vsctl add-br br100			#添加 br100的桥.
ovs-vsctl add-port br100 em3 	#这个根据 BGP 的网络环境来的, 自己当场需要确定好的.
#ovs-vsctl add-port br100 tap0	#添加 tap0 上去, 这一步非必要, 默认qemu启动的时候默认, 设置好网络了, 在 /etc/qemu-ifup 中.
ovs-vsctl get bridge br100
ovs-vsctl list br
ovs-vsctl list port


#==========================================================================
#qemu-kvm 的启动时候的 网络配置文件,  /etc/qemu-ifdown, 其他的
#这个脚本是写死的, 给BGP 环境之用.
cat > /etc/qemu-ifup_ovs <<EOF
#!/bin/sh
/sbin/ifconfig br100 up #启动 br100 
switch=br100
/sbin/ifconfig $1 0.0.0.0 up
/bin/ovs-vsctl del-port ${switch} $1
/bin/ovs-vsctl add-port  ${switch} $1
/bin/ovs-vsctl set port $1 tag=351
EOF
;

#--------------------------------------------------------------------------
#网络设置好了之后 开始启动虚拟机了. 启动虚拟机.
#ubuntu.sh 注意一下,  指定了  /etc/qemu-ifup_ovs 的脚本.
qemu-kvm -hda  ubuntu_lvm_20G_amd64.img    -m 4096  -localtime -vnc 0.0.0.0:3   -net nic,macaddr=00:e0:12:33:44:38  -net tap,script=/etc/qemu-ifup_ovs       -daemonize 

cd /var/lib/libvirt/images/ubuntu_srv_20G_lvm/
bash ubuntu.sh


#==========================================================================
#ubuntu 虚拟机 不能启动的话 或者 虚拟机网络有问题, 下面开始排查问题了.


#==========================================================================
#as6 上面, tap0  设备出现问题,  用下面的命令排查.
#tunctl 工具 tap0 工具检测 
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
#ubuntu 有问题,  登陆 网络.
#用vncviewer.exe 登陆 ubuntu 虚拟机服务器,   去里面设置.
vncviewer.exe  172.30.51.10:5903
#linux 
vncviewer  172.30.51.10:5903
#通过ifconfig 查看网络,  设置好网管之后 让 虚拟机启动之后 自动设置好IP.

#添加dns 服务器, 可以的话让他上网.
cat  >> /etc/resolv.conf <<EOF
nameserver 8.8.4.4
EOF

#添加网管
route add default gw ip_of_gateway
ping 172.30.51.10 #看看虚拟机最后起来了没有.



#==========================================================================
#as6 服务器上, 最后 实际的物理网卡 em3 还是没有起来.
vi ifcfg-em3 #可能 最后的物理网卡 没有启动 编辑之后 把他设置为启动.
sed '/ONBOOT/{s/no/yes/}' /etc/sysconfig/network-scripts/ifcfg-em3 -i
#f13 as6 之后 对于默认的网卡的名字都变成了emN了.



#==========================================================================
#as6 假如启动了 openvswitch 服务器, 但是创建桥失败, 对桥进行测试
ovs-vsctl add-br br101
ovs-vsctl add-br br102

ovs-vsctl del-br br100
ovs-vsctl del-br br101
ovs-vsctl del-br br102

ovs-vsctl del-br br100

#==========================================================================
#as6  上的 osv 服务器启动失败 , 重新清空 数据库 再启动服务.
ps -ef | grep ovs #看看有没有启动服务
rm /etc/ovs-vswitchd.conf.db -f  #删除openvswitch 的数据库 重新生成一下.
rmmod bridge

ovsdb-tool create /etc/ovs-vswitchd.conf.db  /root/openvswitch-1.0.1/vswitchd/vswitch.ovsschema
ovs-vswitchd unix:/var/run/openvswitch/db.sock --pidfile --detach
ovsdb-server /etc/ovs-vswitchd.conf.db  --remote=punix:/var/run/openvswitch/db.sock --detach

#==========================================================================
