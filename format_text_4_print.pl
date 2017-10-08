#!/usr/bin/perl
 while(<STDIN>)
 {
	if($length< 70)
	{chomp; 
	$length+=length($_);
	print $_,"  ";
	}
	else
	{
	print $_;
	$length=0;
	}
}
	
	
