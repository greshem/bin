#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__
lsof -iTCP -sTCP:LISTEN #��ȡ���е� TCP listem  ��socket 
lsof -i:5900-6000  		#��ȡʹ��5900-6000  ��Χ  range ֮��ʹ�õ�socket
lsof -iTCP:5900-6000  		#��ȡʹ��5900-6000  ��Χ  range ֮��ʹ�õ�TCP socket
lsof -i:22  		#22
lsof -i:67  		#dhcp ��. 
lsof         -iTCP -sTCP:ESTABLISHED  #TCP״̬.
lsof -i -U	#UNIX domain files
lsof -i 6  	#ipv6 



