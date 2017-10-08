#!/usr/bin/perl

sub related()
{
########################################################################
print <<EOF
#������Բο� /bin/guestmount_usage.pl  ���÷�.
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
#qcow2��ʽ
#����qcow2��ʽ��Ҫʹ��qemu-nbd�������
modprobe nbd max_part=63

#�����LVM��ʽ�ľ���
vgscan
vgchange -ay #���� volname Ϊ "LogVolName"
mount /dev/VolGroupName/LogVolName /mnt/image

#���ʹ�ý������ͷ���Դ��
umount /mnt/image
vgchange -an VolGroupName

killall qemu-nbd
kpartx -d /dev/loop0
losetup -d /dev/loop


