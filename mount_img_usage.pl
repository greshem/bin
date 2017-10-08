#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}

print "########################################################################\n";
@imgs=glob("*.img");
push(@imgs, glob("*.IMG"));
for (@imgs )
{
	$name=$_;
	$name=~s/\.img//g;
	$name=~s/\.IMG//g;
	print "mkdir  /mnt/$name \n";
	if((-s $_) > 1024*1024*4) #4m大小为分界线.
	{
		$feature_str=`file $_`;
		if($feature_str=~/data/i)
		{
			print "mount -t ntfs  -o loop,offset=\$((64*512))  	$_   	/mnt/$name/ \n";
		}
		else
		{
			print "mount -t ntfs  -o loop,offset=\$((63*512))  	$_   	/mnt/$name/ \n";
		}
	}
	else
	{
		print "mount -t vfat  $_ /mnt/$name/ #软盘 镜像\n";
	}

}
__DATA__

1. 建立磁盘.
qemu-img create windows7.img 10G
qemu-kvm -m 512m -hda windows7.img -cdrom /tmp2/cn_windows_7_ultimate_x86_dvd_x15-65907.iso -boot d -m 512 -localtime -vnc 192.168.1.73:4  -daemonize  

 
2. 分析磁盘
	fdisk -l windows7.img  -u
	#       Device Boot      Start         End      Blocks   Id  System
	#windows7.img1   *        2048      206847      102400    7  HPFS/NTFS
	#windows7.img2          206848    20969471    10381312    7  HPFS/NTFS

	1.  losetup /dev/loop0 windows7.img
	2. fdisk -l -u /dev/loop0  #就可以看到里面的分区的信息了.
	
这里获取到的offset= 206848*512
3. mount -t ntfs  -o loop,offset=206848*512 windows7.img /mnt/tmp/
	mount -t ntfs  -o loop,offset=105906176  windows7.img /mnt/tmp/
	就可以在 /mnt/tmp/目录下 修改对应的文件系统了.

mkdir /mnt/windows2000/
mkdir /mnt/windowsxp/
mkdir /mnt/windows2003/
mkdir /mnt/windows7/
mkdir /mnt/f8/

mount -t ntfs  -o loop,offset=$((63*512))  	windows2000.img  	/mnt/windows2000/
mount -t ntfs  -o loop,offset=$((63*512))  	windowsxp.img   	/mnt/windowsxp/
mount -t ntfs  -o loop,offset=$((63*512))  	windows2003.img  	/mnt/windows2003/
mount -t ntfs  -o loop,offset=105906176 	windows7.img 		/mnt/windows7/
mount -t ext3  -o loop,offset=$((63*512))  	f8.img  			/mnt/f8/

#==========================================================================
richdisk  63+1
mount -t ext3  -o loop,offset=$((64*512))  	richdisk.img  			/mnt/richdisk/
