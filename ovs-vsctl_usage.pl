#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__
ovsdb-tool create /etc/ovs-vswitchd.conf.db  /usr/share/openvswitch/vswitch.ovsschema
mkdir /var/run/openvswitch
ovsdb-server /etc/ovs-vswitchd.conf.db  --remote=punix:/var/run/openvswitch/db.sock --detach 
ovs-vswitchd unix:/var/run/openvswitch/db.sock --pidfile --detach 


ovs-vsctl add-br 	br100
ovs-vsctl list-br 
ovs-vsctl list-br                     #print the names of all the bridges

ovs-vsctl add-port 		br100 tap11
ovs-vsctl del-port  	br100 tap34
ovs-vsctl del-port 		br100 tap33
ovs-vsctl list-ports 	br100

ovs-vsctl list-ifaces 	br100   

#==========================================================================
#最后一个是vlan的参数.
ovs-vsctl add-br br101 br0 101
