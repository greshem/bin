#!/usr/bin/perl
#***************************************************************************
# Description: ����Ӳ�̵�һ����Ŀ¼, �Լ�ע���·��.	
# @param 	
# @return 	
#***************************************************************************/
init_check();
#remove_duplicate_record();

#���е�Ӳ�̵�һ����Ŀ¼.
for((C..Z))
{
	print "���� ����$_:\n";
	append_disk_one_depth_append_to_al($_);	
}
append_harddisk_alias();
append_register_path();
append_programs_alias_path();
my_register_alias();


########################################################################
#�ѻ�����������Ķ����ӵ�alias ����ȥ.
sub change_ENV_to_alias()
{
}

########################################################################
#�����пո�� program files ��Щ����.
#�������glob �ķ�ʽ �ſ��Զ�ȡ��.
#������  " " 
#bug_40m:  '' �ķ�ʽ�ſ��Դ���� Programs File �ո������.
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
#���˵�ע���·��.
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
#windows �� ��򵥵�, ��d:\\log Ŀ¼
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
			logger(" $win_lib_path ������\n");
		}
		do($win_lib_path);
	}
	else
	{
		my $linux_lib_path="/bin/al_application_alias_lib.pl"; 
		if( ! -f  $linux_lib_path) 
		{logger(" $linux_lib_path ������\n");
		}
		do($linux_lib_path);
	}
	

	if(! -f $g_al_cfg)
	{
		logger(" $g_al_cfg ������, ����һ��\n");
		open(FILE,  ">>".$g_al_cfg);
		close(FILE);
	}
}

