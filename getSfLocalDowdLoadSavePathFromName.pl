#!/usr/bin/perl
$name=shift or die("usage: $0 name\n");
print  "/tmp5/sf_all_download/SF_MIRROR_img/".substr($name, 0, 1)."/".substr($name, 0,2)."/".$name."\n";

