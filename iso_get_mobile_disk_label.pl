#!/usr/bin/perl
#2011_07_19_10:51:35   ���ڶ�   add by greshem
#�����Լ����ƶ�Ӳ�̻�ȡ �����б�. sdb1 ��Ӧ���̷� sdb2 ��Ӧ���̷�.
our $loop_count=0;
START:
	if($^O=~/linux/i)
	{
		die("��ʱ��֧��linux ƽ̨, Ҳû�б�Ҫ֧��.\n");
	}
	our %g_hash=name_to_lable_hash();
	
	#print $hash{"sdb1"}."\n";;
	#print  change_mobile_path_to_win_path("sdb1:\\all_chm")."\n";;
	#print  change_mobile_path_to_win_path("sdb2:\\Security")."\n";
	#print  change_win_path_to_mobile_path("f:\\all_chm");
	my $disk=change_mobile_path_to_win_path('sdb1');
	if( ! defined(is_sdb1($disk)))
	{
		logger_name_to_hash("$disk �������, ����sdb1 ����, �������ϴ�װϵͳ���������ļ�,  name_to_label_hast.txt��Ҫ��� ������\n");
		unlink("c:\\name_to_label_hast.txt") or  logger_name_to_hash("PANIC:  name_to_label_hast.txt û��ɾ����\n");
		logger_name_to_hash("���¿�ʼ�µĹ���, goto START\n");
		$loop_count++;
		if($loop_count    lt 10)
		{
			goto START;
		}
	}
	else
	{
		logger_name_to_hash("Notice: ������֤, name_to_lable_hash.txt �ļ���ȷ\n");
	}

if($0=~/iso_get_mobile_disk_label.pl$/)
{
	my %hash=load_hash_from_file();
	printf("4T_Eden is  ".$hash{"sdb1"}."\n");
}

########################################################################
#
sub  change_mobile_path_to_win_path($)
{
	(my $mobile_path)=@_;
	#my %hash = name_to_lable_hash();
	if($mobile_path !~/^sdb/)
	{
		return undef;
	}	
	$windows_path= $mobile_path;
	for (qw(sdb1 sdb2 sdb3 sdb4))
	{
		$label=$g_hash{$_};
		if(!defined($label))
		{
			logger_name_to_hash("PANIC: $_ ��Ӧ�� �̷� Ϊ��\n");
		}	
		$windows_path=~s/^$_/$label/g;
	}

	return $windows_path;
}

sub  change_win_path_to_mobile_path($)
{
	(my $windows_path)=@_;
	#my %hash = name_to_lable_hash();
	if($windows_path !~/^[a-z]:/i)
	{
		return undef;
	}	
	$mobile_path=$windows_path;
	%label_2_mobile=reverse %g_hash;
	for (keys( %label_2_mobile ))
	{
		$mobile=$label_2_mobile{$_};
		$mobile_path=~s/^$_/$mobile/g;
	}

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
#���ļ����� �ļ��ĸ�ʽ����
#sdb1  h
#sdb2  j
#sdb3  l
#sdb4  m
sub load_hash_from_file()
{
	my %disk_name;
	logger_name_to_hash("����  c:\\name_to_label_hast.txt\n");
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
		logger_name_to_hash("hash Ϊ�� ���ñ���\n");
		return ;
	}

	logger_name_to_hash("���� hash ��  c:\\name_to_label_hast.txt\n");
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
	if( -f "c:\\name_to_label_hast.txt")
	{
		logger_name_to_hash("�ļ����ڿ�ʼ����\n");
		%disk_name=load_hash_from_file();
		if( scalar( keys(%disk_name)) eq 4)
		{
			return %disk_name;
		}
		else
		{
			logger_name_to_hash("����4���̷�, ���� \n");
			logger_name_to_hash("�̷��ļ����غ�,  �̷���������, ��������\n");
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
			#print "sdb1-> $_\n";
			$disk_name{"sdb1"}=$_;
		}
		elsif(is_sdb2($_))
		{
			#print "sdb2-> $_\n";
			$disk_name{"sdb2"}=$_;
		}
		elsif(is_sdb3($_))
		{
			#print "sdb3-> $_\n";
			$disk_name{"sdb3"}=$_;
		}
		elsif(is_sdb4($_))
		{
			#print "sdb4-> $_\n";
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
	@sub=glob("$disk_path:\\*");

	if( -d "$disk_path:\\sdb1" 	&& 
		-d "$disk_path:\\sdb2" 	&& 
		-d "$disk_path:\\sdb3" 	&& 
		-d "$disk_path:\\sdb4") 
	{
			return $disk_path;
	}
	return undef;
}

sub is_sdb2($)
{
	(my $disk_path)=@_;

	if( -d "$disk_path:\\ghost_targz_iso" 		&& 
		-d "$disk_path:\\kugou_mp3_iso" 	&& 
		-d "$disk_path:\\linux_iso_windows" 	&& 
		-d "$disk_path:\\linux_src_all_iso"  &&
		-d "$disk_path:\\oss_site_all_iso"  &&
		-d "$disk_path:\\Security"  &&
		-d "$disk_path:\\vmware_disk_iso"  
		)
	{
			return $disk_path;
	}
	return undef;
}

sub is_sdb3($)
{
	(my $disk_path)=@_;

	if( -d "$disk_path:\\develop_IDE_ISO" 		&& 
		-d "$disk_path:\\Green_software" 	&& 
		-d "$disk_path:\\lindows" 	&& 
		-d "$disk_path:\\office_03_07_10"  &&
		-d "$disk_path:\\photo"  &&
		-d "$disk_path:\\qimeng"  &&
		-d "$disk_path:\\sf_mirror_all"  &&
		-d "$disk_path:\\vc"  &&
		-d "$disk_path:\\windows_pe_iso"
	)
	{
			return $disk_path;
	}
	return undef;
}

sub is_sdb4($)
{
	(my $disk_path)=@_;

	if( -d "$disk_path:\\_daily_backup" 		&& 
		-d "$disk_path:\\f13_srpm_download" 	&& 
		-d "$disk_path:\\my_usb_video_driver" 	&& 
		-d "$disk_path:\\sync")  
	{
			return $disk_path;
	}
	return undef;
}

sub logger_name_to_hash($)
{
	(my $log_str)=@_;
	if($^O=~/win/i)
	{
		if(! -d "c:\\log\\")
		{
			mkdir("c:\\log\\");
		}
		open(FILE, ">>c:\\log\\iso_get_mobile_disk_label.log");
		print FILE $log_str;
		close(FILE);
	}
	else
	{
		open(FILE, ">>/var/log/iso_get_mobile_disk_label.log");
		print FILE $log_str;
		close(FILE);
	}
}
