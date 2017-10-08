#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__
1. vim CTRL-E -F 
2. Pagedown 
3. SHIFT_down


