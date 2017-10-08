#!/usr/bin/perl

use Data::Dumper; 
	@b=glob("*"); 
	for $each2 (@b) 
	{-T $each2 && print $each2."\n" }
