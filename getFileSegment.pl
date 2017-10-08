#!/usr/bin/perl
$file=shift or die("Usage: $0 file [0ffset]\n");
$offset=eval(shift) or $offset=0;
open(FILE, $file) or die("open file error\n");

seek(FILE, $offset, 1);
sysread(FILE, $a, 1024*2);
print $a,"\n";
