#!/usr/bin/perl
$file=shift or die("Usage: $0 file.sh");
open(FILE, $file) or die("Open file error\n");
for(<FILE>)
{
	@array=split(/\s+/, $_);
	for(@array)
	{
		if(/\(/ || /\)/)
		{
			print "\'", $_, "\'  ";
		}
		else
		{
			print $_,"  ";
		}
	}
	print "\n";
}
