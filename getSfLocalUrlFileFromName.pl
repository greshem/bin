#!/usr/bin/perl
$name=shift or die("usage: $0 name\n");
print  "/tmp3/sf_mirror/".substr($name, 0, 1)."/".substr($name, 0,2)."/".$name."\n";

