#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__

system-config-display --reconfig  --set-resolution=800x600
system-config-display --reconfig  --set-resolution=1024x768


