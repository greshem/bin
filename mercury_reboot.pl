#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__

wget --http-user=admin --save-cookie=dlink.cookie   "http://192.168.1.1:8080/userRpm/SysRebootRpm.htm?Reboot=%D6%D8%C6%F4%C2%B7%D3%C9%C6%F7" --http-passwd=passwd  


