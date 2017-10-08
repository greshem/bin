#!/usr/bin/perl

for(glob("*.img"))
{
	deal_with_img($_);
}


sub deal_with_img($)
{
	(my $line)=@_;
	($name)=($line=~/(.*).img/i);	
	
	do("/bin/rand_mac_string.pl");
	$rand_mac= rand_mac_str();
	$usb_mouse_str=  "-usb -usbdevice tablet";
	$net_str=  "-net nic,macaddr=$rand_mac  -net tap ";
	
	print "qemu-kvm -hda $line   -m 512  -localtime    -snapshot   $usb_mouse_str  $net_str  -vnc 0.0.0.0:0  -vga qxl -spice port=5924,disable-ticketing \n";

	print "#client: spicec -h ip_address -p port \n";

}

__DATA__
qemu-kvm -hda rhel5_1_server-i386-dvd.img    -m 512  -localtime    -snapshot   -usb -usbdevice tablet  -net nic,macaddr=DC:0E:5A:D7:E8:0D  -net tap        -vga qxl -spice port=5924,disable-ticketing                 

