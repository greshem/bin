#!/usr/bin/perl

my $file=shift or die("usage: $0 iput_.iso \n");
  
use DVD::Read::Dvd;
         my $dvd = DVD::Read::Dvd->new($file);
         print $dvd->volid;
