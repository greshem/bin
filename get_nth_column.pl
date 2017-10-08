#!/usr/bin/perl
#qianzj 打印 第 n 列。20100517.  
use Getopt::Std;
use POSIX;
my %opts;
getopts('n:f:h', \%opts);
#$file=shift;
#$nth=shift or die(" usage: file/or_no_file  nth_column\n");
if($opts{"h"})
{
	Usage();
}
if(defined $opts{"f"})
{
	open(STDIN, $opts{"f"}) or die("open file error\n");
}
	
if(! defined($opts{"n"}))
{
	$nth=undef;

}
else
{
	$nth=$opts{"n"};
}
$nth=$opts{"n"};

#mainloop
#
my @array;
for(<STDIN>)
{
	chomp;
	@array=split(/\s+/, $_);
	#打印n个元素
	if(defined($nth))
	{
		if(defined($array[$nth]))
		{
			print $array[$nth],"\n";
		}
		else
		{
			print "\t\n";
		}
	}
	#打印全部。 
	else
	{
		for $each (@array)
		{
			print $each," ";
		}
		print "\n";
	}
}
sub Usage()
{

	print $0, "-f file ; -n nth ; -h help\n";
	exit(-1);
}
