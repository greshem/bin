#!/usr/bin/perl
$file=shift or die("Usage; $0 input.conf\n");

system(" grep -v \"^#\"  $file  |uniq  ");
