#!/usr/bin/perl

use Data::Dumper; 

	@b=glob("*"); 
	for  (@b) 
	{
		if(-T $_ )
		{ 
				#print $each."/".$each2."\n" 
			$tmp=`file $_`;
			if( $tmp=~/perl\s+script/)
			{
				print "mv $_ $_".".pl\n" if($_ !~/pl$/);
			}
			elsif($tmp=~/shell\s+script/)
			{
				print "mv $_ $_".".sh\n" if($_!~/sh$/);
			}
			elsif($tmp=~/python\s+script/)
			{
				print "mv $_ $_".".py\n" if($_!~/py$/);
			}
		}
	}
