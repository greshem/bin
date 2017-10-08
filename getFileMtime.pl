#!/usr/bin/perl
$file=shift or die("Usage $0 file\n");
$mtime=-M $file;
$mtime=int($mtime*24);
print $mtime;
