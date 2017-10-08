#!/usr/bin/perl
use File::Basename;
use File::Basename;

#把之前的一个程序分割成两个部分了, 一个是库部分,一个是应用部分, lib 的部分可以另外给其他的程序实用.
########################################################################
#C:\Documents and Settings\Administrator\Application Data\AL 有alias 可以对这个文件进行修改.
#文件格式如下.
#name:AL Homepage
#execute:http://www.garageinnovation.org/AL
#name:New alias
#execute


########################################################################
#之后应该添加的快捷方式: 
#TODO
#百度
#google
# smb_的一些共享的东西
# al 的发送一个 reindex 的消息 让他重新索引.
# tmp 重复了
# host 的一些ip地址转换成 smb 地址
# netware 的快捷方式 nwfs 的信息 从 
# ssh 快捷方式的保存. 
# vncviewer
########################################################################

our $g_al_cfg="C:\\Documents and Settings\\Administrator\\Application Data\\AL\\aliases.txt";


#当前目录下的 一级子目录 添加到 al 文件里面去. 
sub append_cur_dir_svn_alias()
{
	open(FILE, ">>C:\\Documents and Settings\\Administrator\\Application Data\\AL\\aliases.txt")  or die("Open file error\n");
	for  (glob("$path\\*"))
	{
		if ( ! -d $_)
		{
			next;
		}	
		print FILE  "name:".basename($_)."\n";
		print FILE  "execute:".$_."\n";		
	}
	
	close(FILE);
}

#删除重复的记录.
sub remove_duplicate_record()
{
	open(FILE, "C:\\Documents and Settings\\Administrator\\Application Data\\AL\\aliases.txt")  or die("Open file error\n");
	my %hash,$key,$value;
	
	@file_contents = <FILE>;
	while(@file_contents)
	{
		$key = shift(@file_contents);
		while($key =~ /^#/)
		{
			$key = shift(@file_contents);
		}
		$value = shift(@file_contents);
		while($value =~/^#/)
		{
			$value = shift(@file_contents);
		}
		$hash{$key} = $value;
	}
	print %hash;
	close(FILE);
	open(FILE, ">C:\\Documents and Settings\\Administrator\\Application Data\\AL\\aliases.txt")  or die("Open file error\n");
	print FILE %hash;
	close(FILE);
}

sub append_item($$)
{
	(my $name, my $execute)=@_;
	my $line="name:".$name."\n";
	my $exec_line="execute:".$execute."\n";

	if( ! shell_grep($line, $g_al_cfg))
	{
		logger_al_lib("[append_item]: 行 $line  $exec_line 没有, 添加为新.\n");
		open(FILE, ">>".$g_al_cfg) or die("open file error\n");
		print FILE "name:".$name."\n";
		print FILE "execute:".$execute."\n";
		close(FILE);
	}
	else
	{
		#logger_al_lib("[append_item]: 行 $line  $exec_line 已经添加过了\n");
	}
}


#一些强制的别名, 功能的别名, 常用的一些别名.
sub my_register_alias()
{
	append_item("al_aliases", 
		"C:\\Documents and Settings\\Administrator\\Application Data\\AL\\aliases.txt");
	append_item("al_application_DATA_C", 
		"C:\\Documents and Settings\\Administrator\\Application Data\\AL\\");

#append_item("richtech", 
	append_item("启动", 
		"C:\\Documents and Settings\\Administrator\\「开始」菜单\\程序\\启动");

	append_item("rflash",
		"C:\\Documents and Settings\\Administrator\\Local Settings\\Temp\\RFlash");
	append_item("TEMP", "C:\\WINDOWS\\TEMP");
	append_item("TMP", "C:\\WINDOWS\\TEMP");
	append_item("system32_C", "C:\\WINDOWS\\system32");
	append_item("windows_dir_C", "C:\\WINDOWS\\");
	append_item("drivers_C", "C:\\WINDOWS\\Drivers");
	append_item("log_temp_windows_C", "C:\\WINDOWS\\temp\\Log");
}

#***************************************************************************
# Description: 添加 name -> exec 到  al 的配置文件里面去.
# @param 	
# @return 	
#***************************************************************************/
sub change_al_cfg_to_hash()
{
	open(FILE, ">".$g_al_cfg) or die("open $g_al_cfg error, $! \n");
	my %name_to_exec; my $name; my $exec;
	for(<FILE>)
	{
		if($_=~/name:(.*)/)
		{
			$name=$1;
		}
		elsif($_=~/execute:(.*)/)
		{
			$exec=$1;
		}
		elsif($_=~/^#/)#注释行
		{
			next;
		}
		else			#其他行
		{
			logger_al_lib("错误: 错误行 $_, al 文件不应该有这种格式.");
			next;
		}

		if(defined($name) && defined($exec))
		{
			$last_exec=$name_to_exec{$name};
			if(defined($last_exec))
			{
				$name_to_exec{$name}=$last_exec."|".$exec;
			}
			else
			{
				$name_to_exec{$name}=$exec;
			}
		}
		else
		{
			logger_al_lib("错误: name 为 $name  , exec 为 $exec,  至少一个为空 \n");
		}
	}
	close(FILE);
	return %name_to_exec;
}


#windows 下 最简单的, 到d:\\log 目录, 房子和其他程序的logger重名.
sub logger_al_lib($)
{
	if(! -d ("d:\\log"))
	{
		mkdir("d:\\log");
	}

	(my $log_str)=@_;
	open(FILE, ">> d:\\log\\al_application_alias_add.log") or warn("open name.log error\n");
	print FILE $log_str;
	close(FILE);
}

#添加硬盘的一级目录到 al 的别名文件里面去.
do("c:\\bin\\harddisk.pl");
do("c:\\bin\\grep_file.pl");
sub append_harddisk_alias()
{
	my @hdlabels=get_harddisks();

	my @depth1=glob_dirs(@hdlabels);
	#print join("\n", @depth1);
	for(@depth1)
	{
		if($_=~/(.):\\(.*)/) #d:\\tmp 的别名是 tmp_d
		{
			#print "##".$1, $2."\n";
			my $key=$2."_".$1;
			append_item($key, $_);
		}
	}

}


append_harddisk_alias();
#一个磁盘目录下的第一集子目录, 添加进去.
sub append_disk_one_depth_append_to_al()
{
	(my $driver)=@_;
	my @dirs= grep {-d } (glob("$driver:\\*"));
	for  (@dirs)
	{
		if($_=~/(.):\\(.*)/)
		{
			my $key=$2."_".$1;
			append_item($key, $_);
		}
	}
}

########################################################################
#添加 e:\\svn_working_path\\ 下面的 所有的子项目 这些关键词比较特殊 但是很有
#必要添加进去.
sub append_one_dir($)
{

	use File::Basename;
	(my $input_dir)=@_;
	if (! -d $input_dir)
	{
		logger("$input_dir 不是目录, 退出 \n");
		return ;
	}
	my @dirs=grep {-d} (glob_one_dir($input_dir));
	for(@dirs)	
	{
		my $key=basename($_);
		my $value=$_;
		append_item($key, $value);
	}
}

