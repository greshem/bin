#!/usr/bin/perl
our $g_port=3;

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
	print "qemu-kvm -hda $line   -m 512  -localtime    -snapshot   $usb_mouse_str  $net_str  -vnc 0.0.0.0:$g_port\n";
	$g_port=$g_port+1;
}


########################################################################
#启动虚拟机 in windows 
sub deal_with_img_windows($)
{
	(my $line)=@_;
	($name)=($line=~/(.*).img/i);	
	
	if($^=~/win/i)
	{
		do("c:\\bin\\rand_mac_string.pl");
	}
	else
	{
		do("/bin/rand_mac_string.pl");
	}
	$rand_mac= rand_mac_str();
	$usb_mouse_str=  "-usb -usbdevice tablet";
	$net_str=  "-net nic,macaddr=$rand_mac  -net tap ";

	my $port=  get_next_port();
	print "\"C:\\Program Files (x86)\\qemu\\qemu-system-i386.exe\"     -hda $line   -m 512  -localtime    -snapshot   $usb_mouse_str  $net_str  \n";
	print "\"C:\\Program Files (x86)\\qemu\\qemu-system-x86_64.exe\"   -hda \"$line\"   -m 512  -localtime    -snapshot   $usb_mouse_str  $net_str  \n";
	#$g_port=$g_port+1;
}
