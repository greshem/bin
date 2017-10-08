#!/usr/bin/perl
#2011_07_05_ 星期二 add by greshem
our @g_paths;	#当前的iso 里面存储的所有的路径
our $g_iso_file; #当前处理的iso文件.

if($^O=~/win32/i)
{
	do("c:\\bin\\iso_get_mobile_disk_label.pl");
	do("c:\\bin\\os_iso_path_db.pl");
}
else
{
	do("./iso_get_mobile_disk_label.pl");
	do("/bin/os_iso_path_db.pl");
	#do("iso_get_mobile_disk_label.pl");
}

#mainloop 
for  (@g_iso_paths)
{
	print $_."\n";
	index_one_dir($_);
}

#gen_iso_index_list("d:\\vs2003_3.iso");
#gen_iso_index_list("d:\\_develop_20100711.iso");
#print get_iso_from_path("d:\\_develop_20100711.iso")."\n";
#print get_iso_from_path("d:\\ffffff\\_develop_20100711.iso")."\n";;

########################################################################
sub index_one_dir($)
{
	(my $dir)=@_;
	if($dir=~/^sdb/i)
	{
		logger("$dir 是 移动硬盘格式路径\n");
 		$dir=change_mobile_path_to_win_path($dir);
		logger("转换之后的路径是 $dir\n");
	}
	if(! -d $dir)
	{
		print $dir."不是 一个目录 \n";
		logger("$dir 目录不存在\n");
		return ;
	}
	for $iso (grep {-f } glob("$dir*\.iso"))
	{
		#gen_iso_index_list($iso);
		print $iso."\n";
		#logger("rm -f $iso.txt\n");
		logger_to_bat_del("del  $iso.txt\n");
		if(! -f $iso.".txt")
		{
			logger("开始处理 iso 生成索引文件\n");
			gen_iso_index_list($iso);
		}
		else
		{
			print $iso."索引文件已经生成了\n";
			logger("$iso 的索引文件已经生成了\n");
		}
	}
}


########################################################################
#batchmnt from wincdemu  3.4
sub gen_iso_index_list($)
{
	(my $iso_file)=@_;
	$g_iso_file=$iso_file;
	if( ! -f $iso_file)
	{
		die(" $iso_file not exists\n");
	}	
	system("batchmnt64.exe /unmountall  ");
	print("\nbatchmnt64.exe $iso_file   p\n");
	system("batchmnt64.exe $iso_file    p");
	print "sleep 5秒 等待 光盘镜像初始化\n";
	sleep(5);
	if( ! -d "p:\\")
	{
		die("P disk not exists\n");
	}
	#find 的命令获取文件列表.
	find_and_get_filelist();
}

sub  find_and_get_filelist()
{
	use File::Find ();

	use vars qw/*name *dir *prune/;
	*name   = *File::Find::name;
	*dir    = *File::Find::dir;
	*prune  = *File::Find::prune;

	sub wanted;
	sub wanted {
		my ($dev,$ino,$mode,$nlink,$uid,$gid);

		(($dev,$ino,$mode,$nlink,$uid,$gid) = lstat($_));
		$name=~s/\//\\\\/g;
		$name=~s/^P:\\\\/$g_iso_file\\/g;
		print("$name\n");
		push(@g_paths, $name);
	}

	sub save_file()
	{
		open(FILE, "> $g_iso_file.txt")or die("open file error\n");
		for(@g_paths)
		{
			$ret_path=change_win_path_to_mobile_path($_);
			print FILE $ret_path;
			print FILE "\n";
		}
		close(FILE);
	}

	@g_paths=();
	File::Find::find({wanted => \&wanted}, 'P:\\');
	save_file();
	#exit;

}

sub get_iso_from_path($)
{
	(my $path_iso)=@_;
	($name)=($path_iso=~/.*\\(.*\.iso$)/);
	return $name;
}
sub logger($)
{
	(my $log_str)=@_;
	open(FILE, ">>all.log");
	print FILE $log_str;
	close(FILE);
}
sub logger_to_bat_del($)
{
	(my $log_str)=@_;
	open(FILE, ">> del_log");
	print FILE $log_str;
	close(FILE);
}
########################################################################
#while be discarded 
sub dummy()
{
	index_one_dir("sdb1:\\_x_file\\");
	index_one_dir("sdb1:\\_x_file\\2009_all_iso\\");
	index_one_dir("sdb1:\\_x_file\\2010_all_iso\\");
	index_one_dir("sdb1:\\_x_file\\2011_all_iso\\");
	index_one_dir("sdb1:\\_x_file\\2012_all_iso\\");
	index_one_dir("sdb1:\\_x_file\\d_frequent");
	index_one_dir("sdb1:\\_x_file\\d_qianlong_all_iso\\");
	index_one_dir("sdb1:\\all_chm\\");
	index_one_dir("sdb1:\\dos_iso\\");
	index_one_dir("sdb1:\\ebook\\");
	index_one_dir("sdb1:\\game\\");
	index_one_dir("sdb1:\\sf_mirror_iso\\");
	index_one_dir("sdb1:\\linux_src_all_iso\\");
	index_one_dir("sdb1:\\oss_site_all_iso\\");
	index_one_dir("sdb1:\\oss_site_all_iso\\d_python_pypi_mirror_iso\\");
	index_one_dir("sdb1:\\kugou_mp3_iso\\");

	index_one_dir("sdb2:\\Security\\");
	index_one_dir("sdb2:\\ghost_targz_iso\\");
	index_one_dir("sdb2:\\linux_iso_windows\\");
	index_one_dir("sdb2:\\vmware_disk_iso\\");

	index_one_dir("sdb3:\\develop_IDE_ISO\\");
	index_one_dir("sdb3:\\lindows\\");
	index_one_dir("sdb3:\\qimeng\\");


	index_one_dir("sdb4:\\f13_srpm_download\\d_linux_src_f13\\");
	index_one_dir("sdb4:\\f8_srpm_done\\");
}

