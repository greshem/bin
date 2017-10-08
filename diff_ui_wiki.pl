#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__
kdiff3 %s1 %s2 %t
meld.noarch
xxdiff.x86_64
 beediff 


