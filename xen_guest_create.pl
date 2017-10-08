#!/usr/bin/perl
#2012_10_17_05:01:23   星期三   add by greshem
#redhat as5.8 下domain0 安装centos 
#bug 的记录.
#1. as5.8  的光盘有VT 的repo， 用 /bin/repo_local_disk_yum.pl 把这个仓库 导入到 /etc/yum.repos.d/中去.
#2. 启动客户os的时候 loop_max=64 设置一下, 因为xen 的很多文件都是 loop 设备.
#3. 光驱的使用  这个文件的第一版 可能是正确的, 第二版 变成了loop 设备了.
#		假如设备有了 但是确实提示没有  , 验证一下是不是loop设备, 还是块设备.
#4. 

#yum install virt*
#yum install xen*
#==========================================================================
#创建磁盘.
sub create_disk_and_swap()
{

	#Or, you can use qemu-img utility to replace dd:
	mkdir ("/tmp/xen/");
	if( -f "/usr/bin/qemu-kvm")
	{
		print "qemu-img create -f raw /tmp/xen/centos6.img 8G \n";
		print "qemu-img create -f raw /tmp/xen/centos6.swp 512M \n";
	}
	else
	{
		print "dd if=/dev/zero of=/tmp/xen/centos6.img bs=4K count=0 seek=2048K \n";
		print "dd if=/dev/zero of=/tmp/xen/centos6.swp bs=4K count=0 seek=128K \n";
	}

}

sub mount_centos_62_iso()
{
	print "mount  -t iso9660  /dev/cdrom /tmp/dir  \n";
	
}

sub create_xen_config()
{
	open(FILE, "> /etc/xen/centos62_i396_domu") or die("create file error $!\n");;
	print FILE <<EOF

kernel = "/tmp/dir/isolinux/vmlinuz"
ramdisk = "/tmp/dir/isolinux/initrd.img"
name = "xc6"
memory = "512"
disk = [ "file:/tmp//xen/centos6.img,xvda,w","file:/tmp/xen/centos6.swp,xvdb,w",  'file:/tmp/centos_62_i386.iso,xvde:cdrom,r'   ]
#vif = [ "bridge=br0" ]
vcpus = 1
on_reboot = "destroy"
on_crash = "destroy"
EOF
;
	print "# /etc/xen/centos62_i396_domu 创建成功\n";
}



sub start_xen()
{
	print "xm create centos62_i396_domu \n";
	print "xm console xc6 \n";
}
########################################################################
#mainloop
create_disk_and_swap();
mount_centos_62_iso();
create_xen_config();
start_xen();
