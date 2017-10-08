#!/usr/bin/perl
our $loop_count=0;
START:
	if($^O=~/linux/i)
	{
		#warn("支持linux 平台, 可能有bug.\n");
	}
	
	#print  change_mobile_path_to_linux_path("sdb1:\\all_chm")."\n";;
	#print  change_mobile_path_to_linux_path("sdb2:\\Security")."\n";
	print  change_linux_path_to_mobile_path("/media/sdb1/all_chm");
	my $disk=change_mobile_path_to_linux_path('sdb1');
	print $disk."\n";
	if( ! defined(is_sdb1($disk)))
	{
		logger_name_to_hash("$disk 检测下来, 不是sdb1 磁盘, 估计是上次装系统留下来的文件,  name_to_label_hast.txt需要清空 再生成\n");
		logger_name_to_hash("重新开始新的过程, goto START\n");
		$loop_count++;
		if($loop_count    lt 10)
		{
			goto START;
		}
	}
	else
	{
		logger_name_to_hash("Notice: 移动硬盘正确挂载\n");
	}
########################################################################
#
sub  change_mobile_path_to_linux_path($)
{
	(my $mobile_path)=@_;
	$mobile_path=~s/\\/\//g;
	#my %hash = name_to_lable_hash();
	if($mobile_path !~/^sdb/)
	{
		return undef;
	}	
	$linux_path= $mobile_path;
	for (qw(sdb1 sdb2 sdb3 sdb4))
	{
		$linux_path=~s/^$_:/$_/g;
		$linux_path=~s/^$_/\/media\/$_/g;
	}

	return $linux_path;
}

sub  change_linux_path_to_mobile_path($)
{
	(my $linux_path)=@_;
	#my %hash = name_to_lable_hash();
	if($windows_path !~/^\/media\//i)
	{
		return undef;
	}	
	$mobile_path=$windows_path;
	$mobile_path=~s/^\/media\///g;

	$mobile_path=~s/(sdb[1234])/$1:/;
	return $mobile_path;
}

sub my_file_assert($)
{
	(my $filename)=@_;
	if(! -f $filename)
	{
		die("Error: $filename not exists\n");
	}
}
########################################################################
#从文件载入 文件的格式如下
#sdb1  h
#sdb2  j
#sdb3  l
#sdb4  m
sub load_hash_from_file()
{
	my %disk_name;
	logger_name_to_hash("载入  c:\\name_to_label_hast.txt\n");
	open(FILE, "c:\\name_to_label_hast.txt") or die("open file  error , $!\n");
	for(<FILE>)
	{
		chomp;
		@array=split(/\s+/, $_);
		if($array[0]=~/^sdb/)
		{
			$disk_name{$array[0]}=$array[1];
		}
	}
	return %disk_name;
}
sub save_hash_to_file(%)
{
	my %disk_name=@_;
	if(scalar(keys(%disk_name)) == 0)
	{
		logger_name_to_hash("hash 为空 不用保存\n");
		return ;
	}

	logger_name_to_hash("保存 hash 到  c:\\name_to_label_hast.txt\n");
	open(FILE, "> c:\\name_to_label_hast.txt") or die("open file  error , $!\n");
	
	for( keys(%disk_name))
	{
		print  FILE $_."  ".$disk_name{$_}."\n";
	}
	close(FILE);
}
sub name_to_lable_hash()
{
	my @lables;
	my %disk_name;
	if( -f "/var/log/name_to_label_hast.txt")
	{
		logger_name_to_hash("文件存在开始载入\n");
		%disk_name=load_hash_from_file();
		if( scalar( keys(%disk_name)) eq 4)
		{
			return %disk_name;
		}
		else
		{
			logger_name_to_hash("不是4个盘符, 错误 \n");
			logger_name_to_hash("盘符文件加载后,  盘符数量错误, 继续加载\n");
		}
	}

	for(a..z)
	{
		if( -d "$_:\\")
		{
			#print $_."\n";
			push(@lables, $_);
		}
	}

	for(@lables)
	{
		if(is_sdb1($_))
		{
			print "sdb1-> $_\n";
			$disk_name{"sdb1"}=$_;
		}
		elsif(is_sdb2($_))
		{
			print "sdb2-> $_\n";
			$disk_name{"sdb2"}=$_;
		}
		elsif(is_sdb3($_))
		{
			print "sdb3-> $_\n";
			$disk_name{"sdb3"}=$_;
		}
		elsif(is_sdb4($_))
		{
			print "sdb4-> $_\n";
			$disk_name{"sdb4"}=$_;
		}
	}
	save_hash_to_file(%disk_name);
	return %disk_name;
}
########################################################################
sub is_sdb1($)
{
	(my $disk_path)=@_;
	@sub=glob("$disk_path/*");

	if( -d "$disk_path/ebook" 	&& 
		-d "$disk_path/all_chm" 	&& 
		-d "$disk_path/dos_iso" 	&& 
		-d "$disk_path/game" 		&& 
		-d "$disk_path/_x_file" 	&& 
		-d "$disk_path/_pre_cache")
	{
			return $disk_path;
	}
	return undef;
}

sub is_sdb2($)
{
	(my $disk_path)=@_;
	if($disk_path!~/\/media/)
	{
		logger_name_to_hash("is_sdb2 路径格式不对\n");
	}
	if( -d "$disk_path/ghost_targz_iso" 		&& 
		-d "$disk_path/kugou_mp3_iso" 	&& 
		-d "$disk_path/linux_iso_windows" 	&& 
		-d "$disk_path/linux_src_all_iso"  &&
		-d "$disk_path/oss_site_all_iso"  &&
		-d "$disk_path/Security"  &&
		-d "$disk_path/vmware_disk_iso"  
		)
	{
			return $disk_path;
	}
	return undef;
}

sub is_sdb3($)
{
	(my $disk_path)=@_;
	if($disk_path!~/\/media/)
	{
		logger("is_sdb3 路径格式不对\n");
	}


	if( -d "$disk_path/develop_IDE_ISO" 		&& 
		-d "$disk_path/Green_software" 	&& 
		-d "$disk_path/lindows" 	&& 
		-d "$disk_path/office_03_07_10"  &&
		-d "$disk_path/photo"  &&
		-d "$disk_path/qimeng"  &&
		-d "$disk_path/sf_mirror_all"  &&
		-d "$disk_path/vc"  &&
		-d "$disk_path/windows_pe_iso"
	)
	{
			return $disk_path;
	}
	return undef;
}

sub is_sdb4($)
{
	(my $disk_path)=@_;

	if($disk_path!~/\/media/)
	{
		logger_name_to_hash("is_sdb4 路径格式不对\n");
	}


	if( -d "$disk_path/_daily_backup" 		&& 
		-d "$disk_path/f13_srpm_download" 	&& 
		-d "$disk_path/my_usb_video_driver" 	&& 
		-d "$disk_path/sync")  
	{
			return $disk_path;
	}
	return undef;
}

sub logger_name_to_hash($)
{
	(my $log_str)=@_;
	if(! -d "/var/log/")
	{
		mkdir("/var/log/");
	}
	open(FILE, ">>/var/log/iso_get_mobile_disk_label.log");
	print FILE $log_str;
	close(FILE);
}
