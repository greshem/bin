########################################################################
sub mount_iso($$)
{
	(my $isoname, my $label)=@_;
	if( ! -f $isoname)
	{
		print $isoname."�ļ�������\n";
		return ;
	}
	if($label!~/:$/)
	{
		$label.":";
	}

	if($^O=~/win/i)
	{
		print "#iso��windows·����:  $isoname \n";
		#system("batchmnt64.exe /unmountall  ");
		print("batchmnt64.exe /unmountall  \n");
		print("batchmnt64.exe /unmount $label  \n"); #ע��ð��
		system("batchmnt64.exe /unmount $label  "); #ע��ð��
		print("\nbatchmnt64.exe $isoname   $label\n");
		system("batchmnt64.exe $isoname    $label /wait");
		#print "#sleep 2�� �ȴ� ���̾����ʼ��\n";
		#sleep(2);

		if( ! -d "$label\\")
		{
				warn("PANIC: P �̴���: why?\n");
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

