#!/usr/bin/perl
foreach (<DATA>)
{
	print $_;
}
__DATA__

arp-scan --timeout 5  --interface=br100   192.168.1.0/24
