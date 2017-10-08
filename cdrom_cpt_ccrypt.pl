#!/usr/bin/perl
#***************************************************************************
# Description:
#	����cdrom �ϵ�cpt �ļ���Ŀ¼ Ȼ�� cpt ��ѹ  Ȼ���� rar ��ѹ.
#
# Notice:
#	cdrom ���жϵĹ�������: Win32-DriveInfo-0.06.tar.gz
#		sdk ���������� drvType=GetDriveType(drv);
#	case 5: return "DRIVE_CDROM";
#	������Ϣ���Բο� enum_hard_disk.cpp
########################################################################

our $g_output_dir="c:\\tmp\\tmp_cpt\\";

do("c:\\bin\\find_shell_implement_in_perl.pl");
check_output_dir();

my @cdroms=get_cdroms();
if(scalar(@cdroms) gt 1)
{
	logger("Ӳ�� cdrom ���� 1 �� , �����������������\n");
}

if(! -f "copy_ok")
{
	print("#copy_ok �ļ�����, ���ٴӹ������п�����\n");
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
	logger("$path Ŀ¼��ʼ ��ѹ rar    files\n");
	my @rar_files ;

	my @tmp= find_and_get_filelists($path,"rar\$");
	push(@rar_files, @tmp);
	@tmp= find_and_get_filelists($path,"zip\$");
	push(@rar_files, @tmp);
	@tmp= find_and_get_filelists($path,"tar\$");
	push(@rar_files, @tmp);
	@tmp= find_and_get_filelists($path,"tar.gz\$");
	push(@rar_files, @tmp);

	logger(" $path ·��: һ���ҵ� ".scalar(@rar_files)."��rar|zip|tar.gz|tar �ļ�\n");
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
	logger("ִ�е������� $cmd_str");
}
sub count_cdrom_cpt_file($)
{
	(my $cdrom_label)=@_;
	my $path= $cdrom_label.":\\";
	my @cpt_files = find_and_get_filelists($path,"cpt\$");
	logger(" $cdrom_label ��: һ���ҵ� ".scalar(@cpt_files)."��cpt �ļ�\n");

}
sub extract_dir_cpt_files($)
{
	(my $path)= @_;;
	logger("$path Ŀ¼��ʼ ��ѹ cpt    files\n");
	my @cpt_files = find_and_get_filelists($path,"cpt\$");
	logger(" $path ·��: һ���ҵ� ".scalar(@cpt_files)."��cpt �ļ�\n");
	for (@cpt_files)
	{
		decrypt_one_cpt_file($_);
	}
}

sub decrypt_one_cpt_file($)
{
	print "����cpt file \n";
	(my $cpt_file)=@_;
	if( ! -f  "c:\\cygwin\\bin\\ccrypt.exe")
	{
		logger("ccrypt.exe ���򲻴���, ��Ҫ��װ cygwin\n");
		die("ccrypt.exe ���򲻴���, ��Ҫ��װ cygwin\n");
	}
	create_passwd_key();	
	if($cpt_file=~/cpt$/)
	{
		$cmd="c:\\cygwin\\bin\\ccrypt.exe -d  -k c:\\log\\key  $cpt_file";
		logger("��ѹ���ִ�е�������: $cmd \n");
		system("$cmd");
	}
	else
	{
		logger("����� $cpt_file �ĺ�׺�� ���� cpt\n");
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
#ֻ�����ļ� ������Ŀ¼�ṹ Ŀ¼�ṹ�����ƻ�����, ��ʱ������.
sub copy_to_local($)
{
	(my $label)=@_;
	logger("��ʼ���� $label ���̵Ķ��� �� $g_output_dir Ŀ¼\n");
	for (glob($label.":\\*"))
	{
		logger("ִ������:  copy /y \"$_\" $g_output_dir \n");
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
			print "$_ �ǹ���\n";
			push(@cdroms, $_);
		}
	}
	return @cdroms;
}
die("����\n");
########################################################################
#�����Ĵ�����Ϣ�ȵ�.
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
#��־��ƽ̨����������ϵͳ��
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

