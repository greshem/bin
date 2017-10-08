#!/usr/bin/perl
use Win32::Registry;
#Description: 	�޸�ע���EnvironmentΪ������ָ���Ļ�������
%g_environment_path_2005 = 
(
	"C:\\Program Files\\Microsoft Visual Studio 8\\Common7\\IDE"				=>"PATH",
	"C:\\Program Files\\Microsoft Visual Studio 8\\VC\\BIN"						=>"PATH",
	"C:\\Program Files\\Microsoft Visual Studio 8\\Common7\\Tools"				=>"PATH",
	"C:\\Program Files\\Microsoft Visual Studio 8\\Common7\\Tools\\bin"			=>"PATH",
	"C:\\Program Files\\Microsoft Visual Studio 8\\VC\\PlatformSDK\\bin"		=>"PATH",
	"C:\\Program Files\\Microsoft Visual Studio 8\\SDK\\v2.0\\bin"				=>"PATH",
	"C:\\WINDOWS\\Microsoft.NET\\Framework\\v2.0.50727"							=>"PATH",
	"C:\\Program Files\\Microsoft Visual Studio 8\\VC\\VCPackages"				=>"PATH",
	
	"C:\\Program Files\\Microsoft Visual Studio 8\\VC\\ATLMFC\\INCLUDE"			=>"INCLUDE",
	"C:\\Program Files\\Microsoft Visual Studio 8\\VC\\INCLUDE"					=>"INCLUDE",
	"C:\\Program Files\\Microsoft Visual Studio 8\\VC\\PlatformSDK\\include"	=>"INCLUDE",
	"C:\\Program Files\\Microsoft Visual Studio 8\\SDK\\v2.0\\include"			=>"INCLUDE",
	
	"C:\\Program Files\\Microsoft Visual Studio 8\\VC\\ATLMFC\\LIB"				=>"LIB",
	"C:\\Program Files\\Microsoft Visual Studio 8\\VC\\LIB"						=>"LIB",
	"C:\\Program Files\\Microsoft Visual Studio 8\\VC\\PlatformSDK\\lib"		=>"LIB",
	"C:\\Program Files\\Microsoft Visual Studio 8\\SDK\\v2.0\\lib"				=>"LIB"
					
);

modify_evn(PATH);
modify_evn(LIB);
modify_evn(INCLUDE);
########################################################################
sub modify_evn($)
{

	(my $env_2005) = @_;
	my $path_query;
	my $Register = "Environment";
	my $hkey;

        (my $path_2005) = get_evn_2005_path($env_2005);
	if( ! $HKEY_CURRENT_USER->Open($Register , $hkey) )
	{
		logger("[����:] vc2005ע���Ļ�������".$env_2005."������\n");
		die("vc2005ע���Ļ�������".$env_2005."������\n");
	}

	$hkey->QueryValueEx($env_2005, undef, $path_query);
	if(-1 == index($path_query,$path_2005))
	{
		#$path_query������Ӧ�ó������Ļ������������ܸ���
		if(!$path_query)
		{
			$hkey->SetValueEx($env_2005,undef, REG_SZ,$path_2005);
			logger("ע���������vc2005 ".$env_2005."�������\n");
			print "ע���������vc2005 ".$env_2005."�������\n";
		}
		else
		{
			$hkey->SetValueEx($env_2005,undef, REG_SZ,$path_query.";".$path_2005);
			logger("ע���������vc2005 ".$env_2005."��׷��\n");
			print "ע���������vc2005 ".$env_2005."��׷��\n";
		}
	}
	else
	{
        logger("[����:] ע���������vc2005 ".$env_2005."����ӣ������ظ�д\n");
      	print "[����:] ע���������vc2005 ".$env_2005."����ӣ������ظ�д\n"
	}
		
	$hkey->Close();	
}

sub get_evn_2005_path($)
{
	(my $in_env) = @_;
	(my $ret_path);
	while(($path_2005, $env_2005) = each %g_environment_path_2005)#fixme ������for����
	{
		if(! -d $path_2005)
		{
			logger("[����:] �޸� ".$in_env."����".$path_2005."·��������\n");
			die("\n�޸� ".$in_env."����".$path_2005."·��������\n");
		}
		elsif($env_2005 =~ /$in_env/)
		{
			if(!$ret_path)
			{
				$ret_path .= $path_2005;
			}
			else
			{
				$ret_path .=";";
				$ret_path .= $path_2005;
			}
		}
	}
#	logger("\n\n��ȡvc2005��������  ".$in_env." ��ֵ��".$ret_path);
	return $ret_path;
}

sub logger($)
{
	if( ! -d "d:\\log")
	{
		mkdir("d:\\log");
	}

	(my $log_str)=@_;
	open(FILE, ">> d:\\log\\add_vc2005_dev_env.log");
	print FILE $log_str;
	close(FILE);
}

