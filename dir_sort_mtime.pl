#!/usr/bin/perl
$file=shift or warn("Usage: $0 list\n");
if( defined $file)
{
	open(FILE, $file) or die("open file error\n");
	@files=map{chomp;$_} <FILE>;
}
else
{
	@files=grep { -d } (<*>)	;
}

#map {print $_, -s $_,"\n";} sort{-s $a <=> -s $b} @files;

@filesSort= sort{-M $a <=> -M $b} @files;

for(@filesSort)
{
	print  $_, " --> ", HumanNumber(-s $_), "\t", -M $_, "\n";
}

sub HumanNumber($)
{
	($in)=@_;
		return int($in/1024)."k " ;
}
