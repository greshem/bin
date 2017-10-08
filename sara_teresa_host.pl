#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__

162.211.181.182 teresa 
162.211.181.182 teresa 
162.211.181.182 teresa 
162.211.181.182 sara

1. teresa (162.211.181.182) 
 162.211.181.182 teresa 
passwd: Q******************n0**********************3


wget  162.211.181.182
wget  http://www.petty-china.com/
