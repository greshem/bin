#!/usr/bin/perl

use Net::servent;
$s = getservbyname(shift || 'ftp') || die "no service";
printf "port for %s is %s, aliases are %s\n",  $s->name, $s->port, "@{$s->aliases}";


comm_usage();

print_with_lsof();

sub get_hostname()
{
	open(FILE, "/etc/sysconfig/network") or die("Open network file error $!\n");
	for(<FILE>)
	{	
		if($_=~/HOSTNAME=(.*)/)
		{
			return $1;	
		}
	}
	return "127.0.0.1";
}
#==========================================================================
sub print_with_lsof()
{
	
	print "#========================================================================== \n";
	$hostname=get_hostname();
	print "lsof -i:5900-6000\n";
	open(CMD, " lsof -i:5900-6000 | ") or die("create pipe error $!\n");
	for(<CMD>)
	{
		if($_=~/.*\:(\S+)\s+\(LISTEN.*/i)
		{
			$port_str=$1;
			if($port_str=~/\d+/)
			{
				print "vncviewer  $hostname:$port_str & \n";
			}
			else
			{
				$s = getservbyname($port_str); 
				$port=$s->port;
				#printf "port for %s is %s, aliases are %s\n",  $s->name, $s->port, "@{$s->aliases}";
				print "vncviewer  $hostname:$port & \n";
			}
		}
	}
}

sub comm_usage()
{
	$pattern=shift;
	foreach (<DATA>)
	{
		print $_ if($_=~/$pattern/i);
	}
}
__DATA__
#windows platform
mstsc.exe
redesktop.exe
bukwq
http://rdpdesk.com/distribs/RDPDesk_3.3.0_win32_enterprise.exe

#==========================================================================
vncviewer  127.0.0.1:5901
vncviewer  172.16.10.243:5901
remmina  	#177 xdmcp
vncserver 	# vino
xfreerdp 	# freerdp.x86_64
gnome-rdp 	# gnome-rdp
rdesktop 	# rdesktop 
xrdp		# xrdp server 
gtk-vnc		#

#==========================================================================
#当 鼠标焦点 不正确的时候 可以选用   下面的客户端 , 最后的解决方式是 -usb -usbdevice tablet
yum install  vinagre
vinagre  172.16.10.243:5902


#==========================================================================
#使用spice
#yum -y install spice-client
#Linux 下使用spicec命令连接：
/usr/libexec/spicec -h 192.168.0.13 -p 5930 -w password

remmina
#==========================================================================
#KDE Desktop Sharing (formerly known as krfb)
krfb 
client as 'krdc' 
server as 'krfb'. 
yum install kdenetwork-krdc
yum install kdenetwork-krfb

#==========================================================================
#/usr/share/doc/vino-3.2.1/remote-desktop.txt
vino

#==========================================================================
yum install telepathy*

#==========================================================================
#NX
yum install freenx-client freenx-server 
nxcl
qtnx


