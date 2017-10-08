#!/usr/bin/perl
use File::Basename;
use File::Basename;

#��֮ǰ��һ������ָ������������, һ���ǿⲿ��,һ����Ӧ�ò���, lib �Ĳ��ֿ�������������ĳ���ʵ��.
########################################################################
#C:\Documents and Settings\Administrator\Application Data\AL ��alias ���Զ�����ļ������޸�.
#�ļ���ʽ����.
#name:AL Homepage
#execute:http://www.garageinnovation.org/AL
#name:New alias
#execute


########################################################################
#֮��Ӧ����ӵĿ�ݷ�ʽ: 
#TODO
#�ٶ�
#google
# smb_��һЩ����Ķ���
# al �ķ���һ�� reindex ����Ϣ ������������.
# tmp �ظ���
# host ��һЩip��ַת���� smb ��ַ
# netware �Ŀ�ݷ�ʽ nwfs ����Ϣ �� 
# ssh ��ݷ�ʽ�ı���. 
# vncviewer
########################################################################

our $g_al_cfg="C:\\Documents and Settings\\Administrator\\Application Data\\AL\\aliases.txt";


#��ǰĿ¼�µ� һ����Ŀ¼ ��ӵ� al �ļ�����ȥ. 
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

#ɾ���ظ��ļ�¼.
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
		logger_al_lib("[append_item]: �� $line  $exec_line û��, ���Ϊ��.\n");
		open(FILE, ">>".$g_al_cfg) or die("open file error\n");
		print FILE "name:".$name."\n";
		print FILE "execute:".$execute."\n";
		close(FILE);
	}
	else
	{
		#logger_al_lib("[append_item]: �� $line  $exec_line �Ѿ���ӹ���\n");
	}
}


#һЩǿ�Ƶı���, ���ܵı���, ���õ�һЩ����.
sub my_register_alias()
{
	append_item("al_aliases", 
		"C:\\Documents and Settings\\Administrator\\Application Data\\AL\\aliases.txt");
	append_item("al_application_DATA_C", 
		"C:\\Documents and Settings\\Administrator\\Application Data\\AL\\");

#append_item("richtech", 
	append_item("����", 
		"C:\\Documents and Settings\\Administrator\\����ʼ���˵�\\����\\����");

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
# Description: ��� name -> exec ��  al �������ļ�����ȥ.
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
		elsif($_=~/^#/)#ע����
		{
			next;
		}
		else			#������
		{
			logger_al_lib("����: ������ $_, al �ļ���Ӧ�������ָ�ʽ.");
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
			logger_al_lib("����: name Ϊ $name  , exec Ϊ $exec,  ����һ��Ϊ�� \n");
		}
	}
	close(FILE);
	return %name_to_exec;
}


#windows �� ��򵥵�, ��d:\\log Ŀ¼, ���Ӻ����������logger����.
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

#���Ӳ�̵�һ��Ŀ¼�� al �ı����ļ�����ȥ.
do("c:\\bin\\harddisk.pl");
do("c:\\bin\\grep_file.pl");
sub append_harddisk_alias()
{
	my @hdlabels=get_harddisks();

	my @depth1=glob_dirs(@hdlabels);
	#print join("\n", @depth1);
	for(@depth1)
	{
		if($_=~/(.):\\(.*)/) #d:\\tmp �ı����� tmp_d
		{
			#print "##".$1, $2."\n";
			my $key=$2."_".$1;
			append_item($key, $_);
		}
	}

}


append_harddisk_alias();
#һ������Ŀ¼�µĵ�һ����Ŀ¼, ��ӽ�ȥ.
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
#��� e:\\svn_working_path\\ ����� ���е�����Ŀ ��Щ�ؼ��ʱȽ����� ���Ǻ���
#��Ҫ��ӽ�ȥ.
sub append_one_dir($)
{

	use File::Basename;
	(my $input_dir)=@_;
	if (! -d $input_dir)
	{
		logger("$input_dir ����Ŀ¼, �˳� \n");
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

