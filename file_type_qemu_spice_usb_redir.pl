#!/usr/bin/perl
our $g_port=3;

if( ! -f "/etc/qemu/ich9-ehci-uhci.cfg")
{
	warn("  /etc/qemu/ich9-ehci-uhci.cfg, not exists \n");
	warn(" Please copy it  from qemu-1.5.1.tar.gz. \n");
}
#sub file_type_cmd_dum_lib()
for(glob("*.img"))
{
	deal_with_img($_);
}
for(glob("*.qcow2"))
{
	deal_with_img_windows($_);
}
for(glob("*.vmdk"))
{
	deal_with_img_windows($_);
}

#do("/bin/get_vnc_next_port.pl");
sub get_next_port()
{
	for $each (5900..6100)
	{
		$ret=`lsof -i:$each`;
		if($ret!~/listen/i)
		{
			my $port= ($each-5900);
			#print $port;
			return $port
		}
	}
	return 0;
}

########################################################################
#启动虚拟机.
sub deal_with_img($)
{
	(my $line)=@_;
	($name)=($line=~/(.*).(img|vmdk)/i);	
	
	do("/bin/rand_mac_string.pl");
	$rand_mac= rand_mac_str();
	$usb_mouse_str=  "-usb -usbdevice tablet";
	$net_str=  "-net nic,macaddr=$rand_mac  -net tap ";

	my $port=  get_next_port();
	#print "qemu-kvm -hda $line   -m 512  -localtime    -snapshot   $usb_mouse_str  $net_str  -vnc 0.0.0.0:$g_port\n";

print    <<EOF 
#-readconfig /etc/qemu/ich9-ehci-uhci.cfg 
#-readconfig /etc/qemu/ich9-ehci-uhci.cfg
#-device usb-redir,chardev=usbredirchardev1,id=usbredirdev1,bus=ehci.0,debug=3 -chardev spicevmc,name=usbredir,id=usbredirchardev2  \\
#-device virtio-balloon-pci,id=balloon0,bus=pci.0,addr=0x7  \\
#bus=usb.0
#bus=ehci.0
#bus=pci.0
#

./qemu-kvm  \\
-hdd $line  \\
-m 512   \\
-readconfig /etc/qemu/ich9-ehci-uhci.cfg  \\
-spice port=$g_port,addr=0.0.0.0,disable-ticketing, \\
-vga qxl -global qxl-vga.vram_size=67108864 -device AC97,id=sound0,bus=pci.0,addr=0x4   \\
	\\
-chardev 	spicevmc,name=usbredir,id=usbredirchardev1 \\
-device 	usb-redir,chardev=usbredirchardev1,id=usbredirdev1,bus=ehci.0,debug=3 \\
	\\
-chardev 	spicevmc,name=usbredir,id=usbredirchardev2 \\
-device 	usb-redir,chardev=usbredirchardev2,id=usbredirdev2,bus=ehci.0,debug=3 \\
	\\
-chardev 	spicevmc,name=usbredir,id=usbredirchardev3 \\
-device 	usb-redir,chardev=usbredirchardev3,id=usbredirdev3,bus=ehci.0,debug=3 


EOF
;


	$g_port=$g_port+1;
}


########################################################################
#启动虚拟机 in windows 
sub deal_with_img_windows($)
{
	(my $line)=@_;
	($name)=($line=~/(.*).img/i);	
	
	do("c:\\bin\\rand_mac_string.pl");
	$rand_mac= rand_mac_str();
	$usb_mouse_str=  "-usb -usbdevice tablet";
	$net_str=  "-net nic,macaddr=$rand_mac  -net tap ";

	my $port=  get_next_port();
	print "\"C:\\Program Files (x86)\\qemu\\qemu-system-i386.exe\"     -hda $line   -m 512  -localtime    -snapshot   $usb_mouse_str  $net_str  \n";
	print "\"C:\\Program Files (x86)\\qemu\\qemu-system-x86_64.exe\"   -hda \"$line\"   -m 512  -localtime    -snapshot   $usb_mouse_str  $net_str  \n";
	#$g_port=$g_port+1;
}
