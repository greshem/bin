#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__

@echo ----------��������WIFI---------------

netsh wlan start hostednetwork #��������.
netsh wlan set hostednetwork mode=allow ssid=greshem-wireless key=1234qwer

@echo ----------WIFI��ʼ����---------------

netsh wlan start hostednetwork

