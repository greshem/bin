#!/usr/bin/perl 
#use strict;
#use warnings;
@info=qw( scanning 	  frequency channel bitrate rate encryption keys power txpower retry ap accesspoints peers event auth wpakeys genie modulation );



for (@info)
{
	print "iwlist wlan0 ".$_."\n";
}
