#!/usr/bin/perl
foreach (<DATA>)
{
	print $_;
}
__DATA__

virsh -c qemu:///system list
