#!/usr/bin/perl
our @dirs;
$cmd=" du --max-depth=1 -h  -c ";

while(<*>)
{
	if(-d $_)
	{
		push(@dirs, $_);
	}
}

$cmd.=join(" ", @dirs);
$cmd.="\n";
print $cmd

