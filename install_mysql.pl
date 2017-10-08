#!/usr/bin/perl -w
# /****************************************************************************
# * Description: 安装mysql 的链接库 和头文件.
# * @notice: 这里的安装有两种含义 
# *				一种是 系统的MYSQL.msi 的安装还有  
# *				第二种是: mysql.msi 安装之后 再拷贝到 d:\\usr\\lib\\
# * *************************************************************************/
sub check_cpp_env()
{
	
	$vc_2003= "C:\\Program Files\\Microsoft Visual Studio\ .NET\ 2003\\Vc7\\bin";
	$vc_2003_upper= "C:\\Program Files\\Microsoft\ Visual Studio\ .NET\ 2003\\VC7\\BIN";
	$bakefile="C:\\Program Files\\Bakefile";
	$cygwin="c:\\cygwin";
	push( @progs_path , $cygwin);
   	push( @progs_path , $vc_2003);
	push( @progs_path , $vc_2003_upper);
	push(@progs_path, $bakefile);
	
	for $each (@progs_path)
	{
		if( ! -d  $each)
		{
				warn("$each 没有安装\n");
				logger("vc2003 没有安装 请先安装vc2003\n");
		}
	}
}

#########################################################################
sub mysql_have_install()
{

	if( ! -d "D:\\usr\\include\\mysql")
	{
		logger("mysql 已经安装了, 已经有对应的头文件\n");
		return 0;
	}
	if( ! -d  "D:\\usr\\lib")
	{
		mkdir("D:\\usr\\lib");
	}
	if( ! -d  "D:\\usr\\include")
	{
		mkdir("D:\\usr\\include");
	}
}


sub system_mysql_have_install()
{
	my $install_path1="C:\\Program Files\\MySQL\\MySQL Server 5.1\\include";
	if ( ! -d  $install_path1)
	{
		warn("还没有安装SQL 或者没有安装开发实例 请手动安装MySQL\n");
		logger(" 还没有安装SQL 请手动安装MySQL\n");
		return undef;
	}
	else
	{
		logger("已经安装准备注册 \n");
	}
	return 1;
}



sub copy_install_mysql()
{
	mkdir("D:\\usr\\include\\mysql");
	mkdir("D:\\usr\\lib\\mysql");
	system('xcopy /s "C:\\Program Files\\MySQL\\MySQL Server 5.1\\include"  D:\\usr\\include\\mysql');
	system('xcopy /s "C:\\Program Files\\MySQL\\MySQL Server 5.1\\lib"  D:\\usr\\lib\\mysql')

}

sub logger($)
{
	(my $log_str)=@_;
	
	if($^O=~/win32/i)
	{
		if(! -d ("d:\\log"))
		{
			mkdir("d:\\log");
		}
		open(FILE, ">>  d:\\log\\mysql_install.log");
	}
	else
	{
		open(FILE, ">> /var/log/mysql_install.log");
	}
		print FILE $log_str;
		close(FILE);
}


sub check_dir_delete($)
{
	(my $delete_dir)=@_;
	(! -d $delete_dir) && logger(" $delete_dir 目录删除成功\n");
	(  -d $delete_dir) && logger(" $delete_dir 目录删除失败\n");
}
sub check_file_delete($)
{
	(my $delete_file)=@_;
	(! -d $delete_file) && logger(" $delete_file 文件删除成功\n");
	(  -d $delete_file) && logger(" $delete_file 文件删除失败\n");
}
########################################################################
sub clean_mysql()
{
	my $include_dir= "d:\\usr\\include\\mysql" ;
	system("erase /S   /Q  $include_dir ");
	check_dir_delete($include_dir);
	
	my $lib_dir= "d:\\usr\\lib\\mysql" ;
	system("erase /S   /Q  $lib_dir ");
	check_dir_delete($lib_dir);
}
sub install_mysql()
{
	
	check_cpp_env();

	if( ! system_mysql_have_install()) 
	{
		if( ! -f "mysql-essential-5.1.58-win32.msi")
		{
			logger("mysql-essential-5.1.58-win32.msi 文件不存在 \n");
			logger("从 sdb1://F:/_x_file/_xfile_2011_08/mysql-essential-5.1.58-win32.msi拷贝 \n");
			die("mysql-essential-5.1.58-win32.msi 文件不存在 \n");
		}
	}
	else
	{
		logger("  mysql-essential-5.1.58-win32.msi 已经安装过了, \n");
	}
	mysql_have_install();
	copy_install_mysql();
}

$mode= shift;
if(defined($mode))
{
	clean_mysql();
}
else
{
	install_mysql();
}
