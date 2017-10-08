#!/usr/bin/perl
$start= shift or die("$0 start_str end_str\n");
$end = shift or die("$0 start_str end_str\n");

for ( $start..$end)
{
	print $_,"\n";
}
