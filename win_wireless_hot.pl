#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__

@echo ----------开启虚拟WIFI---------------

netsh wlan start hostednetwork #服务启动.
netsh wlan set hostednetwork mode=allow ssid=greshem-wireless key=1234qwer

@echo ----------WIFI开始工作---------------

netsh wlan start hostednetwork

