#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__
qemu-system-mips -kernel vmlinux -hda clfs-ppc-hd.img -append "root=/dev/hda1 console=tty"
"cosole=ttyS0,38400n8r"
-net none -serial pty 
-serial /dev/ttyS2

#==========================================================================
-serial tcp::4445,server,nowait
-serial tcp:127.0.0.1:4445
