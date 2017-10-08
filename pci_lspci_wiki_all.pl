#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__
#1. virsh, list all the 
qemu-monitor-command   winxp_ddk3790    --hmp  info pci

#==========================================================================
qemu cli # assign pci driver in  qemu cli 

#==========================================================================
yum install  dmidecode.x86_64
lspci
lspci  -v -n > pci_raw_vendor
lspci -v 	 > pci_decode_vendor
vimdiff pci_raw_vendor  pci_decode_vendor	#and then you can figour out , vendor and it's id.

#==========================================================================
#4. inf, windows
devcon 
[\ControlSet001\Control\DeviceClasses\##?#PCI#VEN_15AD&DEV_0405&SUBSYS_040515AD&REV_00#3&61aaa01&0&78#] #windows pci vendor  format.
#15ad VMware, 0405 SVGA II Adapter,   

#==========================================================================
#dmidecode

#==========================================================================
#rpm -ql hwdata
#/usr/share/hwdata/pci.ids	#all the factory in list.


