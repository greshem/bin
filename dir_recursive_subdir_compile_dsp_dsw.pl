#!/usr/bin/perl
#日志跨平台在两个操作系统上
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
	#print FILE "错误: ";
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
#只是一个概念 dsp_file 指 的是 dsp dsp  makefile.vc *.mak  vcproj 工程文件.
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
			logger("错误: dsp $each_dsp  文件 不是绝对路径\n");
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
	$log_str="错误:".$log_str;
	logger($log_str);
	die($log_str);
}

sub chdir_must_success_or_die($)
{
	(my $dir)=@_;

	if(! chdir($dir))
	{ 
		my_die("$dirname_input 目录不次存在\n"); 
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
		logger("开始处理 $each_dsp 文件\n");
		if($each_dsp !~/^\// &&   $each_dsp !~/^[a-z]\:/i )
		{
			logger("错误: dsp $each_dsp  文件 不是绝对路径\n");
		}
		if( ! -f $each_dsp )
		{
			logger("错误: $each_dsp 不是文件\n");
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
			logger("错误: 不支持 vcproj 的编译\n");
		}
		elsif($each_dsp=~/makefile.vc$|makefile_debug.vc$|makefile_release.vc$/i)
		{
			logger("nmake 处理 $each_dsp 文件\n");
			my $dirname=dirname($each_dsp);
			chdir_must_success_or_die($dirname);
			system_exec_with_log("nmake /f  $each_dsp clean \n");
			system_exec_with_log("nmake /f  $each_dsp \n");
		}
		elsif($each_dsp=~/mak$/i)
		{
			#logger("错误: 不支持 vcproj 的编译\n");
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
			logger("错误: 不支持 项目工程文件, $each_dsp\n");
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
	logger("执行命令: $cmd_str\n");
	system($cmd_str);
	if($?>>8 ne 0)
	{
		my_die("命令行: $cmd_str 执行失败\n");
	}
}

sub system_exec_with_log($)
{
	(my $cmd_str)=@_;
	logger("执行命令: $cmd_str\n");
	system($cmd_str);
	if($?>>8 ne 0)
	{
		logger("错误: 命令行: $cmd_str 执行失败\n");
	}
}

sub check_exe_start($)
{
	(my $my_pwd)=@_;
	chdir_must_success_or_die($my_pwd);
	my @exes=find_and_get_exe_filelist($my_pwd);
	if(scalar(@exes) eq 0 )
	{
		logger("开始: 当前目录$pwd 下, exe文件数量为0, 开始编译\n");
	}
	else
	{
		#my_die("开始: 当前目录$pwd 下, exe文件数量不为0, 为".scalar(@exes)." 这个工程不用编译\n");
		logger("开始: 当前目录$pwd 下, exe文件数量不为0, 为".scalar(@exes)." 这个工程可以不用编译, 但是还是进行编译\n");
	}
}

sub check_exe_end_1($)
{
	(my $my_pwd)=@_;
	chdir_must_success_or_die($my_pwd);
	my @exes=find_and_get_exe_filelist($my_pwd);
	if(scalar(@exes) eq 0 )
	{
		logger("PANIC_严重错误: 结束: 当前目录$pwd 下, exe文件数量还是为0,  需要人工参与编译\n");
	}
}

sub check_exe_end_with_makefile($@)
{
	use File::Basename;
	(my $my_pwd, @input_makefile)=@_;

	chdir_must_success_or_die($my_pwd);
	
	logger("check_exe 最后有".scalar(@input_makefile)."个 工程文件\n");
	my @others= grep {$_!~/makefile.vc$|makefile_debug.vc$|makefile_release.vc$/} @input_makefile;
	if(scalar(@others) ne 0)
	{
		logger("注意: 其他一共 ".scalar(@others)."个项目工程 文件不支持 exe 的检查\n"); 
	}
	my @exes=get_exes_path_from_makefiles(@input_makefile);
	my $count=0;
	
	for(@exes)
	{
		logger("开始检测exe文件: $_\n");
		if(! -f $_)
		{
			logger("错误: check_exe 最后 |$_|  target文件 没有生成\n");
			print ("ie.pl ".dirname($_)."     检查错误\n")
		}
		else
		{
			$count++;
		}
	}
	print "一共有 ".scalar(@input_makefile)."个makefile , 共编译出来  $count 个exe \n";
}

#从makefile 文件数组里面 获取对应的 exe 数组.
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
	logger("get_exes_path_from_makefiles 最后有".scalar(@makefiles)."个makefile*.vc文件\n");
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

		logger("$mkfile_path 最后获取到的 exe 为  all: $exe \n");
		if($target=~/\/|\\/)
		{
			logger("警告: $mkfile_path 的 $target 对象 不是在 当前目录下生成的, 注意\n");
		}
		$target_path=$mkfile_path;
		$target_path=~s/makefile.vc$|makefile_debug.vc$|makefile_release.vc$/$target/g;
		push(@exes_path, $target_path);
	}
	return @exes_path;
}

#从makefile.vc makefile_debug.vc makefile_release.vc 里面 获取最后的 exe dll lib 
sub _get_exe_from_makefile_vc($)
{
	(my $makefile_vc)=@_;
	my $exe=undef;
	open(MAKEFILE, $makefile_vc) or die("$makefile_vc 打开失败\n");;
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

#从 /bin/gen_makefile_from_file_latest.pl  生成的Makefile 里面获取 最后生成的exe 
#	EXEC = add_one_Wks
sub _get_exe_from_GRESHEM_MAKEFILE($)
{
	(my $makefile_vc)=@_;
	my $exe=undef;
	open(MAKEFILE, $makefile_vc) or die("$makefile_vc 打开失败\n");;
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
logger("在 $pwd 目录开始 递归编译\n");

check_exe_start($pwd);
my @files=find_and_get_dsp_filelist($pwd);
if(scalar(@files) eq 0)
{
	my_die("当前目录$pwd 下, dsp vc工程文件数量为0\n");
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
