#!/usr/bin/perl
$start=shift;
if(!defined($start))
{
	$start=0;
}
$count=$start;
for(<*>)
{
	if(-f $_)
	{
		(my $suffix)=($_=~/.*\.(.*)/);
		print "mv \"$_\" $count.$suffix \n";			
	}
	$count++;
}

sub method2()
{
}
