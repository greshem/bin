#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__

#dns server
nameserver 172.16.1.251 #dns

#mail server 
https://mail.tnsoft.com.cn/owa/


#smtp server 
#mail.tnsoft.com.cn
172.16.1.2
