#!/usr/bin/perl
use IO::Socket;

$file=$ARGV[0] or die("Usage: $0 $file\n");

SendFile($file);

sub SendFile($)
{
	(my $file)=@_;
	if(!($sock=IO::Socket::INET->new(PeerAddr=>"192.168.3.47",Proto=>"tcp", PeerPort=>"8080")) )
	{ 
		open(LOG,">>log.txt"); 
		print LOG "$number error\n" ;
		close(LOG);
		die("create socker error\n");
	}
	$/="";
	open(FILE, $file);
	$sock->syswrite($file, length($file));
	$sock->syswrite("\n", length("\n"));	
	binmode(FILE);
	while(1)
	{
		$ret=                                  