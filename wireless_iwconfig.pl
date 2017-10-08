#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__

modprobe rt73usb
ifconfig wlan0 up
iwconfig wlan0 channel 11
iwconfig wlan0 channel 11
iwconfig wlan0 essid "dlink_qian" key "11111111111111111111111111"			#wep 256 bit

iwconfig wlan0 essid "TP-LINK_F3AAE0" key  3131-3131-3131-3131-3131-3131-31 #wep 128 bit
iwconfig wlan0 essid "TP-LINK_F3AAE0" key s:61203003 						#error wep not support eight chars auth.
iwlist wlan0 scan
dhclient wlan0


iwconfig wlan0 key 0123-4567-89
iwconfig wlan0 key [3] 0123-4567-89
iwconfig wlan0 key s:password [2] 
iwconfig wlan0 key [2]
iwconfig wlan0 key open
iwconfig wlan0 key off
iwconfig wlan0 key restricted [3] 0123456789
iwconfig wlan0 key 01-23 key 45-67 [4] key [4]1
