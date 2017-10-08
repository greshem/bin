#!/usr/bin/perl
sub get_ip_address($) 
{
	use Socket;
	require 'sys/ioctl.ph';

    my $pack = pack("a*", shift);
    my $socket;
    socket($socket, AF_INET, SOCK_DGRAM, 0);
    ioctl($socket, SIOCGIFADDR(), $pack);
    return inet_ntoa(substr($pack,20,4));
};

sub get_ip_netmask($) 
{
	use Socket;
	require 'sys/ioctl.ph';

    my $pack = pack("a*", shift);
    my $socket;
    socket($socket, AF_INET, SOCK_DGRAM, 0);
    ioctl($socket, SIOCGIFNETMASK(), $pack);
    return inet_ntoa(substr($pack,20,4));
};

