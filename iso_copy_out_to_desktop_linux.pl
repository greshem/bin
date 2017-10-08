#!/usr/bin/perl 
#注意传入的文件名 应该里面有一个ISO 的, 
#use strict;

$path=shift or die("Usage: $0  iso_file_path\n");

our $g_desktop_path=shift;

logger_copy_BBB("#拷贝文件 iso_copy_out_to_desktop.pl \"$path\" \n");

	
do("/bin/iso_get_mobile_disk_label_linux.pl");
	#do("iso_get_mobile_disk_label.pl");


my $isoname;
my $filename;


	if($path=~/(sdb1:.*\.iso)\\(.*)/)
	{
		print "ISO=>: ". $1."\n";
		print "File=>: ". $2."\n";
		$isoname=$1;
		$filename=$2;
		$isoname=~s/\\/\//g;
		$filename=~s/\\/\//g;
	}
	else
	{
		warn("linux 路径格式错误, 路径格式 没有 .iso 镜像, 格式如下: \n");
		print <<EOF
perl   iso_copy_out_to_desktop_linux.pl  "sdb1:\\sdb1\\sf_mirror_iso\\sf_q.iso\\q\\qu\\quezen\\quezen-linux-0.1.1.tar.gz" 
EOF
;

	}

$mount_4t_dir=`perl  /root/bin/get_greshem_4T_root_dir.pl`;
chomp($mount_4t_dir);
print "INFO:  eden4t 挂载目录是 $mount_4t_dir \n";
$isoname=~s/sdb1:/$mount_4t_dir/g;
print "#INFO: 最后的光盘是:: $isoname\n";

mount_iso($isoname);
$g_desktop_path="/tmp/";

if(-f ("/mnt/iso_mount_dir/$filename"))
{
	print ("cp  /mnt/iso_mount_dir/$filename  /tmp/ \n");
	system("cp -v   /mnt/iso_mount_dir/$filename  /tmp/ \n");
}
elsif(-d ("/mnt/iso_mount_dir/$filename"))
{
	print ("cd  /mnt/iso_mount_dir/$filename   \n");
}
else
{
	die("PANIC: 光盘中, $filename 不存在\n");
}

########################################################################
sub mount_iso($)
{
	(my $isoname)=@_;
	if( ! -f $isoname)
	{
		print $isoname."文件不存在\n";
		return ;
	}

	if(! -d  "/mnt/iso_mount_dir/")
	{
		mkdir("/mnt/iso_mount_dir/");
	}
	print("mount -t iso9660 $isoname /mnt/iso_mount_dir/  -o loop \n");
	system("mount -t iso9660 $isoname /mnt/iso_mount_dir/  -o loop ");

}

sub logger_copy_BBB($)
{
	use POSIX 'strftime';

	(my $log_str)=@_;
	 	my $log_time;
	if($^O=~/win/i)
	{
		if(! -d "c:\\log\\")
		{
			mkdir("c:\\log\\");
		}

		$log_time = POSIX::strftime('%Y-%m-%d-%H:%M:%S',localtime(time()));
		open(FILE, ">>c:\\log\\iso_copy_out_to_desktop.log");
	}
	else
	{
		$log_time = POSIX::strftime('%Y-%m-%d-%T',localtime(time()));
		open(FILE, ">>/var/log/iso_copy_out_to_desktop.log");
	}
	print FILE  "[$log_time]: $log_str";
	close(FILE);
}
