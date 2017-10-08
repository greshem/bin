#!/usr/bin/perl
$file=shift or warn("Usage: $0 list\n") && exit(0);
open(FILE, $file) or die(" open file error\n");
@array=map{chomp; $_} (<FILE>);

if( scalar(@array) != 1 ) 
{
	exit(0);
}

exit(1);
