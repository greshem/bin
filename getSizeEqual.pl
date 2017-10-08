#!/usr/bin/perl
$size = shift or die("Usage: $0 fileSize\n");

for(<*>)
{
	
	if( -f && -s $_ == $size)
	{
		print $_,"\n";
	}
}
