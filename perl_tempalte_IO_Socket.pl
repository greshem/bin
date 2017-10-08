#!/usr/bin/perl
while(<DATA>)
{
	print $_;
}
__DATA__
#client
$socket = IO::Socket::INET->new(PeerAddr => "192.168.3.234", PeerPort => "80", Proto => "tcp", Type => SOCK_STREAM) or die "failed.. $!\n";
#server
$srv_socket=IO::Socket::INET->new(LocalPort=>"3344", Listen=>SOMAXCONN, Proto=>"tcp", Reuse=>1 , TimeOut=>60) or die(" create socket error $!\n");

