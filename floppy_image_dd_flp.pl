#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__


dd if=/dev/zero of=floppy.img bs=1474560 count=1
dd if=/dev/zero of=floppy.img bs=512 count=2880
dd if=/dev/zero of=floppy.img bs=1024 count=1440

#mkdosfs -F 12 floppy.img  #��windows �Զ���װʹ�õ�  floopy �ľ���  cf.pl winnt.sif 
