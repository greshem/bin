#!/usr/bin/perl 
opendir(DIR,".");
@file=grep -f, readdir(DIR);
for (@file)
{
	print $_,"\n";
}
