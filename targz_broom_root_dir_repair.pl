#!/usr/bin/perl
#filename.tar.gz  他的主目录类似  filename/nouse/nouse2/nouse3/nouse4/allfile.cpp 
#																	 |allfile2.cpp 
#																	 |... 
#																	 |allfile4.cpp 
#称之为扫帚root目录, 这个程序主要再当前目录下 去掉  nouse nouse2  nouse3 nouse4 这样的目录.
#需要 extract_all_tar.pl 的配合.


#准备工作.
use Cwd;
our $g_pwd=getcwd();
check_targz_files();
preprocess_with_bash_space();
chdir_must_success_or_die($g_pwd);

########################################################################
do("/bin/get_root_dir_all_arch_type.pl");
cur_dir_broom_targz_root_dir_repair();

sub cur_dir_broom_targz_root_dir_repair()
{
	
	use Cwd;
	$pwd=getcwd();
	my @subdirs=grep { -d } (glob("$pwd/*")); 
	if(scalar(@subdirs) eq 0)
	{
		die("当前子目录为0, 应用 /bin/extract_all_tar.pl 解开所有的tar.gz \n");
	}
	for $each_dir( @subdirs )
	{
		print "#处理 $each_dir 目录\n";
		$sub_sub_dir=have_one_dir_and_no_files($each_dir);
		if(defined($sub_sub_dir))
		{
			logger("$each_dir 符合上移 条件 准备上移动\n");
			#print " cd $each_dir \n";
            #print " mv $sub_sub_dir/*  . \n"
			chdir_must_success_or_die($each_dir);
			system_exec_must_success_or_die("mv $sub_sub_dir/*  . ");
			path_must_be_empty($sub_sub_dir);
			rmrf_dir($sub_sub_dir);
		}	
		else
		{
			#logger("$each_dir 不符合上移条件\n");
			#print("$each_dir 不符合上移条件\n");
		}
	}

}
#只有一个子目录, 没有其他文件.
sub have_one_dir_and_no_files($)
{
	(my $curdir)=@_;
    my @subdirs=grep { -d } glob($curdir."/*");
    my @files=grep { -f } glob($curdir."/*");
    if(scalar(@subdirs) ne 1)
    {
        return undef;
    }
	
	if(scalar(@files) ne 0)
	{
		return undef;
	}
    return $subdirs[0];

}

#最简单的.
sub logger($)
{
	(my $log_str)=@_;
	open(FILE, ">> /var/log/targz_broom_root_dir_repair.log") or warn("open all.log error\n");
	print $log_str;
	print FILE $log_str;
	close(FILE);
}

sub chdir_must_success_or_die($)
{
	(my $dir)=@_;

	if(! chdir($dir))
	{ 
		my_die("$dirname_input 目录不次存在\n"); 
	}
}


sub system_exec_must_success_or_die($)
{
	(my $cmd_str)=@_;
	#logger("执行命令: $cmd_str\n");
	system($cmd_str);
	if($?>>8 ne 0)
	{
		my_die("命令行: $cmd_str 执行失败\n");
	}
}

sub path_must_be_empty($)
{
	(my $curdir)=@_;
    my @subdirs=grep { -d } glob($curdir."/*");
    my @files=grep { -f } glob($curdir."/*");
    if(scalar(@subdirs) ne 0)
    {
		my_die("$curdir 不为空目录, 目录不为空\n");
    }
	
	if(scalar(@files) ne 0)
	{
		my_die("$curdir 不为空目录,文件不为空\n");
	}
	return 1;
}

sub my_die($)
{
	(my $log_str)=@_;
	$log_str="错误:".$log_str;
	logger($log_str);
	die($log_str);
}

#实现和shell 里面: rm -rf input_dir  一样的效果.
sub rmrf_dir($)
{
	use File::Copy::Recursive qw(pathmk dirmove pathrm pathempty );
	(my $input_dir)=@_;
	if(! -d $input_dir)
	{
		logger("rm_rf: 输入的 $input_dir 不是目录 或者不存在 \n");
	}	

	pathempty($input_dir);
	pathrm($input_dir);

	logger("删除目录: $input_dir \n");
	my_die("Panic: $input_dir 文件没有删除掉") if(-d $output_zip_dir); #必不存在了.
}


sub check_targz_files()
{
	use Cwd;
	$pwd=getcwd();
	my @targzs=grep { -f } (glob("$pwd/*.tar.gz")); 
	if(scalar(@targzs) eq 0)
	{
		die("当前 tar.gz 为0, 退出\n");
	}

}

sub preprocess_with_bash_space()
{
	use Cwd;
	$pwd=getcwd();
	my @subdirs=grep { -d } (glob("$pwd/*")); 
	for $each_dir( @subdirs )
	{
		chdir_must_success_or_die($each_dir);
		system_exec_must_success_or_die("/bin/delete_space_for_bash.pl> /dev/null ");
	}

}

