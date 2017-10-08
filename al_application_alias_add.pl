#!/usr/bin/perl
#***************************************************************************
# Description: 所有硬盘的一级子目录, 自己注册的路径.	
# @param 	
# @return 	
#***************************************************************************/
init_check();
#remove_duplicate_record();

#所有的硬盘的一级子目录.
for((C..Z))
{
	print "处理 磁盘$_:\n";
	append_disk_one_depth_append_to_al($_);	
}
append_harddisk_alias();
append_register_path();
append_programs_alias_path();
my_register_alias();


########################################################################
#把环境变量里面的东西加到alias 里面去.
sub change_ENV_to_alias()
{
}

########################################################################
#对于有空格的 program files 有些特殊.
#用下面的glob 的方式 才可以读取到.
#不能用  " " 
#bug_40m:  '' 的方式才可以处理掉 Programs File 空格的问题.
sub append_programs_alias_path()
{
	my @tmp=grep {-d } (glob('C:/Program\ Files/*')); 
	for(@tmp)
	{
		my $key=basename($_);
		$key.="_Program_C";
		my $value=$_;
		$value=~s/\//\\/g;
		append_item($key , $value);
	}
}

########################################################################
#个人的注册的路径.
sub append_register_path()
{
	append_one_dir("E:\\svn_working_path");
	append_one_dir("E:\\svn_working_path\\rich_addvalue2\\branches\\rich_addvalue3");
	append_one_dir("E:\\svn_working_path\\rich_addvalue2\\branches\\rich_addvalue3\\tools");
	append_one_dir("E:\\svn_working_path\\doc_collaboration");
	append_one_dir("C:\\Program\ Files\\");
	append_one_dir("J:\\_x_file");
}

########################################################################
#windows 下 最简单的, 到d:\\log 目录
sub logger($)
{
	if(! -d ("d:\\log"))
	{
		mkdir("d:\\log");
	}

	(my $log_str)=@_;
	open(FILE, ">> d:\\log\\al_application.log") or warn("open name.log error\n");
	print FILE $log_str;
	close(FILE);
}


sub init_check()
{
	our $g_al_cfg="C:\\Documents and Settings\\Administrator\\Application Data\\AL\\aliases.txt";
	if($^O=~/win/i)
	{
		my $win_lib_path= "c:\\bin\\al_application_alias_lib.pl";
		if( ! -f  $win_lib_path) 
		{ 
			logger(" $win_lib_path 不存在\n");
		}
		do($win_lib_path);
	}
	else
	{
		my $linux_lib_path="/bin/al_application_alias_lib.pl"; 
		if( ! -f  $linux_lib_path) 
		{logger(" $linux_lib_path 不存在\n");
		}
		do($linux_lib_path);
	}
	

	if(! -f $g_al_cfg)
	{
		logger(" $g_al_cfg 不存在, 创建一个\n");
		open(FILE,  ">>".$g_al_cfg);
		close(FILE);
	}
}

