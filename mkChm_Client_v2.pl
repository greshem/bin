#!/usr/bin/perl
use IO::Socket;

use getAllFileFromDir;
$in= $ARGV[0] or die("Usage: $0 dir\n");
@files=grep { /tar.gz$/ }getAllFileFromDir($in);
@tmp=sort { (-s $a) <=> (-s $b)} @files;
for(@tmp)
{
	print "$_ \n";
	SendFile($_);
}
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
		$ret=sysread(FILE, $a, 4096);
		#sleep(1);
		#$sel=IO::Select->new();
		#$sel->add($sock);
		#@ready=$sel->can_read();
		#print "###########\n";
		select(undef, undef, undef, 0.25);
		if($ret>0)
		{
			$sock->syswrite($a, $ret);
		}
		else
		{
			last;
		}
	}
	#print $sock $a;
	close($sock);
	return 1;
}
