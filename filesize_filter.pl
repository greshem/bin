#!/usr/bin/perl

if( $ARGV[0])
{
open(FILE,$ARGV[0]) or die "open file error";
}
else
{
	open(FILE,"all_package_size") or die "open file  error";
}
while(<FILE>)
{
	if(/(\S+)(\s+)\S+/)
	{ 
		print $_ if(length($1)>6)
	}
}

