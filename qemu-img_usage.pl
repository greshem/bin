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
#תһ�� vmdk
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
#cow ת qcow2
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
				print "# $_  �Ѿ��� qcow2 ��ʽ�� ����ת��\n";
			}
			else
			{
				print "# $_ ���� qcow2 ��ʽ��Ҫת��\n";
				deal_with_img($_);
			}
		}
	}
}

#��ԭ�� ĸ�� ����Ķ���������.
sub qemu_restore_point()
{
print <<EOF
#==========================================================================
#ĸ�̵�����, application �̵�����. f13_chm.img ��Ӧ�ó���img.
# /var/lib/libvirt/images/fedora_13/ �� �� ĸ�������� chm ����������������.
#qemu-img create -b  f13_kgdb_.img  -f qcow2  f13_chm.img           
# ����֮��, 
#guestmount -a  f13_chm.img  -m /dev/vda1   --rw  /mnt/f13_chm  
#������ chm ����������.
cp /root/back_up/wine_chm_v4/  /mnt/f13_chm/root/

#==========================================================================
EOF
;
}





