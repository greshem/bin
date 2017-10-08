#!/usr/bin/perl
my $fileList=shift or die("usage: $0 filelist start end\n");
my $start	=shift  or die("Usage: $0 filelist   start end\n");
my $end 	= shift or die("usage: $0  filelist   start end\n");

if($start > $end)
{
	$max=$start;
	$start=$end;
	$end=$max;
}
$it=0;
	
open(FILE, $fileList) or die("open file error $!\n");
for(<FILE>)
{
	$it++;
	if($it >= $start	 && $it <= $end)
	{
		print $_;
	}
}
