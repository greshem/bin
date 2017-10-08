
########################################################################
#
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

	my_die("Panic: $input_dir 文件没有删除掉") if(-d $output_zip_dir); #必不存在了.
}

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


sub mkdir_if_not_exist_or_die($)
{
	(my $dir)=@_;
	if(-d $dir)
	{
		logger(" $output_zip_dir 已经生成过了,不用再生成了\n");
	}
	else
	{
		mkdir($dir);
	}
}
sub dir_must_exist_or_die($)
{
	(my $dir)=@_;
	#print "Deal With: ".$dir."\n";
	if(! -d $dir)
	{
		my_die("PANIC: $dir 应该存在, 但是不存在, \n");
	}
}
sub dir_must_not_exist($)
{
	(my $dir)=@_;
	if( -d $dir)
	{
		my_die("PANIC: $dir  应该不存在, 但是存在了. \n");
	}
}

sub file_must_exist($)
{
	(my $file)=@_;
	if(! -f $file)
	{
		my_die("PANIC: $file 文件不存在, \n");
	}
}

