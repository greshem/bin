#!/usr/bin/perl 

#use strict;
#use warnings;

for (glob("*.reg"))
{
	$file_str=`file $_`;	
	if($file_str=~/Windows\+Registry\+text\s+Win95 or above\s+/)
	{
	
	}
	elsif($file_str=~/Win2K/)
	{
		print "first line change to  register4\n";	
	}
	elsif($file_str=~/Little-endian\s+UTF-16/)
	{
		print "#### $_\n";
		print "iconv -f utf-16le -t utf-8 < win.reg | dos2unix > linux.reg \n";
  		print "unix2dos linux.reg | iconv -f utf-8 -t utf-16le > win.reg \n";

	}
	elsif ($file_str=~/ BOM.*text/)
	{
		print "dd if=$_ of=tmp2 bs=3 skip=1	\n";
	}
	elsif($file_str=~/ISO-8859/)
	{
		print "$_ #last char of the line is space \n";	
	}
	elsif($file_str=~/ascii/i)
	{
		print "dos2unix\n";
	}
}


