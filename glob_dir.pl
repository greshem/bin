#!/usr/bin/perl
$pat=shift or die("Usage: $0 pattern\n");

@files= grep { -d } glob("$pat*");
foreach (@files)
{
	print $_,"\n";
}
