#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__
#get host ip 
hivexregedit --export SYSTEM   \\ControlSet001\\Services\\Tcpip   >/tmp/tcpip.reg
##############################
#for  rich_img_VMWARE.gz 
mkdir /mnt/richdisk
mkdir /mnt/hhhhdisk
mount -t ntfs-3g  -o loop,offset=$((64*512))  		richdisk.IMG 		/mnt/richdisk
mount -t ntfs-3g  -o loop,offset=$((64*512))  	hhhhdisk.IMG   		/mnt/hhhhdisk

cd /mnt/hhhhdisk/WINDOWS/system32/config/
hivexregedit --export System  \\ControlSet001\\Services\\hhhhdisk >  /tmp/hhhhdisk.reg 
hivexregedit --export System  \\ControlSet001\\Services\\hhhhndis >  /tmp/hhhhndis.reg 

cd /mnt/richdisk/WINDOWS/system32/config/
hivexregedit --export System  \\ControlSet001\\Services\\richdisk >  /tmp/richdisk.reg 
hivexregedit --export System  \\ControlSet001\\Services\\richndis >  /tmp/richndis.reg 

# port
# 0x0d05 3333
# 7495  1d47
#==========================================================================
#ipAddr
#31,00,39,00,32,00,2e,00,31,00,36,00,38,00,2e,00,32,00,31,00,2e,00,31,00,37,00,38,00,00,00
#1      9     2    .     1      6     8    .     2      1    .      1     7     8
hivexregedit --merge  System <  /tmp/hhhhdisk.reg 
hivexregedit --merge  System <  /tmp/hhhhndis.reg 

hivexregedit --merge  System <  /tmp/richdisk.reg 
hivexregedit --merge  System <  /tmp/richndis.reg 


