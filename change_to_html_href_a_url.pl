#!/usr/bin/perl

my $file=shift or die("Usage: $0 input file \n");

open(FILE, $file) or die("Open file error \n");

for(<FILE>)
{
	chomp;
	print "<a href=\"$_\"> $_ </a> </br> \n";
}
