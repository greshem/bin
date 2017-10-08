#!/usr/bin/perl

sub related()
{
########################################################################
print <<EOF
#另外可以参看 /bin/guestmount_usage.pl  的用法.
yum install libguestfs*
yum install guestfish
guestmount -a /var/lib/libvirt/images/f13_kgdb_.img -m /dev/vda1   --rw  /mnt/f13/                          

EOF
;
}


@imgs=glob("*.img");
push(@imgs, glob("*.IMG"));
push(@imgs, glob("*.vmdk"));

for (@imgs )
{
	$name=$_;
	$name=~s/\.img//g;
	$name=~s/\.IMG//g;
	print "mkdir  /mnt/$name \n";

	my $feature_str=`file $_`;
	if($feature_str=~/qcow|vmdk/i)
	{
		print "qemu-nbd -c /dev/nbd0 ${name}.img  \n";
		print "mount /dev/nbd0p1 /mnt/$name \n";
	}
}

__DATA__
########################################################################
#qcow2格式
#对于qcow2格式需要使用qemu-nbd这个工具
modprobe nbd max_part=63

#如果是LVM格式的镜像：
vgscan
vgchange -ay #最后的 volname 为 "LogVolName"
mount /dev/VolGroupName/LogVolName /mnt/image

#最后使用结束需释放资源：
umount /mnt/image
vgchange -an VolGroupName

killall qemu-nbd
kpartx -d /dev/loop0
losetup -d /dev/loop


