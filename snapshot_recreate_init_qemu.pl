#use strict;
#use warnings;
use File::Basename;

#格式如下.
#as5_8.img:                                      QEMU QCOW Image (v2), has backing file (path /var/lib/libvirt/images/redhat_as5/as5_8.img), 10737418240 bytes
@imgs=`file *.img `;
for (@imgs)
{
	chomp($_);
	#print $_."\n";
	if($_=~/(.*):.*backing.*path\s+(\/.*\.img).*/)
	{
		$name=$1;
		$abs_path=$2;
		print "qemu-img create 	-b  $abs_path  -f qcow2  $name  \n";
	}
}

