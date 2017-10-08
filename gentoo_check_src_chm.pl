#!/usr/bin/perl
#
our $g_manifest=get_manifest();

#check_src_size();
check_chm_abnormal();
check_chm_include_nothing();
#check_dir_have_no_chm();
#check_dir_have_no_chm();


########################################################################
#sub function 
sub check_dir_have_no_chm()
{
	my @tmp=glob("*.chm");
	if(scalar(@tmp)==0)
	{
	logger(" # û��chm , Ӧ��ɾ��\n");
	}
}
sub check_exist_in_all_chm_db()
{
	open(FILE, "Manifest") or die("open Manifest error , maybe not in gentoo portage dir \n");
	for(<FILE>)
	{
		if($_=~/^DIST/)
		{
			my @array=split(/\s+/, $_);
			my $targz=$array[1];
			logger_chm ("#".$targz."\n"); 
			$name=delete_targz_suffix($targz); 
		}
	}
}


#from  gentoo_genetor_chm.pl  ����. 
#/media/sda3/gentoo_portage_ISO_9_iso/dev-perl/chi	 chi-0.56.chm #û�д����ļ�
#/media/sda3/gentoo_portage_ISO_9_iso/dev-perl/chi	ERROR: chi-0.56.chm �д����ļ�2�� 
sub load_chm_file_info()
{
	my %hash;
	open(FILE, "/root/gentoo_chm_check.log") or die("/root/gentoo_chm_check.log");
	for(<FILE>)
	{
		my @tmp=split(/\s+/, $_);
		#print "DDD: ".join("|", @tmp)."\n";
		if($tmp[3]=~/û�д����ļ�/)
		{
			$hash{$tmp[2]}="BAD";
		}
		elsif ($tmp[3]=~/�д����ļ�.*��/)
		{
			$hash{$tmp[2]}="GOOD";
		}
	}

	return %hash;
}

#--------------------------------------------------------------------------
#chm  ����û�� Դ����. 
sub check_chm_include_nothing()
{
	#for $each glob("*.chm")	
	for $each (glob("*.chm"))
	{
		print "#Deal with $each \n";
		my $name=$each;
		$name=~s/\.chm$//g;

		if((-s  $each ) == 0)
		{
			logger("ERROR:  $each  size==0\n");
		}
		
		$count=get_chm_source_code_file_number($each);
		if($count <= 2)
		{
			logger("ERROR: $each #û�д����ļ�\n");
		}
		else
		{
			logger("ERROR: $each �д����ļ�  $count �� \n");
		}
	}
}

