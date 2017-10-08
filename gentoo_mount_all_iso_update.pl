#!/usr/bin/perl
#
use Cwd;
use File::Basename;

mount_cur_dir_iso();

sub mount_cur_dir_iso()
{
	for (glob("*.iso"))
	{
		$name=$_;
		$dirname=$_;
		$dirname=~s/\.iso$//g;
		mkdir($dirname);
		print(" mount -t iso9660  $name  $dirname -o loop \n");
		system(" mount -t iso9660  $name  $dirname -o loop \n");
	}
}

#gentoo 对光盘 进行更新的时候 可以用这种方式. 
sub mhddfs_mount_iso()
{
	our $g_pwd=getcwd();
	#our $g_basename=basename($g_pwd);
	#our $g_dirname=dirname($g_pwd);

	for(glob("*.iso")
	{
		my $mount_dir=basename($_);
		$mount_dir=~s/\.iso$//g;
		mkdir("$mount_dir");

		print "mount -t iso9660 $_ $mount_dir \n";
		
		mkdir("/mnt/iso_mhddfs_backend/$mount_dir");
		mkdir("../merge/");
		mkdir("../merge/$mount_dir");
		print (" mhddfs  $mount_dir,/mnt/iso_mhddfs_backend/$mount_dir  ../merge/$mount_dir\n");
		#/mnt/ftp/sdb1/onegreen/ISO_10_iso.iso
	}

}
