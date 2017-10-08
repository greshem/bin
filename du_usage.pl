#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__
du --max-depth=1 -h
du --max-depth=1 
du_notHiden.pl

#exclude
du -h --exclude=mnt --max-depth=1
