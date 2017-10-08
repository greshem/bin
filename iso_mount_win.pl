########################################################################
sub mount_iso($$)
{
	(my $isoname, my $label)=@_;
	if( ! -f $isoname)
	{
		print $isoname."文件不存在\n";
		return ;
	}
	if($label!~/:$/)
	{
		$label.":";
	}

	if($^O=~/win/i)
	{
		print "#iso的windows路径是:  $isoname \n";
		#system("batchmnt64.exe /unmountall  ");
		print("batchmnt64.exe /unmountall  \n");
		print("batchmnt64.exe /unmount $label  \n"); #注意冒号
		system("batchmnt64.exe /unmount $label  "); #注意冒号
		print("\nbatchmnt64.exe $isoname   $label\n");
		system("batchmnt64.exe $isoname    $label /wait");
		#print "#sleep 2秒 等待 光盘镜像初始化\n";
		#sleep(2);

		if( ! -d "$label\\")
		{
				warn("PANIC: P 盘错误: why?\n");
		}
	}
	else
	{
		if(! -d  "/mnt/iso_mount_dir/")
		{
			mkdir("/mnt/iso_mount_dir/");
		}

		system("mount -t iso9660 $isoname /mnt/iso_mount_dir/  -o loop ");
	}

}
my $iso=shift  or  Usage();
mount_iso($iso, "s:\\");

sub Usage()
{
	for $each (grep {-f } glob("K:\\sdb3\\photo\\*.iso"))
	{

		print $0."\t".$each ."\n";
	}
			print "batchmnt /unmount s: \n";
		print "batchmnt64.exe /unmountall   s: \n";
	#mount_iso("J:\\sdb4\\f16_srpm\\f16_srpm_iso1.iso", "s:\\");
	die("Usage: $0  input.iso \n");
}

