#!/usr/bin/perl
#��־��ƽ̨����������ϵͳ��
sub logger($)
{
	(my $log_str)=@_;
	if($^O=~/win32/i)
	{
		open(FILE, ">>  d:\\log\\subdir_recursive_compile.log");
	}
	else
	{
		open(FILE, ">>  /var/log/subdir_recursive_compile.log");
	}
	#print FILE "����: ";
	print FILE $log_str;
	close(FILE);
}

sub  find_and_get_exe_filelist($)
{
	(my $dir)=@_;
	my @exe_files=();

	use File::Find ();

	use vars qw/*name *dir *prune/;
	*name   = *File::Find::name;
	*dir    = *File::Find::dir;
	*prune  = *File::Find::prune;

	sub wanted_exe;
	sub wanted_exe 
	{
		my ($dev,$ino,$mode,$nlink,$uid,$gid);

		(($dev,$ino,$mode,$nlink,$uid,$gid) = lstat($_));
		#$name=~s/\//\\\\/g;
		#print("$name\n");
		if($name=~/exe$|dll$|lib$/i && -f $name )
		{
			push(@exe_files , $name);
		}
	}
	
	File::Find::find({wanted => \&wanted_exe}, $dir);

	return @exe_files;
}

########################################################################
#ֻ��һ������ dsp_file ָ ���� dsp dsp  makefile.vc *.mak  vcproj �����ļ�.
sub  find_and_get_dsp_filelist($)
{
	(my $dir)=@_;
	my @vc_dsp_vcproj_files=();

	use File::Find ();

	use vars qw/*name *dir *prune/;
	*name   = *File::Find::name;
	*dir    = *File::Find::dir;
	*prune  = *File::Find::prune;

	sub wanted;
	sub wanted 
	{
		my ($dev,$ino,$mode,$nlink,$uid,$gid);

		(($dev,$ino,$mode,$nlink,$uid,$gid) = lstat($_));
		#$name=~s/\//\\\\/g;
		#print("$name\n");
		if($name=~/dsw$|dsp$|vcproj$|makefile.vc$|mak$|makefile_release.vc$|makefile_debug.vc$|Makefile/i && -f $name )
		{
			push(@vc_dsp_vcproj_files , $name);
		}
	}
	
	File::Find::find({wanted => \&wanted}, $dir);

	return @vc_dsp_vcproj_files;
}

sub uniq_compile_dir_from_vcproj_array(@)
{
	(my @vcprojs_file)=@_;
  	use File::Basename;
	
	my %hash_tmp;
	for $each (@vcprojs_file)
	{
		$dirname=dirname($each);	
		$hash_tmp{$dirname}++;	
	}
	return keys(%hash_tmp);	
}

sub testunit()
{
	@array= find_and_get_dsp_filelist("/root/bin/");
	#print join("\n", @array);
	push(@array, "/root/test/test.dsp");
	push(@array, "/root/test2/test.dsp");
	push(@array, "/root/test3/test.dsp");


	@compile_dir=uniq_compile_dir_from_vcproj_array(@array);

	print join("\n", @compile_dir);
}
#input_dsp_files
sub compile_with_dirs(@)
{
	(my @input_files)=@_;
	my @compile_dirs=uniq_compile_dir_from_vcproj_array(@input_files);
	for $each_dir (@compile_dirs)
	{

		if($each_dir !~/^\//)
		{
			logger("����: dsp $each_dsp  �ļ� ���Ǿ���·��\n");
		}

		if( -d $each_dir)
		{
			chdir($each_dir);
			system("/bin/gen_bakefile_from_dsp.pl");
			system("/bin/gen_bakefile_from_vcproj_simplest.pl.pl");
		}
	}
}


########################################################################
sub my_die($)
{
	(my $log_str)=@_;
	$log_str="����:".$log_str;
	logger($log_str);
	die($log_str);
}

sub chdir_must_success_or_die($)
{
	(my $dir)=@_;

	if(! chdir($dir))
	{ 
		my_die("$dirname_input Ŀ¼���δ���\n"); 
	}
}


#input_dsp_files
sub compile_with_files(@)
{
	use File::Basename;
	(my @input_files)=@_;
	for $each_dsp (@input_files)
	{
		logger("===================================\n");
		logger("��ʼ���� $each_dsp �ļ�\n");
		if($each_dsp !~/^\// &&   $each_dsp !~/^[a-z]\:/i )
		{
			logger("����: dsp $each_dsp  �ļ� ���Ǿ���·��\n");
		}
		if( ! -f $each_dsp )
		{
			logger("����: $each_dsp �����ļ�\n");
			next;
		}
		if( $each_dsp=~/dsp$/i)
		{
			my $dirname=dirname($each_dsp);
			chdir_must_success_or_die($dirname);
			#system("msdev $each_dsp"); 
			system_exec_with_log( get_msdev_path()."  ". $each_dsp."  /make all \n");
		}
		elsif($each_dsp=~/vcproj$/i)
		{
			logger("����: ��֧�� vcproj �ı���\n");
		}
		elsif($each_dsp=~/makefile.vc$|makefile_debug.vc$|makefile_release.vc$/i)
		{
			logger("nmake ���� $each_dsp �ļ�\n");
			my $dirname=dirname($each_dsp);
			chdir_must_success_or_die($dirname);
			system_exec_with_log("nmake /f  $each_dsp clean \n");
			system_exec_with_log("nmake /f  $each_dsp \n");
		}
		elsif($each_dsp=~/mak$/i)
		{
			#logger("����: ��֧�� vcproj �ı���\n");
			my $dirname=dirname($each_dsp);
			chdir_must_success_or_die($dirname);
			system_exec_with_log( "nmake /f  $each_dsp clean \n");
			system_exec_with_log( "nmake /f  $each_dsp \n");
		}
		elsif  ($each_dsp=~/Makfile$/i)
		{
			my $dirname=dirname($each_dsp);
			chdir_must_success_or_die($dirname);
			system_exec_with_log( "make -f  $each_dsp  \n");
		}
		else
		{
			logger("����: ��֧�� ��Ŀ�����ļ�, $each_dsp\n");
		}

	}
}

sub get_msdev_path()
{
	my $msdev="\"C:\\Program Files\\Microsoft Visual Studio\\COMMON\\MSDev98\\Bin\\msdev.exe\"";
	return $msdev;
}
sub system_exec_must_success_or_die($)
{
	(my $cmd_str)=@_;
	logger("ִ������: $cmd_str\n");
	system($cmd_str);
	if($?>>8 ne 0)
	{
		my_die("������: $cmd_str ִ��ʧ��\n");
	}
}

sub system_exec_with_log($)
{
	(my $cmd_str)=@_;
	logger("ִ������: $cmd_str\n");
	system($cmd_str);
	if($?>>8 ne 0)
	{
		logger("����: ������: $cmd_str ִ��ʧ��\n");
	}
}

sub check_exe_start($)
{
	(my $my_pwd)=@_;
	chdir_must_success_or_die($my_pwd);
	my @exes=find_and_get_exe_filelist($my_pwd);
	if(scalar(@exes) eq 0 )
	{
		logger("��ʼ: ��ǰĿ¼$pwd ��, exe�ļ�����Ϊ0, ��ʼ����\n");
	}
	else
	{
		#my_die("��ʼ: ��ǰĿ¼$pwd ��, exe�ļ�������Ϊ0, Ϊ".scalar(@exes)." ������̲��ñ���\n");
		logger("��ʼ: ��ǰĿ¼$pwd ��, exe�ļ�������Ϊ0, Ϊ".scalar(@exes)." ������̿��Բ��ñ���, ���ǻ��ǽ��б���\n");
	}
}

sub check_exe_end_1($)
{
	(my $my_pwd)=@_;
	chdir_must_success_or_die($my_pwd);
	my @exes=find_and_get_exe_filelist($my_pwd);
	if(scalar(@exes) eq 0 )
	{
		logger("PANIC_���ش���: ����: ��ǰĿ¼$pwd ��, exe�ļ���������Ϊ0,  ��Ҫ�˹��������\n");
	}
}

sub check_exe_end_with_makefile($@)
{
	use File::Basename;
	(my $my_pwd, @input_makefile)=@_;

	chdir_must_success_or_die($my_pwd);
	
	logger("check_exe �����".scalar(@input_makefile)."�� �����ļ�\n");
	my @others= grep {$_!~/makefile.vc$|makefile_debug.vc$|makefile_release.vc$/} @input_makefile;
	if(scalar(@others) ne 0)
	{
		logger("ע��: ����һ�� ".scalar(@others)."����Ŀ���� �ļ���֧�� exe �ļ��\n"); 
	}
	my @exes=get_exes_path_from_makefiles(@input_makefile);
	my $count=0;
	
	for(@exes)
	{
		logger("��ʼ���exe�ļ�: $_\n");
		if(! -f $_)
		{
			logger("����: check_exe ��� |$_|  target�ļ� û������\n");
			print ("ie.pl ".dirname($_)."     ������\n")
		}
		else
		{
			$count++;
		}
	}
	print "һ���� ".scalar(@input_makefile)."��makefile , ���������  $count ��exe \n";
}

#��makefile �ļ��������� ��ȡ��Ӧ�� exe ����.
sub get_exes_path_from_makefiles(@)
{
	(my @makefiles)=@_;
	my @exes_path;
	if($^O=~/win/i)
	{
	@makefiles=  grep {/makefile.vc$|makefile_debug.vc$|makefile_release.vc$/} @makefiles;
	}
	else
	{
	@makefiles=  grep {/Makefile/} @makefiles;
	}
	logger("get_exes_path_from_makefiles �����".scalar(@makefiles)."��makefile*.vc�ļ�\n");
	for( @makefiles )
	{
		$mkfile_path=$_;
		if($^O=~/win/i)
		{
		my $target=_get_exe_from_makefile_vc($mkfile_path);
		}
		else
		{
		my $target=_get_exe_from_GRESHEM_MAKEFILE($mkfile_path);
		}

		logger("$mkfile_path ����ȡ���� exe Ϊ  all: $exe \n");
		if($target=~/\/|\\/)
		{
			logger("����: $mkfile_path �� $target ���� ������ ��ǰĿ¼�����ɵ�, ע��\n");
		}
		$target_path=$mkfile_path;
		$target_path=~s/makefile.vc$|makefile_debug.vc$|makefile_release.vc$/$target/g;
		push(@exes_path, $target_path);
	}
	return @exes_path;
}

#��makefile.vc makefile_debug.vc makefile_release.vc ���� ��ȡ���� exe dll lib 
sub _get_exe_from_makefile_vc($)
{
	(my $makefile_vc)=@_;
	my $exe=undef;
	open(MAKEFILE, $makefile_vc) or die("$makefile_vc ��ʧ��\n");;
	for(<MAKEFILE>)
	{
		if($_=~/^all:\s+(\S+)/)
		{
			$exe=$1;		
			goto DONE;
		}
	}	

DONE:
	close(MAKEFILE);
	return $exe;
}

#�� /bin/gen_makefile_from_file_latest.pl  ���ɵ�Makefile �����ȡ ������ɵ�exe 
#	EXEC = add_one_Wks
sub _get_exe_from_GRESHEM_MAKEFILE($)
{
	(my $makefile_vc)=@_;
	my $exe=undef;
	open(MAKEFILE, $makefile_vc) or die("$makefile_vc ��ʧ��\n");;
	for(<MAKEFILE>)
	{
		if($_=~/^EXEC.*=\s+(\S+)/)

		{
			$exe=$1;		
			goto DONE;
		}
	}	

DONE:
	close(MAKEFILE);
	return $exe;
}


########################################################################
#mainloop 
$pattern=shift;

use Cwd;
my $pwd=getcwd();
logger("#####################################################################\n");
logger("�� $pwd Ŀ¼��ʼ �ݹ����\n");

check_exe_start($pwd);
my @files=find_and_get_dsp_filelist($pwd);
if(scalar(@files) eq 0)
{
	my_die("��ǰĿ¼$pwd ��, dsp vc�����ļ�����Ϊ0\n");
}
#compile_with_dirs(@files);
my @filters;
if(defined($pattern))
{
	@filters=grep{/$pattern/i}  @files;
}
else
{
	@filters=@files;
}
compile_with_files(@filters);

#check_exe_end($pwd, @filters);
check_exe_end_with_makefile($pwd, @filters);
