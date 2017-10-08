#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__
lsof -iTCP -sTCP:LISTEN #获取所有的 TCP listem  的socket 
lsof -i:5900-6000  		#获取使用5900-6000  范围  range 之间使用的socket
lsof -iTCP:5900-6000  		#获取使用5900-6000  范围  range 之间使用的TCP socket
lsof -i:22  		#22
lsof -i:67  		#dhcp 包. 
lsof         -iTCP -sTCP:ESTABLISHED  #TCP状态.
lsof -i -U	#UNIX domain files
lsof -i 6  	#ipv6 



