#!/usr/bin/perl
foreach (<DATA>)
{
	print $_;
}
__DATA__

docker run -d -p 53:53/tcp -p 53:53/udp --cap-add=NET_ADMIN --name dns-server andyshinn/dnsmasq:2.75 
