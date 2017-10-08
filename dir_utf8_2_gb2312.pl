#!/usr/bin/perl
use File::Copy::Recursive qw(fcopy rcopy dircopy fmove rmove dirmove);


use Encode;
while(<*>)
{
		
	$to=encode("gb2312", decode("utf-8", $_));
	#print $to;
	dirmove($_, $to);
}
