#!/usr/bin/perl
my $file=shift;
if(!defined($file))
{
	$file= "/usr/share/diskplat/diskplat"
}

#[ 7] .gnu.version      VERSYM          0804aac6 002ac6 000296 02   A  5   0  2

open(FILE, "readelf  -S $file  |");

for(<FILE>)
{
	if($_=~/.*\[(.*)\]\s+(\S+).*/)
	{
		my $number=$1;
		my $name=$2;
		#print "$1".$2."\n";
		  #-x 
		  #--hex-dump=<number|name>
		print "readelf --hex-dump=$name  $file \n";
		print "eu-readelf -x$name   $file \n";
	}	
}
