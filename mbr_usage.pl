#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__
#==========================================================================
dd if=/dev/sda of=mbr_boot_sector.bin bs=512 count=1
objdump -D -m i8086 -b binary --start-address=0x3E mbr_boot_sector.bin
objdump  -M intel -D -m i8086 -b binary --start-address=0x3E mbr_boot_sector.bin
 
