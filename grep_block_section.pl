#!/usr/bin/perl
#2010_12_28_15:06:47 add by greshem
# 增加 invert 相反的功能， grep -v 
#
$file=shift or die("usage: $0 file pattern \n");
$pattern=shift or die("usage: $0 file pattern \n");
my $invert;

if(grep {/invert/} @ARGV)
{
	$invert=1;
}
open(FILE, $file) or die("open  file error $!\n");
@block;
$inBlock=0;
$nth=0;
foreach (<FILE>)
{
	#非空行了
	if($_=~/^\S+/ && $inBlock==0)
	{
		$inBlock=1;
		$nth++;
	#	push(@block, $_);
	}

	#从块里面出来了	
	if($_=~/^\s+$/ && $inBlock==1)
	{
		$inBlock=0;
#		if($nth== $number)
		if(grep {/$pattern/i} @block) 
		{
			if(! $invert)
			{
				map{print} @block;
				print "\n";
			}
		}
		else
		{
			if($invert)
			{
				map{print} @block;
				print "\n";
			}
		}
		@block=();
		#print "##################\n";
		
		
	}

	#在块 block section 里面了. 
	if($inBlock==1)
	{
		push(@block, $_);
	}
	
	
}


if(grep {/$pattern/i} @block) 
{
	if(! $invert)
	{
		map{print} @block;
		print "\n";
	}
}
else
{
	if($invert)
	{
		map{print} @block;
		print "\n";
	}
}

