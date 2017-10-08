#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__
rm -f /dev/cdrom 
ln -s /dev/cdrom1 /dev/cdrom

wxwidget_diskplat_install.pl

