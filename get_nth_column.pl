#!/usr/bin/perl
#qianzj ��ӡ �� n �С�20100517.  
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
	#��ӡn��Ԫ��
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
	#��ӡȫ���� 
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
