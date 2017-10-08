#!/usr/bin/perl
@tmp=glob("*");
@dir=grep -d, @tmp;
for (@dir)
{
	$line=`find $_|wc -l `;
	chomp $line;
	print $line,"\t\t";
	print $_,"\n";
	
}
