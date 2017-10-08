#!/usr/bin/perl 
while(<DATA>)
{
	print $_;
}
__DATA__
use SDBM_File;
use Fcntl;
my %a;
tie %a, "SDBM_File", "test.dat",O_CREAT|O_RDWR, 0666 
	or die "count tie SDBM file $!;";

for(1..100)
{
	$a{$_}=rand $_;
}
untie %a;
