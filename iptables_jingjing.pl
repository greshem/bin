#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__
#==========================================================================
#server, �����2�� ����  
eth1  output_netcard  ��������Ϊ192.168.1.1 
iptables -t nat -A POSTROUTING -s 192.168.3.0/24 -o eth1  -j MASQUERADE



eth2  ip as 192.168.3.3  same netrange as client  range  

echo 1 > /proc/sys/net/ipv4/ip_forward 

tcpdump -i eth2 tcp and port  http , ����ץȡ ������ �����������е�http ����. 


#==========================================================================
#1. client  ���� ·������ip 
setup eth1   set  default gw  as 192.168.3.3 , �Լ��� ip����Ϊ192.168.3.100 




########################################################################
#��vmware ��ʵ�� ����  case ���ǱȽϼ򵥵�,  
1. �� server ��  eth2 ���ӵ�   vmnet2  
2.  client ��eth1  	Ҳ���ӵ�   vmnet2,  Ȼ��   �����������. 
