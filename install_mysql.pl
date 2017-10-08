#!/usr/bin/perl -w
# /****************************************************************************
# * Description: ��װmysql �����ӿ� ��ͷ�ļ�.
# * @notice: ����İ�װ�����ֺ��� 
# *				һ���� ϵͳ��MYSQL.msi �İ�װ����  
# *				�ڶ�����: mysql.msi ��װ֮�� �ٿ����� d:\\usr\\lib\\
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
				warn("$each û�а�װ\n");
				logger("vc2003 û�а�װ ���Ȱ�װvc2003\n");
		}
	}
}

#########################################################################
sub mysql_have_install()
{

	if( ! -d "D:\\usr\\include\\mysql")
	{
		logger("mysql �Ѿ���װ��, �Ѿ��ж�Ӧ��ͷ�ļ�\n");
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
		warn("��û�а�װSQL ����û�а�װ����ʵ�� ���ֶ���װMySQL\n");
		logger(" ��û�а�װSQL ���ֶ���װMySQL\n");
		return undef;
	}
	else
	{
		logger("�Ѿ���װ׼��ע�� \n");
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
	(! -d $delete_dir) && logger(" $delete_dir Ŀ¼ɾ���ɹ�\n");
	(  -d $delete_dir) && logger(" $delete_dir Ŀ¼ɾ��ʧ��\n");
}
sub check_file_delete($)
{
	(my $delete_file)=@_;
	(! -d $delete_file) && logger(" $delete_file �ļ�ɾ���ɹ�\n");
	(  -d $delete_file) && logger(" $delete_file �ļ�ɾ��ʧ��\n");
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
			logger("mysql-essential-5.1.58-win32.msi �ļ������� \n");
			logger("�� sdb1://F:/_x_file/_xfile_2011_08/mysql-essential-5.1.58-win32.msi���� \n");
			die("mysql-essential-5.1.58-win32.msi �ļ������� \n");
		}
	}
	else
	{
		logger("  mysql-essential-5.1.58-win32.msi �Ѿ���װ����, \n");
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
