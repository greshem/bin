#!/usr/bin/perl
$file=shift;
open(FILE, $file) or die(" open file error\n");
for(<FILE>)
{
	chomp;
	if(/^(\d+).*/)
	{
	#	print $1 ,"---------", $2,"\n";
		$size=$_;
		if($size=~/([\d|\.]+)k$|K$/)
		{
			#print  $_,"\t",$1."x1024\n";
			print  $1*1024 , "\n";
		}
		elsif($size=~/([\d|\.]+)(m$|M$)/)
		{
			#print $_,"\t", $1."x1024x1024\n";
			print  $1*1024*1024,"\n";
		}
		elsif($size=~/([\d|\.]+)(g$|G$)/)
		{
			#print $_,"\t",  $1."x1024x1024x1024\n";
			print  $1*1024*1024*1024, "\n";
		}
		else
		{
			print $_,"\n";
		}
	}
} 

