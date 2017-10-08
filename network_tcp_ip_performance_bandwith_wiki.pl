#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__
/etc/xinetd.d/nuttcp
nttcp
ttcp

iperf
uperf

nload
nperf

