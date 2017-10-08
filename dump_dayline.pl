#!/usr/bin/perl
use Data::Dumper;
print @ARGV[0];
open(MYFILE,@ARGV[0]);
my $buff;
while(read(MYFILE, $buff, 40))
{
	@array= unpack("LLLLLLLLLL", $buff);
	print Dumper( @array),"\n"
}
