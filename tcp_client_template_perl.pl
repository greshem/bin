#!/usr/bin/perl
while(<DATA>)
{
	print $_
}
__DATA__
#!/usr/bin/perl
use IO::Socket::INET;
$sock=new IO::Socket::INET(PeerAddr=>"192.168.3.234", PeerPort=>"3344", Proto=>"tcp") ;

$buffer="GET /index_dir.php HTTP/1.0 \r\n";
#$sock->send($buffer, length($buffer));
print $sock $buffer;

$a=<$sock>;
#@a=<$sock>;
print $a;

#server as descirption  in the "/bin/netcat_nc_usage.pl"
