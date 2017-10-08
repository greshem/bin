#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__
brctl addbr br0
tunctl -t tap0
brctl addif br0 tap0
tunctl -t tap99
brctl addif br0 tap99

brctl show 			#list


brctl delif br19 tap19

