#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__

#win7
ie.pl "C:\\Windows\\System32\\drivers\\etc"

#winxp 
ie.pl "C:\\WINDOWS\\system32\\drivers\\etc"

#win2000
ie.pl "c:\\WINNT\\systm32\\dirvers\\etc"




