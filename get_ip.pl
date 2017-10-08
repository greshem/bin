#!/usr/bin/perl
my $netcard=shift ;
if( defined($netcard))
{
	print method_2("$netcard");
}
else
{
	method_1();
}

sub method_1()
{
	$buf=`hostname -I  `;
	@array=split(/\s+/, $buf);
	print $array[1]."\n";
}


sub method_2()
{
#"/sys/class/net/br0"
#use strict;
#use warnings;
use Socket;
require 'sys/ioctl.ph';
    my $pack = pack("a*", shift);
    my $socket;
    socket($socket, AF_INET, SOCK_DGRAM, 0);
    ioctl($socket, SIOCGIFADDR(), $pack);
    return inet_ntoa(substr($pack,20,4));

}


