#!/usr/bin/perl 
#use strict;
#use warnings;

@files = glob("/root/_pre_cache*.iso");
my @filesSort= sort{-M $a <=> -M $b} @files;

my $iso=shift @filesSort;
print "#Latest: ".$iso."\n";

print "mount -t iso9660 $iso  /root/_pre_cache/  \n";

