#!/usr/bin/perl 
#use strict;
#use warnings;
# cache 的方式.
# ovs  的检测
# 

use Cwd;
use File::Basename;

our $g_pwd=getcwd();
our $g_basename=basename($g_pwd);
our $g_dirname=dirname($g_pwd);


system(" python -m SimpleHTTPServer 33445 /var/www/html/   & ");


do("/root/bin/rand_mac_string.pl");


our $g_iso_name=shift or die("usage: $0 input.iso  [output_dir] \n");
our $g_output_dir=shift ;
if(! defined($g_output_dir))
{
	$g_output_dir="/vmstorage/";
}
our $g_cdrom_abs_path;


my  $name=$g_iso_name;
$name=~s/\.iso$//;

if($name=~/^\//)
{
	$name=basename($name);
	$g_cdrom_abs_path=$g_iso_name;
}
else
{
	$g_cdrom_abs_path=$g_pwd."/".$g_iso_name;
}

my  $rand_mac= rand_mac_str();

our $g_usb_mouse_str=  "-usb -usbdevice tablet";
our $g_img_name=$name.".img";
our $g_net_str=  "-net nic,macaddr=$rand_mac  -net tap,ifname=$name";

if($g_cdrom_abs_path=~/rhel|centos|redhat|fedora/i)
{
	iso_2_img_with_rhel_vmlinuz($name);
	qemu_start($name);

}
elsif($g_cdrom_abs_path=~/debian|ubuntu/i)
{
	iso_2_img_with_debian_vmlinuz($name);
}
else
{
	iso_2_img_with_rhel_vmlinuz($name);
	qemu_start($name);
}


if( -f "$g_output_dir/install.sh")
{
	system("cp    $g_output_dir/install.sh    $g_output_dir/install_$name.sh   ");
	system("bash  $g_output_dir/install.sh");
}
else
{
	system("cp    $g_output_dir/install.sh    $g_output_dir/install_$name.sh   ");
}

#iso_2_img_with_qemu($name);
#iso_2_img_with_virtsh($name);

sub iso_2_img_with_rhel_vmlinuz($)
{
	(my $name)=@_;
	open(FILE,  ">$g_output_dir/install.sh") or die("create output $g_output_dir/install.sh error \n");

	select(FILE);

	my  $my_ip=get_my_ip();
	print FILE   <<EOF
	set -x 
	mkdir dir/ 
	mount -t iso9660 $g_cdrom_abs_path   dir -o loop 
	cp -a -r dir/isolinux/* /tmp/


	#dd if=/dev/zero of=floppy_$g_img_name bs=1024 count=1440 
	#mkdosfs -F 12 floppy_$g_img_name
	#-fda  floppy_$g_img_name 				\\

	/bin/get_ks_file_from_iso_name.pl $g_cdrom_abs_path  |sh 
	qemu-img create -f qcow2 $g_output_dir/$g_img_name  40g
	qemu-system-x86_64   -kernel /tmp/vmlinuz  -initrd /tmp/initrd.img  -append "ks=http://$my_ip:33445/ks.cfg"   \\
	-smp 2,sockets=2,cores=1,threads=1   \\
	-cdrom   $g_cdrom_abs_path   			\\
	-hda 	$g_output_dir/$g_img_name    	\\
	-net nic,vlan=0 -net user,vlan=0 \\
	-enable-kvm  -no-reboot   -usb -usbdevice tablet  -m 1024   -vnc :0 

	#-serial stdio -append "console=ttyS0" \\

	umount dir/
EOF
;
	select(STDOUT);
	close(FILE);

}

sub qemu_start($)
{
	(my $name)=@_;
	open(FILE,  ">$g_output_dir/start_$name.sh") or die("create output $g_output_dir/install.sh error \n");

	select(FILE);

	print FILE   <<EOF
	set -x 

	qemu-system-x86_64   \\
	-cdrom   $g_cdrom_abs_path   			\\
	-hda 	$g_output_dir/$g_img_name    	\\
	-net nic,vlan=0 -net user,vlan=0 \\
	-enable-kvm  -no-reboot   -usb -usbdevice tablet  -m 1024   -vnc :0

	umount dir/
EOF
;
	select(STDOUT);
	close(FILE);
}


sub iso_2_img_with_debian_vmlinuz($)
{
	(my $name)=@_;
	open(FILE,  ">$g_output_dir/install.sh") or die("create output $g_output_dir/install.sh error \n");

	select(FILE);

	print FILE   <<EOF
	set -x 
	mkdir dir/ 
	mount -t iso9660 $g_cdrom_abs_path   dir -o loop 
	cp -a -r \$( find dir/ |grep vmlinuz)  /tmp/
	cp -a -r \$( find dir/ |grep initrd.gz)  /tmp/


	dd if=/dev/zero of=$g_output_dir/floppy_$g_img_name bs=1024 count=1440 
	mkdosfs -F 12 $g_output_dir/floppy_$g_img_name

	qloop.sh  $g_output_dir/floppy_$g_img_name
	cp /root/bin/kickstart/preseed_ubuntu.cfg  dir/preseed.cfg
	umount dir/


	/bin/get_ks_file_from_iso_name.pl $g_cdrom_abs_path  |sh 


	qemu-img create -f qcow2 $g_output_dir/$g_img_name  40g
	qemu-system-x86_64   -kernel /tmp/vmlinuz  -initrd /tmp/initrd.gz   \\
	-append "  auto preseed/file=/floppy/preseed.cfg automatic-ubiquity noprompt priority=critical locale=en_US console-setup/modelcode=evdev"   \\
	-cdrom   $g_cdrom_abs_path   			\\
	-hda 	$g_output_dir/$g_img_name    	\\
	-fda  $g_output_dir/floppy_$g_img_name 				\\
	-enable-kvm  -no-reboot   -usb -usbdevice tablet  -m 1024   -vnc :0

	umount dir/
EOF
;
	select(STDOUT);
	close(FILE);
}


sub iso_2_img_with_qemu($)
{
	(my $name)=@_;
	print "\n#========================================================================== \n";
	#顺便创建一下img
	if(! -f  $g_img_name)
	{
		print "qemu-img create -f qcow2 $g_img_name  40g\n";
	}
	else
	{
		print "#qemu-img create -f qcow2 $g_img_name  40g\n";
	}

	$img_str="-drive file=$g_img_name,cache=writeback";
	#光盘安装.
	print "qemu-system-x86_64   -enable-kvm  -cdrom $g_pwd/$g_iso_name   $img_str   -m 512  -localtime   $g_usb_mouse_str  $g_net_str  -vnc 0.0.0.0:0\n"; 
	print "#ovs-vsctl del-port      br100 $name \n";
}


sub iso_2_img_with_virtsh($)
{
	(my $name)=@_;
	print "\n#========================================================================== \n";
	print "#install via  virt-install \n";
print <<EOF
qemu-img create -f qcow2 $g_img_name  40g\
virt-install  --name $name --ram 512  --vcpus=1  --accelerate  \\
 --network bridge=br0		\\
--disk path=$g_img_name,size=20,format=qcow2  \\
--cdrom $g_iso_name \\
--graphics vnc
EOF
;

}

sub get_my_ip()
{
	my $str=`hostname -I `;
	my @array=split(/\s+/, $str);
	return $array[0];
}
