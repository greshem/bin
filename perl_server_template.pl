#!/usr/bin/perl
while(<DATA>)
{
	print $_
}
__DATA__
#!/usr/bin/perl
use IO::Socket;

$srv_socket=new IO::Socket::INET( LocalPort=>"3344", Listen=>SOMAXCONN, 
							  Proto=>'tcp', Reuse=>1, TimeOut=>60) or die(" create error\n");

while(1)
{
	$connection=$srv_socket->accept;
	
	while(my $line=<$connection>)
	{
		print  $connection $line;
		print   $line,"\n";
	}
}
