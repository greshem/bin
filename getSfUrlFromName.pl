#!/usr/bin/perl
$name=shift or die("usage: $0 name\n");
print  "http://www.mirrorservice.org/sites/download.sourceforge.net/pub/sourceforge/".substr($name, 0, 1)."/project/".substr($name, 0,2)."/".$name."\n";

