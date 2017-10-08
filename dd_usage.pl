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

dd if=/dev/sdc  of=/tmp/tmp bs=512 count=1 			#mbr ����,  512 
dd if=/dev/sda  of=skip_2_sector  bs=512 skip=2   	#skip  Խ��. 

dd if=/dev/cdrom of=/dev/null  count=1024 bs=1k     #cdrom �Ķ�ȡ ���� ���̵Ĺ��ض���.  1M ���ݶ�ȡ.

dd if=/dev/zero  of=jfs.img  bs=512 count=1    	#��� �ƻ�. fsck,  ��С Ҳ��512�ֽ�.


#��һ�� ���� ���  ���� ���.
{
	dd if=/dev/zero  of=output.img  bs=512 count=1     #��С������ ֻ��512�ֽ�
	dd if=jfs.img    of=output.img bs=512 skip=1 seek=1
}

#floppy ���� ���������
{
dd if=/dev/zero of=floppy.img bs=1474560 count=1
dd if=/dev/zero of=floppy.img bs=512 count=2880
dd if=/dev/zero of=floppy.img bs=1024 count=1440
dd if=/dev/fd0 of=disk.img count=1 bs=1440k  	 	#floppy  copy 
}

develop_cpp/range_split_dd.cpp  #һ���ļ��ָ�� �м�һ��С�ļ�, �����޸�. dd ��wrapper


split -a 4 -b 4096 -d output  block.  # ��һ���ļ� �ָ�� 4k �ļ��� ,  ��dd ˳�� skip ���� 

dd if=input.nrg of=output.iso  bs=512 skip=600  #nero ���� ת��. 

 dd if=hd2_usr.jfs2  of=hd2_usr.jfs2.output bs=512 skip=64  #jfs2 lvm LVCB �� skip, 64������.

dd if=/dev/zero of=output.img bs=8092  count=131072  		#1G 1024M
dd if=/dev/zero of=output.img bs=8092  count=$((1024*128))  #1G 1024M

dd if=/dev/zero of=output.img bs=8092  count=$((1024*256))  #2G 

dd if=/dev/zero of=output.img bs=8092  count=$((1024*512))  #4G 

dd if=/dev/zero of=output.img bs=8092  count=$((1024*1024))  #8G 

killall -SIGUSR1 dd  #process  
#/root/develop_perl/split_to_dd_0.pl 
