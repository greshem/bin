#!/usr/bin/python
DATA="""
VLAN

设定:VLAN tag
    ovs-vsctl add-port ovs-br vlan3 tag=3 -- set interface vlan3 type=internal

移除 VLAN
    ovs-vsctl del-port ovs-br vlan3
查询: VLAN
    ovs-vsctl show
    ifconfig vlan3
设定: Vlan trunk
    ovs-vsctl add-port ovs-br eth0 trunk=3,4,5,6
设定已 add 的 port 为 access port, vlan id 9
    ovs-vsctl set port eth0 tag=9

ovs-ofctl add-flow 设定 vlan 100
    ovs-ofctl add-flow ovs-br in_port=1,dl_vlan=0xffff,actions=mod_vlan_vid:100,output:3
    ovs-ofctl add-flow ovs-br in_port=1,dl_vlan=0xffff,actions=push_vlan:0x8100,set_field:100-\>vlan_vid,output:3

ovs-ofctl add-flow 拿掉 vlan tag
    ovs-ofctl add-flow ovs1 in_port=3,dl_vlan=100,actions=strip_vlan,output:1
    two_vlan example

ovs-ofctl add-flow pop-vlan
    ovs-ofctl add-flow ovs-br in_port=3,dl_vlan=0xffff,actions=pop_vlan,output:1

"""
print DATA; 
