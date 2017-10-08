#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__
/bin/q_mkisofs.sh
cdrdao
cdrecord
genisoimage
growisofs
icedax
k3b --help #k3b cmdline
mkisofs
readom
wodim


