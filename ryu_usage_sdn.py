#!/usr/bin/python
DATA="""
pip install ryu  
ryu-manage 

#监听的端口是:  6633 /6653 
ps -elf |grep ryu-manage
ryu-manag 3663 root    3u     IPv4 797286528       0t0        TCP *:6633 (LISTEN)
ryu-manag 3663 root    4u     IPv4 797286530       0t0        TCP *:6653 (LISTEN)

# ovs 控制器地址
ovs-vsctl       set-controller br-ex tcp:192.168.100.1:6633
ovs-vsctl       get-controller br0
ovs-controller  ptcp:6633:192.100.100.1


"""
print DATA;
