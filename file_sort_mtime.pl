#!/usr/bin/perl
use Getopt::Std;
use POSIX;
#$file=shift ;#or warn("Usage: $0 list\n");
my %opts;
getopts('vf:sh' , \%opts);
my $count_opt=keys %opts;

if( defined $opts{"h"} )
{
	Usage();
}
if( defined $opts{"f"})
{
	open(STDIN, $opts{"f"}) or die("open file error\n");
	@files=map{chomp;$_} <STDIN>;
}
else
{
	@files=grep { -f } (<*>)	;
}

#map {print $_, -s $_,"\n";} sort{-s $a <=> -s $b} @files;
if(!  $opts{"s"})
{
	@filesSort= sort{-M $a <=> -M $b} @files;
}
else
{
	@filesSort= @files;
}

for(@filesSort)
{

	if($opts{"v"})
	{
		print  $_, " --> ", HumanNumber(-s $_), "\t", -M $_, "\n";
	}
	else
	{
		print $_, "\t", substr((-M $_), 0, 5),"\n";
		#print $_, "\t", (-M $_), ,"\n";
	}
}

sub HumanNumber($)
{
	($in)=@_;
		return int($in/1024)."k " ;
}
sub Usage()
{
	print $0,"\t-v verbose , -f file , -s not sort , -h help \n";
	exit(0);
}
