#!/usr/bin/perl
use File::Copy::Recursive qw(dirmove);
while(<*>)
{
	if(-d $_ && /(\d+)_(.*)/)
	{
		print "mv ", $_, "  $2\n";
		dirmove($_, $2);
	}	
}
