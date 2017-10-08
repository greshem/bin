#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__
-a alive ,  只打印 活动的  
cat /etc/hosts |fping -A
cat /etc/hosts |fping -a

fping -a -g 192.168.1.0/24 			#网段. range 范围 -g
fping -a -g 172.16.10.0/24 			#网段.
fping -a -g 192.168.1.0 192.168.1.255 	#网段
fping -a -g 172.16.10.0/24 -a -c 1  	#只显示活动的 alive  count =1




#-a  alive 
fping -a -g 172.16.1.0/24     >  /tmp/tnsoft_hosts
fping -a -g 172.16.2.0/24     >> /tmp/tnsoft_hosts
fping -a -g 172.16.3.0/24     >> /tmp/tnsoft_hosts
fping -a -g 172.16.10.0/24    >> /tmp/tnsoft_hosts
fping -a -g 172.16.11.0/24    >> /tmp/tnsoft_hosts

#ci 服务器.
fping -a -g 172.16.13.0/24    >> /tmp/tnsoft_hosts

fping -a -g 172.16.101.0/24   >> /tmp/tnsoft_hosts
fping -a -g 172.18.10.0/24    >> /tmp/tnsoft_hosts

fping -a -g 192.168.6.0/24    >> /tmp/tnsoft_hosts