sub get_chm_source_code_file_number($)
{
	(my $chm_file)=@_;
	my $count=0;
	print "CMD:  enum_chmLib $chm_file  \n";
	open(PIPE, " enum_chmLib $chm_file |" ) or die("chmlib not install \n");
	for(<PIPE>)
	{
		if($_=~/\/S\//)
		{
			$count++;
		}
	}
	close(PIPE);
	return $count;
}
#######################################################################
#�Ƿ��� ���� �и�������� 
sub check_chm_abnormal()
{

	for $each (glob("*.chm"))
	{
		print "#========================\n";
		$name=$each;
		$name=~s/\.chm$//g;

		print ("test_chmLib $each  /files.html  /tmp/files.html\n");
		system("test_chmLib $each  /files.html  /tmp/files.html");

		#system("grep  $name  /tmp/files.html");
		#if( $?>>8  eq  0 )
		#{
		#	logger( "$each  ERROR:  ·���ظ�  \n");
		#}
		#
		($first_file, $path)=get_first_file("//tmp/files.html");
		$samename_subdir=get_sameneme_subdir("//tmp/files.html", $name);
	
		if(! defined($samename_subdir))
		{
			logger("# һ��Ŀ¼ û��,  Ϊ $name/��, skip \n");
			next;
		}

		logger("��һ�������ļ���   $path, ��Ӧ chm ����html��  $first_file \n");
		logger("��ͬ���ֵ� subdir ��Ӧ��htmlΪ $samename_subdir \n");
	
		system("rm -f  /tmp/files_subdir.html");
		logger("test_chmLib $each  /$samename_subdir  /tmp/files_subdir.html\n");
		system("test_chmLib $each  /$samename_subdir  /tmp/files_subdir.html");

		if(! -f  "/tmp/files_subdir.html")
		{
			next;
		}
		if($path=~/^\s+$/|| !defined($path))
		{
			logger( "ERROR: chmΪ�� ,skip,    enum_chmLib   $each \n");
			next;
		}
		print ("grep  li.*$path  /tmp/files_subdir.html\n");
		system("grep  li.*$path  /tmp/files_subdir.html");
		if( $?>>8  eq  0 )
		{
			logger( "PATH: $path �� subdir: $name/ Ҳ����,   ERROR:  ·���ظ� $each   \n");
		}

	}
}

#��һ���ļ��б� 
#<li><a href='files/215.html' title='13 files'>src/</a></li>
sub get_first_file()
{
	(my $input_html)=@_;
	open(FILE, $input_html)  or die(" open $input_html error \n");
	for(<FILE>)
	{
		if($_=~/^<li>.*href='(.*?)'.*>(.*?)<\/a.*/)
		{
			close(FILE);
			return ($1,$2);
		}
	}
	close(FILE);
	return undef;
}


#<li><a href='files/216.html' title='13 files'>xfce4-appfinder-4.10.0/</a></li>
#�Ͱ���������ͬ�� ��Ŀ¼: 
sub get_sameneme_subdir($$)
{
	(my $input_html, my $name)=@_;
	{
		open(FILE, $input_html)  or die(" open $input_html error \n");
		for(<FILE>)
		{
			if($_=~/^<li>.*href='(.*)' title.*$name/)
			{
				close(FILE);
				return $1, ;
			}
		}
	}
	close(FILE);
	return undef;
}

sub get_manifest()
{
	if(-f "manifest")
	{
		return  "manifest";
	}

	if(-f "Manifest")
	{
		return  "Manifest";
	}
	return  "Manifest";
}


sub get_src_code_file_size_manifest($)
{
	(my $input_file)=@_;
	my $size=0;
	open(FILE, "$g_manifest") or die("open $g_manifest error \n");
	for(<FILE>)
	{
		if($_=~/\s+$input_file\s+(\d+)\s+/)
		{
			$size=$1;	
		}	
	}
	return $size; 
}

sub get_src_code_file_size_local($)
{
	(my $input_file)=@_;
	if(! -f  $input_file)
	{
		logger("#ERROR: $input_file not exists \n");
		return -1;
	}
	my $size=(-s $input_file);
	return $size; 
}


sub check_src_size()
{
	open(PIPE,  "grep  DIST $g_manifest | awk '{print \$2}' |  ") or die(" open  $g_manifest error \n");
	for(<PIPE>)
	{
		chomp($_);
		my $src_file=$_;

		$size_in_manifest= get_src_code_file_size_manifest($src_file);
		print "$_ Size  $g_manifest is $size_in_manifest \n";
		
		$size_in_local= get_src_code_file_size_local($src_file);
		print "$_ Size  local    is  $size_in_local \n";

		if($size_in_manifest <   $size_in_local )
		{
			logger("ERROR: SIZE: �ظ����:  | $g_manifest=$size_in_manifest С��  local=$size_in_local | $src_file\n");
		}
		elsif($size_in_manifest >    $size_in_local )
		{
			logger("ERROR: SIZE: wgetʧ��:  | $g_manifest=$size_in_manifest ����  local=$size_in_local | $src_file\n");
		}
		else
		{
			print("OK   : $src_file size  is  correct \n");
		}
	}

}

sub logger()
{
use Cwd;
use Cwd;
use File::Basename;

our $g_pwd=getcwd();
our $g_basename=basename($g_pwd);
our $g_dirname=dirname($g_pwd);


	(my $log_str)=@_;
	open(FILE, ">> /tmp/gentoo_chm_check.log") or warn("open all.log error\n");
	print FILE $g_pwd."\t".$log_str;
	print STDOUT $g_pwd."\t".$log_str;
	close(FILE);

}


