#!/usr/bin/perl
#==========================================================================
#��صĲο�������.
sub  referrence_notice()
{
	print <<EOF
#���̴���, �ο�  "qemu-img_usage.pl"
#�򵥵��÷� ִ�� ���� "file_type_cmd_dump.pl"
EOF
;
}


$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__


#2. ����
qemu-kvm -hda windows.img -cdrom /dev/acd0 -boot d -m 512 -enable-audio -localtime, 

#3. ���̾�������.
qemu-kvm -hda windows.img -cdrom ghost7.0.iso -boot d -m 512 -enable-audio -localtime, 
qemu-kvm -hda /var/lib/libvirt/images/f8.img -cdrom /media/sdb2/linux_iso_windows/f8_i386.iso -boot d -m 512 -localtime #install

#4. vnc �ض���  �������:
qemu-kvm -hda f13.img -cdrom /tmp2/f13_x86_64.iso   -m 512  -localtime -vnc 0.0.0.0:0  

