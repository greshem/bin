#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
my $count=0;
for $each (glob("*.img"))
{
	$count++;
	($name)=($each=~/(.*)\.img/);
	if(! -d "/mnt/".$name)
	{
		print "mkdir /mnt/$name\n";
		mkdir("/mnt/$name");
	}
	
	print "guestmount -a  $each  -m /dev/vda${count}   --rw  /mnt/$name \n" 
}
__DATA__
#qcow 的挂载  guestmount 就可以用了.
yum install libguestfs-tools  guestfish libguestfs-mount
########################################################################
#For a typical Windows guest which has its main filesystem on the first partition:
guestmount -a windows.img -m /dev/sda1 --ro /mnt

########################################################################
#For a typical Linux guest which has a /boot filesystem on the first partition, and the root filesystem on a logical volume:
 guestmount -a linux.img -m /dev/VG/LV -m /dev/sda1:/boot --ro /mnt

########################################################################
#To get libguestfs to detect guest mountpoints for you:
 guestmount -a guest.img -i --ro /mnt

########################################################################
#For a libvirt guest called "Guest" you could do:
 guestmount -d Guest -i --ro /mnt

########################################################################
#If you don't know what filesystems are contained in a guest or disk image, use virt-filesystems(1) first:
 virt-filesystems MyGuest

########################################################################
#If you want to trace the libguestfs calls but without excessive debugging information, we recommend:
 guestmount [...] --trace /mnt

#########################################################################
#If you want to debug the program, we recommend:
 guestmount [...] --trace --verbose /mnt

#以v开头的估计是 虚拟磁盘的意思 别的磁盘/dev/sdb 还不让挂.
guestmount -a /var/lib/libvirt/images/f13_kgdb_.img -m /dev/vda1   --rw  /mnt/f13/                          

