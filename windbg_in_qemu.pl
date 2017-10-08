#!/usr/bin/perl 

print <<EOF
qemu-kvm -hda winxp_sp2.img   -m 512  -localtime    -snapshot   -usb -usbdevice tablet  -net nic,macaddr=DC:0E:F9:82:D5:F6  -net tap   -vnc 0.0.0.0:10 -serial tcp::4445,server,nowait &
qemu-kvm -hda winxp_sp2.img   -m 512  -localtime    -snapshot   -usb -usbdevice tablet  -net nic,macaddr=DC:0E:F9:82:D5:F7;  -net tap   -vnc 0.0.0.0:11 -serial tcp:127.0.0.1:4445 	&
EOF
;

#==========================================================================
# 用这样的方式先测试一下 有没有问题.



