#!/usr/bin/python
DATA="""

#vlan 
ip link add link eth1 name eth1.2 type vlan id 2

#tap create 
ip tuntap add gw2 mode tap


"""
print DATA; 
