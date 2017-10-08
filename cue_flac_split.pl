#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__
rename_file_withNumber.pl 
mkdir output/
shntool split -t "%n.%p-%t" -f 0.cue -o flac 1.flac -d output       

