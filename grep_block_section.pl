#!/usr/bin/perl
#2010_12_28_15:06:47 add by greshem
# ���� invert �෴�Ĺ��ܣ� grep -v 
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
	#�ǿ�����
	if($_=~/^\S+/ && $inBlock==0)
	{
		$inBlock=1;
		$nth++;
	#	push(@block, $_);
	}

	#�ӿ����������	
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

	#�ڿ� block section ������. 
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

