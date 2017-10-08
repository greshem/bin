#!/usr/bin/perl
use Win32::Registry;
#Description: 	�޸�ע���EnvironmentΪ������ָ���Ļ�������
%g_environment_path_98 = 
(
	"C:\\Program Files\\Microsoft Visual Studio\\VC98\\atl\\include"		=>"INCLUDE",
	"C:\\Program Files\\Microsoft Visual Studio\\VC98\\mfc\\include"		=>"INCLUDE",
	"C:\\Program Files\\Microsoft Visual Studio\\VC98\\include"				=>"INCLUDE",
		
	"C:\\Program Files\\Microsoft Visual Studio\\VC98\\mfc\\lib"			=>"LIB",
	"C:\\Program Files\\Microsoft Visual Studio\\VC98\\lib"					=>"LIB", 

	"C:\\Program Files\\Microsoft Visual Studio\\Common\\Tools\\WinNT"		=>"PATH",
	"C:\\Program Files\\Microsoft Visual Studio\\Common\\MSDev98\\Bin"		=>"PATH",
	"C:\\Program Files\\Microsoft Visual Studio\\Common\\Tools"				=>"PATH",
	"C:\\Program Files\\Microsoft Visual Studio\\VC98\\bin"					=>"PATH"					
);

modify_evn(PATH);
modify_evn(LIB);
modify_evn(INCLUDE);
########################################################################
sub modify_evn($)
{

	(my $env_98) = @_;
	my $path_query;
	my $Register = "Environment";
	my $hkey;

        (my $path_98) = get_evn_98_path($env_98);
	if( ! $HKEY_CURRENT_USER->Open($Register , $hkey) )
	{
		logger("[����:] vc98ע���Ļ�������".$env_98."������\n");
		die("vc98ע���Ļ�������".$env_98."������\n");
	}

	$hkey->QueryValueEx($env_98, undef, $path_query);
	if(-1 == index($path_query,$path_98))
	{
		#$path_query������Ӧ�ó������Ļ������������ܸ���
		if(!$path_query)
		{
			$hkey->SetValueEx($env_98,undef, REG_SZ,$path_98);
			logger("ע���������vc98 ".$env_98."�������\n");
			print "ע���������vc98 ".$env_98."�������\n"
		}
		else
		{
			$hkey->SetValueEx($env_98,undef, REG_SZ,$path_query.";".$path_98);
			logger("ע���������vc98 ".$env_98."��׷��\n");
			print "ע���������vc98 ".$env_98."��׷��\n"
		}
	}
	else
	{
		logger("ע���������vc98 ".$env_98."����ӣ������ظ�д\n");
		print "ע���������vc98 ".$env_98."����ӣ������ظ�д\n"
	}

	$hkey->Close();	
}

sub get_evn_98_path($)
{
	(my $in_env) = @_;
	(my $ret_path);
	while(($path_98, $env_98) = each %g_environment_path_98)
	{
		if(! -d $path_98)
		{
			logger("[����:] �޸� ".$in_env."����".$path_98."·��������\n");
			die("\n�޸� ".$in_env."����".$path_98."·��������\n");
		}
		elsif($env_98 =~ /$in_env/)
		{
			if(!$ret_path)
			{
				$ret_path .= $path_98;
			}
			else
			{
				$ret_path .=";";
				$ret_path .= $path_98;
			}
		}
	}
#	logger("\n\n��ȡvc98��������  ".$in_env." ��ֵ��".$ret_path);
	return $ret_path;
}

sub logger($)
{
	if( ! -d "d:\\log")
	{
		mkdir("d:\\log");
	}

	(my $log_str)=@_;
	open(FILE, ">> d:\\log\\add_vc98_dev_env.log");
	print FILE $log_str;
	close(FILE);
}

