#!/usr/bin/perl
$file=shift or die("Usage: $0  file_list  depth_number\n");
$depth=shift or die("Usage: $0  file_list  depth_number\n");

open(FILE, $file) or die("open file error\nk");
while(<FILE>)
{
	chomp;
	@tmp=split(/\//, $_);
	if(scalar(@tmp) == $depth)
	{
		print $_,"\n" if(-f $_);
	}
}
