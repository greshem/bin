#!/usr/bin/python
#coding=utf-8

import os
import sys;

if len(sys.argv) != 2:
    print "%s  input.iso"%(sys.argv[0]);
    sys.exit(0);

iso=sys.argv[1];
name=os.path.basename(iso)
#name="centos7"



#  bin/develop_python/libvirt-list_network.py
#--network network=ovs-net,portgroup=vlan59 \\
DATA="""
#--network network:br-ex
#也可以采用virt-install命令下直接产生虚机
/usr/bin/virt-install \\
        --name {name} \\
        --ram 1024 \\
        --virt-type kvm \\
        --vcpus 1 \\
        --disk path=/vmstorage/{name}.img,size=20 \\
        --cdrom {iso} \\
        --graphics vnc,password=123456,listen=0.0.0.0 \\
        --network network=mybridge166 \\
        --force \\
        --autostart 
""".format(iso=iso, name=name);
print DATA;

