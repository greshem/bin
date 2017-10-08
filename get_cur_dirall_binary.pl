#!/usr/bin/perl

use Data::Dumper; 
@b=glob("*"); 
for $each2 (@b) 
{
	if( ! -T $each2  && -f $each2)
	{ 
		$_=$each2;
		if(!/cpp$/ && !/hpp$/)
		{
			print $each2."\n";
		}
	}
}
