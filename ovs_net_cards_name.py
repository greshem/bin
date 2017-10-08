#!/usr/bin/python
DATA="""
#在 Open vSwitch 环境中，一个数据包从 instance 发送到物理网卡大致会经过下面几个类型的设备：
tap interface   -> 命名为 tapXXXX。
 linux bridge  -> qbrXXXX。
veth pair  -> qvbXXXX, qvoXXXX。
OVS integration bridge  -> br-int。
OVS patch ports  -> 命名为 int-br-ethX 和 phy-br-ethX（X 为 interface 的序号）。
OVS provider bridge  ->  命名为 br-ethX（X 为 interface 的序号）。
物理 interface  ->  ethX  emx  X 为 interface 的序号）。
OVS tunnel bridge -> 命名为 br-tun。


OVS provider bridge 会在 flat 和 vlan 网络中使用；OVS tunnel bridge 则会在 vxlan 和 gre 网络中使用。 
"""
print DATA;
