#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__
#==========================================================================
#server
cd /root/usbip_2.6.32_src
#drivers/staging/usbip/
insmod usbip_common_mod.ko
insmod usbip.ko #(stub.ko)

cd /root/usbip-0.1.7/src/cmd/
./usbipd -D 
./bind_driver --list
./bind_driver --usbip  1-1.4

 cat /sys/bus/usb/drivers/usbip/match_busid

#==========================================================================
#client
cd /root/usbip_2.6.32_src
insmod usbip_common_mod.ko
insmod vhci-hcd.ko

cd /root/usbip-0.1.7/src/cmd
./usbip --list 172.16.10.64
./usbip --attach 172.16.10.64  1-1.4 
./usbip --port
./usbip --detach 0  #delete 

