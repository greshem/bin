#!/usr/bin/perl
#2012_10_17_05:01:23   ������   add by greshem
#redhat as5.8 ��domain0 ��װcentos 
#bug �ļ�¼.
#1. as5.8  �Ĺ�����VT ��repo�� �� /bin/repo_local_disk_yum.pl ������ֿ� ���뵽 /etc/yum.repos.d/��ȥ.
#2. �����ͻ�os��ʱ�� loop_max=64 ����һ��, ��Ϊxen �ĺܶ��ļ����� loop �豸.
#3. ������ʹ��  ����ļ��ĵ�һ�� ��������ȷ��, �ڶ��� �����loop �豸��.
#		�����豸���� ����ȷʵ��ʾû��  , ��֤һ���ǲ���loop�豸, ���ǿ��豸.
#4. 

#yum install virt*
#yum install xen*
#==========================================================================
#��������.
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
	print "# /etc/xen/centos62_i396_domu �����ɹ�\n";
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
