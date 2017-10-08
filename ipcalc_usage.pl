#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__
sipcalc 1.1.1.1/24

ipv4calc --netmask 		1.1.1.3/24
ipv4calc --network   	1.1.1.3/24
ipv4calc --broadcast	1.1.1.3/24
ipv4calc --netmask		1.1.1.3/24
ipv4calc --cidr 		1.1.1.3/24
ipv4calc --address  	1.1.1.3/24


iptab

