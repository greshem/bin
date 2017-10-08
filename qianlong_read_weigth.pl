#!/usr/bin/perl
#print @ARGV[0];
open(MYFILE,@ARGV[0]);
my $buff;
while(read(MYFILE, $buff, 36))
{
	($a1, $a2, $a3, $a4, $a5, $a6, $a7, $a8, $a9)= unpack("L L L L L L L L L", $buff);
	print $a1,"\t", $a2, "\t", $a3,"\t",  $a4,"\t", $a5,"\t", $a6,"\t", $a7,"\t", $a8,"\t", $a9,"\t","\n";
}
