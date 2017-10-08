#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__

cat INSTALL/configure.html  |grep "<code>" |sed 's/</\n/g'  |sed 's/>/\n/g'  |sort -n  |grep ^- |sort  |uniq -c  |sort -n 

