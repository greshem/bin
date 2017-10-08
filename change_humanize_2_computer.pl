#!/usr/bin/perl
$file=shift or Usage();

open(FILE, $file) or die(" open file error\n");
for(<FILE>)
{
	chomp;
	if(/(\S+)\s+(\S+)/)
	{
	#	print $1 ,"---------", $2,"\n";
		$size=$1;
		$src=$2;
		if($size=~/([\d|\.]+)k$|K$/)
		{
			#print  $_,"\t",$1."x1024\n";
			print  $1*1024, "\t", $src,"\n";
		}
		elsif($size=~/([\d|\.]+)(m$|M$)/)
		{
			#print $_,"\t", $1."x1024x1024\n";
			print  $1*1024*1024,"\t",$src,"\n";
		}
		elsif($size=~/([\d|\.]+)(g$|G$)/)
		{
			#print $_,"\t",  $1."x1024x1024x1024\n";
			print  $1*1024*1024*1024,"\t", $src, "\n";
		}
		else
		{
			#print $_;
		}
	}
} 

sub Usage()
{
	print "Usage: $0 listFile\n";
	print "listFile Format as follow \n";
	print "100M	file1\n";
	print "100k	dir1\n";
	print "1G 	file2\n";
	exit -1;
		
}
