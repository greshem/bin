#!/usr/bin/perl
use File::Basename;

$file=shift or die("Usage: $0 file_list\n");
open(FILE, $file) or die("open file error\n");
while(<FILE>)
{
	chomp;
	if(-f $_)
	{
		$dir=dirname($_);
		print $dir,"\n";
	}
	else
	{
		print $_,"\n";
	}
}

