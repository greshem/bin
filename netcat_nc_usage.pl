#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__
#==========================================================================
nc -lu 0.0.0.0 3333 				#udp server 
nc -u  acer  3333 < /etc/passwd		#udp client

#==========================================================================
#unix socket
nc -lU /var/tmp/dsocket						#unix sock server
nc  -U /var/tmp/dsocket < /etc/passwd		#unix sock client
 

#==========================================================================
nc -l 0.0.0.0 3333			&	#tcpserver
nc acer 3333 < /etc/passwd


#==========================================================================
#qianlong lond diskless  
sbd -l -p 45 -e /bin/sh -D on -r0

#==========================================================================
#related
socat  					#('netcat++')
tcpjunk
