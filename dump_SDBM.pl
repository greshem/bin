#!/usr/bin/perl
use SDBM_File;

my $data=$ARGV[0] or die("Usage: $0 database\n");
my %Hashfile;
 tie(%Hashfile,'SDBM_File', $data, O_WRONLY|O_CREAT, 0600)
	or die "open dbfile error\n";

foreach (keys %Hashfile)
{
	print $_ ,"\t\t-->", $Hashfile{$_},"\n";
}
print "success \n";

