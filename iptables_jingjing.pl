#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__
#==========================================================================
#server, 添加上2块 网卡  
eth1  output_netcard  还是设置为192.168.1.1 
iptables -t nat -A POSTROUTING -s 192.168.3.0/24 -o eth1  -j MASQUERADE



eth2  ip as 192.168.3.3  same netrange as client  range  

echo 1 > /proc/sys/net/ipv4/ip_forward 

tcpdump -i eth2 tcp and port  http , 这里抓取 温淑娜 工作网络所有的http 包了. 


#==========================================================================
#1. client  设置 路由器的ip 
setup eth1   set  default gw  as 192.168.3.3 , 自己的 ip设置为192.168.3.100 




########################################################################
#在vmware 上实验 这种  case 还是比较简单的,  
1. 把 server 的  eth2 连接到   vmnet2  
2.  client 的eth1  	也连接到   vmnet2,  然后   做上面的设置. 
