#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__
-a alive ,  ֻ��ӡ ���  
cat /etc/hosts |fping -A
cat /etc/hosts |fping -a

fping -a -g 192.168.1.0/24 			#����. range ��Χ -g
fping -a -g 172.16.10.0/24 			#����.
fping -a -g 192.168.1.0 192.168.1.255 	#����
fping -a -g 172.16.10.0/24 -a -c 1  	#ֻ��ʾ��� alive  count =1




#-a  alive 
fping -a -g 172.16.1.0/24     >  /tmp/tnsoft_hosts
fping -a -g 172.16.2.0/24     >> /tmp/tnsoft_hosts
fping -a -g 172.16.3.0/24     >> /tmp/tnsoft_hosts
fping -a -g 172.16.10.0/24    >> /tmp/tnsoft_hosts
fping -a -g 172.16.11.0/24    >> /tmp/tnsoft_hosts

#ci ������.
fping -a -g 172.16.13.0/24    >> /tmp/tnsoft_hosts

fping -a -g 172.16.101.0/24   >> /tmp/tnsoft_hosts
fping -a -g 172.18.10.0/24    >> /tmp/tnsoft_hosts

fping -a -g 192.168.6.0/24    >> /tmp/tnsoft_hosts
