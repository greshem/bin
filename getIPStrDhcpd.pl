#!/usr/bin/perl
#$file=shift or die("Usage: $0 file pattern\n");
$pattern=shift;
open(STDIN, "/etc/dhcpd.conf") or die("open file error\n");
while(<STDIN>)
{
	if($_=~/$pattern/)
	{	
		#subnet 
		if($pattern=~/subnet/ && $_=~/subnet.*netmask/)
		{
			#print "###############\n";
			@array=split(/\s+/, $_);
			print $array[1],"\n";	
			print STDERR "#line ",$_;
			exit(1);
		}
		#netmask 
		if($pattern=~/netmask/ && $_=~/subnet.*netmask/)
		{
			#print "###############\n";
			@array=split(/\s+/, $_);
			print $array[3],"\n";	
			print STDERR "#line ",$_;
			exit(1);
		}
		#subnet option 
		if($_=~/option.*subnet/ && $pattern=~/subnet$/)
		{
			next;	
		}
		if(/(\d+\.\d+\.\d+\.\d+)/ )
		{
			print $1,"\n";
			print STDERR "#line ",$_;
			exit(1);
		}
	}
}

