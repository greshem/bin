#!/usr/bin/perl
#***************************************************************************
# Description:
#	拷贝cdrom 上的cpt 文件到目录 然后 cpt 解压  然后在 rar 解压.
#
# Notice:
#	cdrom 的判断的功能来自: Win32-DriveInfo-0.06.tar.gz
#		sdk 中最后调用了 drvType=GetDriveType(drv);
#	case 5: return "DRIVE_CDROM";
#	更多信息可以参看 enum_hard_disk.cpp
########################################################################

our $g_output_dir="c:\\tmp\\tmp_cpt\\";

do("c:\\bin\\find_shell_implement_in_perl.pl");
check_output_dir();

my @cdroms=get_cdroms();
if(scalar(@cdroms) gt 1)
{
	logger("硬件 cdrom 大于 1 个 , 可能有虚拟光驱存在\n");
}

if(! -f "copy_ok")
{
	print("#copy_ok 文件存在, 不再从光驱进行拷贝了\n");
	for $cdrom_label ( @cdroms)
	{
		copy_to_local($cdrom_label);
	}
	touch("copy_ok");
}

extract_dir_cpt_files($g_output_dir);
extract_dir_rar_files($g_output_dir);

########################################################################
sub touch($)
{
	(my $filename)=@_;
	open(FILE, ">$filename") or warn("open file $filename error \n");
	close(FILE);
}
sub check_output_dir()
{
	
	if( ! -d "c:\\tmp\\")
	{
		mkdir ("c:\\tmp\\");
	}

	if( ! -d  $g_output_dir)
	{
		mkdir ($g_output_dir);
	}


}
sub extract_dir_rar_files($)
{
	(my $path)= @_;;
	logger("$path 目录开始 解压 rar    files\n");
	my @rar_files ;

	my @tmp= find_and_get_filelists($path,"rar\$");
	push(@rar_files, @tmp);
	@tmp= find_and_get_filelists($path,"zip\$");
	push(@rar_files, @tmp);
	@tmp= find_and_get_filelists($path,"tar\$");
	push(@rar_files, @tmp);
	@tmp= find_and_get_filelists($path,"tar.gz\$");
	push(@rar_files, @tmp);

	logger(" $path 路径: 一共找到 ".scalar(@rar_files)."个rar|zip|tar.gz|tar 文件\n");
	for (@rar_files)
	{
		unrar_one_file($_);
	}
}
sub unrar_one_file($)
{
	our $count;
	$count++;
	(my $input_rar)=@_;
	print "unrar_one_file  $count \n";
	$cmd_str=" \"c:\\Program Files\\winrar\\winrar.exe\" x -y  $input_rar  $g_output_dir";
	system($cmd_str);
	logger("执行的命令是 $cmd_str");
}
sub count_cdrom_cpt_file($)
{
	(my $cdrom_label)=@_;
	my $path= $cdrom_label.":\\";
	my @cpt_files = find_and_get_filelists($path,"cpt\$");
	logger(" $cdrom_label 盘: 一共找到 ".scalar(@cpt_files)."个cpt 文件\n");

}
sub extract_dir_cpt_files($)
{
	(my $path)= @_;;
	logger("$path 目录开始 解压 cpt    files\n");
	my @cpt_files = find_and_get_filelists($path,"cpt\$");
	logger(" $path 路径: 一共找到 ".scalar(@cpt_files)."个cpt 文件\n");
	for (@cpt_files)
	{
		decrypt_one_cpt_file($_);
	}
}

sub decrypt_one_cpt_file($)
{
	print "处理cpt file \n";
	(my $cpt_file)=@_;
	if( ! -f  "c:\\cygwin\\bin\\ccrypt.exe")
	{
		logger("ccrypt.exe 程序不存在, 需要安装 cygwin\n");
		die("ccrypt.exe 程序不存在, 需要安装 cygwin\n");
	}
	create_passwd_key();	
	if($cpt_file=~/cpt$/)
	{
		$cmd="c:\\cygwin\\bin\\ccrypt.exe -d  -k c:\\log\\key  $cpt_file";
		logger("解压最后执行的命令是: $cmd \n");
		system("$cmd");
	}
	else
	{
		logger("输入的 $cpt_file 的后缀名 不是 cpt\n");
	}
}
sub create_passwd_key()
{
	if( ! -d "c:\\log")
	{
		mkdir("c:\\log");
	}
	open(KEY, "> c:\\log\\key");
	print KEY "q**************n";
	close(KEY);
}

########################################################################
#只拷贝文件 不拷贝目录结构 目录结构都被破坏掉了, 暂时可以用.
sub copy_to_local($)
{
	(my $label)=@_;
	logger("开始拷贝 $label 光盘的东西 到 $g_output_dir 目录\n");
	for (glob($label.":\\*"))
	{
		logger("执行命令:  copy /y \"$_\" $g_output_dir \n");
		system("copy /y \"$_\"  $g_output_dir \n");
	}
}




########################################################################
sub get_cdroms()
{
	require Win32::DriveInfo;
	my @drives2 = grep Win32::DriveInfo::IsReady($_), ("C".."Z");
	my @cdroms;
	for (@drives2) 
	{
		#$vol->{$_}{"type"} = Win32::DriveInfo::DriveType($_);
		$type= Win32::DriveInfo::DriveType($_);
		if($type eq "5")
		{
			print "$_ 是光驱\n";
			push(@cdroms, $_);
		}
	}
	return @cdroms;
}
die("结束\n");
########################################################################
#其他的磁盘信息等等.
sub get_disk_info()
{
	require Win32::DriveInfo;
	my @drives2 = grep Win32::DriveInfo::IsReady($_), ("C".."Z");
	for (@drives2) 
	{ # drives that have root (fixed and loaded removable)
	  my ($VolumeName,
		  $VolumeSerialNumber,
		  $MaximumComponentLength,
		  $FileSystemName, @attr) = Win32::DriveInfo::VolumeInfo($_);
	  $vol->{$_} = {
		"label"   => $VolumeName,
		"serial"  => $VolumeSerialNumber,
		"maxcomp" => $MaximumComponentLength,
		"fsys"    => $FileSystemName,
		"attrs"   => \@attr,
	  };
	}
}
########################################################################
#日志跨平台在两个操作系统上
sub logger($)
{
	(my $log_str)=@_;
	if($^O=~/win32/i)
	{
		open(FILE, ">>  c:\\log\\cdrom_cpt_ccrypt.log");
	}
	else
	{
		open(FILE, ">>  /var/log/cdrom_cpt_ccrypt.log");
	}
		print $log_str;
		print FILE $log_str;
		close(FILE);
}

