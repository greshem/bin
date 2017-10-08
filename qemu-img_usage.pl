#!/usr/bin/perl
if( get_images_count() eq 0)
{
	create_img();	
}
else
{
	convert_vmdk();
	convert_raw_2_qcow2();
	
	convert_2_raw();
}

#==========================================================================
sub get_images_count()
{
	return scalar(grep { -f } glob("*.img"));
}

sub create_img()
{
	print "qemu-img create -f qcow2 test.img 20g\n";
}
#==========================================================================
#转一下 vmdk
sub  convert_vmdk()
{
	sub deal_with_vmdk($)
	{
		(my $line)=@_;
		($name)=($line=~/(.*).vmdk/);
		print "qemu-img convert -f vmdk -O raw  $line  $name\.img\n";
	}

	for(glob("*"))
	{
		if($_=~/vmdk/)
		{
			deal_with_vmdk($_);
		}
	}
}
#==========================================================================
#cow 转 qcow2
sub is_qcow2_img($)
{
	(my $img_name)=@_;
	$str=`file $img_name`;
	if($str=~/qcow.*v2/i)
	{
		return 1;
	}
	return undef;
}
sub  convert_2_raw()
{
	
	@array=grep {-f && (/img$/ || /qcow$/) } glob("*");
	for(@array)
	{
	print "qemu-img convert -f qcow2 -O raw  $_  $_.raw\n";
	}
}


sub  convert_raw_2_qcow2()
{
	sub deal_with_img($)
	{
		(my $line)=@_;
		($name)=($line=~/(.*).img/);
		print "qemu-img convert -f raw -O qcow2  $line  $name\.qcow2_img\n";
	}

	for( grep { -f } glob("*"))
	{
		if($_=~/img$/)
		{
			if(is_qcow2_img($_))
			{
				print "# $_  已经是 qcow2 格式了 不用转换\n";
			}
			else
			{
				print "# $_ 不是 qcow2 格式需要转换\n";
				deal_with_img($_);
			}
		}
	}
}

#还原点 母盘 方面的东西的整理.
sub qemu_restore_point()
{
print <<EOF
#==========================================================================
#母盘的制作, application 盘的制作. f13_chm.img 是应用程序img.
# /var/lib/libvirt/images/fedora_13/ 下 从 母盘制作出 chm 的制作环境的问题.
#qemu-img create -b  f13_kgdb_.img  -f qcow2  f13_chm.img           
# 挂载之后, 
#guestmount -a  f13_chm.img  -m /dev/vda1   --rw  /mnt/f13_chm  
#拷贝了 chm 的制作环境.
cp /root/back_up/wine_chm_v4/  /mnt/f13_chm/root/

#==========================================================================
EOF
;
}





