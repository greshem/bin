#!/usr/bin/perl
#img_qcow2_nbd_lvm_qemu.pl  
my $img=shift or die("Usage: $0 input.img \n");


(my $name,)=($img=~/(.*)\.img/);
#nbd_connect_bench_with_vg($name);
nbd_connect_bench($name);

sub nbd_connect_bench_with_vg()
{
	(my $name)=@_;
	print <<EOF
mkdir  /mnt/$name 
qemu-nbd -c /dev/nbd0 $name.img  
mount /dev/nbd0p1 /mnt/$name 
fdisk  -l /dev/nbd0 

#---------------------------------
#with vg  
kpartx -av /dev/nbd0
find  /dev/mapper/ |grep nbd0p1
vgchange  -ay 
cd /dev/VolGroup00/
#fdisk -l ../dm-3 
#fdisk -l ../dm-2 
readlink //dev/mapper/nbd0p1
readlink //dev/mapper/nbd0p2
mkdir /tmp/dm-{0,1,2,3,4}
mount -t ext4 /dev/dm-0  /tmp/dm-0
mount -t ext4 /dev/dm-1  /tmp/dm-1
mount -t ext4 /dev/dm-2  /tmp/dm-2
mount -t ext4 /dev/dm-3  /tmp/dm-3
mount -t ext4 /dev/dm-4  /tmp/dm-4
#ls
#cat etc/issue
#cd ..
umount /tmp/dm-{0,1,2,3,4}
vgchange  -an VolGroup00 

kpartx -d /dev/nbd0
#---------------------------------

qemu-nbd -d /dev/nbd0 

EOF
;
}

print "#end==========\n";

sub nbd_connect_bench($)
{
	(my $img_name)=@_;
	print<<EOF
while [ 1 ];
do
	QEMU_NBD="/opt/qemu-1.1.2/bin/qemu-nbd";
	#QEMU_NBD="/opt/qemu-1.2.0/bin/qemu-nbd";
	#QEMU_NBD="/opt/qemu-1.3.1/bin/qemu-nbd";
	#QEMU_NBD="qemu-nbd";                  #1.5  qemu
	\$QEMU_NBD  -c /dev/nbd7 $img_name.img
	cat /dev/nbd7 > /dev/null
	\$QEMU_NBD -d /dev/nbd7
done
EOF
;
}
