#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__
dd if=rich_img_vmware.img of=rich_img_vmware_raw.img bs=512 skip=1  #chagne rich to raw 
split_to_dd.pl														#	 
createFileLength_v3.pl												#

ddrescue.x86_64 
dd_rescue.x86_64 

dd if=/dev/sdc  of=/tmp/tmp bs=512 count=1 			#mbr 数据,  512 
dd if=/dev/sda  of=skip_2_sector  bs=512 skip=2   	#skip  越过. 

dd if=/dev/cdrom of=/dev/null  count=1024 bs=1k     #cdrom 的读取 用于 光盘的挂载动作.  1M 数据读取.

dd if=/dev/zero  of=jfs.img  bs=512 count=1    	#随机 破坏. fsck,  大小 也是512字节.


#第一块 扇区 清空  或者 随机.
{
	dd if=/dev/zero  of=output.img  bs=512 count=1     #大小有问题 只有512字节
	dd if=jfs.img    of=output.img bs=512 skip=1 seek=1
}

#floppy 软盘 镜像的生成
{
dd if=/dev/zero of=floppy.img bs=1474560 count=1
dd if=/dev/zero of=floppy.img bs=512 count=2880
dd if=/dev/zero of=floppy.img bs=1024 count=1440
dd if=/dev/fd0 of=disk.img count=1 bs=1440k  	 	#floppy  copy 
}

develop_cpp/range_split_dd.cpp  #一个文件分割成 中间一个小文件, 便于修改. dd 的wrapper


split -a 4 -b 4096 -d output  block.  # 把一个文件 分割成 4k 文件簇 ,  用dd 顺序 skip 递增 

dd if=input.nrg of=output.iso  bs=512 skip=600  #nero 光盘 转换. 

 dd if=hd2_usr.jfs2  of=hd2_usr.jfs2.output bs=512 skip=64  #jfs2 lvm LVCB 的 skip, 64个扇区.

dd if=/dev/zero of=output.img bs=8092  count=131072  		#1G 1024M
dd if=/dev/zero of=output.img bs=8092  count=$((1024*128))  #1G 1024M

dd if=/dev/zero of=output.img bs=8092  count=$((1024*256))  #2G 

dd if=/dev/zero of=output.img bs=8092  count=$((1024*512))  #4G 

dd if=/dev/zero of=output.img bs=8092  count=$((1024*1024))  #8G 

killall -SIGUSR1 dd  #process  
#/root/develop_perl/split_to_dd_0.pl 
