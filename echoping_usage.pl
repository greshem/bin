#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__

#==========================================================================
yum install echoping 
##server
#	/etc/xinetd.d/echo-dgram
#	/etc/xinetd.d/echo-stream

#==========================================================================
#Tests the remote machine with TCP echo (one test).
echoping -v acer

#Tests the remote machine with TCP echo (five tests, every ten seconds).
echoping -n 5 -w 10 acer

#Tests the remote Web server and asks its home page. Note you don't indicate the whole URL.
echoping -h / acer

#Tests the remote Web proxy-cache and asks a Web page. Note that you must indicate the whole URL.
echoping -h http://www.example.com/ cache.example.com:3128

#Loads the whois plugin and query the host acer. "-d tao.example.org" are options specific to the whois plugin.
echoping -n 3 -m whois acer -d tao.example.org

#Sends several UDP Echo packets with an IP Precedence of 5.
echoping -u -P 0xa0 acer


#==========================================================================
iptraf  
tcpdump port 7 -i lo 		#and you will see the udp flow
telnet acer 7 				#also can test the echo protocol
