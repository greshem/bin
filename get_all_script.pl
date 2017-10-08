#!/usr/bin/perl

use Data::Dumper; 
@a=split(/:/, $ENV{PATH});
for $each (@a) 
{
	chdir($each);
	@b=glob("*"); 
	for $each2 (@b) 
	{-T $each2 && print $each."/".$each2."\n" }
}
