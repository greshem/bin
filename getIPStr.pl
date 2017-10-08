#!/usr/bin/perl
while(<STDIN>)
{
	if(/(\d+\.\d+\.\d+\.\d+)/)
	{
		print $1;
		exit(1);
	}
}
