#!/usr/bin/perl
use Win32::Registry;
#Description: 	�޸�ע���EnvironmentΪ������ָ���Ļ�������
%g_environment_path_2003 = 
(
	"C:\\Program Files\\Microsoft Visual Studio .NET 2003\\Common7\\IDE"							=>"PATH",
	"C:\\Program Files\\Microsoft Visual Studio .NET 2003\\Common7\\Tools"							=>"PATH",
	"C:\\Program Files\\Microsoft Visual Studio .NET 2003\\Common7\\Tools\\bin"						=>"PATH",
#	"C:\\Program Files\\Microsoft Visual Studio .NET 2003\\Common7\\Tools\\bin\\prerelease" 		=>"PATH",
	"C:\\Program Files\\Microsoft Visual Studio .NET 2003\\SDK\\v1.1\\bin" 							=>"PATH",
	"C:\\Program Files\\Microsoft Visual Studio .NET 2003\\VC7\\BIN" 								=>"PATH",

	"C:\\Program Files\\Microsoft Visual Studio .NET 2003\\SDK\\v1.1\\include"						=>"INCLUDE",
	"C:\\Program Files\\Microsoft Visual Studio .NET 2003\\VC7\\ATLMFC\\INCLUDE"					=>"INCLUDE",
	"C:\\Program Files\\Microsoft Visual Studio .NET 2003\\VC7\\INCLUDE"							=> "INCLUDE",
	"C:\\Program Files\\Microsoft Visual Studio .NET 2003\\VC7\\PlatformSDK\\include"				=> "INCLUDE",
#	"C:\\Program Files\\Microsoft Visual Studio .NET 2003\\VC7\\PlatformSDK\\include\\prerelease"	=> "INCLUDE",		

	"C:\\Program Files\\Microsoft Visual Studio .NET 2003\\SDK\\v1.1\\Lib"							=>"LIB",
	"C:\\Program Files\\Microsoft Visual Studio .NET 2003\\SDK\\v1.1\\lib"							=> "LIB",
	"C:\\Program Files\\Microsoft Visual Studio .NET 2003\\VC7\\ATLMFC\\LIB"						=> "LIB",
	"C:\\Program Files\\Microsoft Visual Studio .NET 2003\\VC7\\LIB"								=> "LIB",
	"C:\\Program Files\\Microsoft Visual Studio .NET 2003\\VC7\\PlatformSDK\\lib"					=> "LIB",
#	"C:\\Program Files\\Microsoft Visual Studio .NET 2003\\VC7\\PlatformSDK\\lib\\prerelease"		=> "LIB"
					
);

modify_evn(PATH);
modify_evn(LIB);
modify_evn(INCLUDE);
########################################################################
sub modify_evn($)
{

	(my $env_2003) = @_;
	my $path_query;
	my $Register = "Environment";
	my $hkey;

        (my $path_2003) = get_evn_2003_path($env_2003);
	if( ! $HKEY_CURRENT_USER->Open($Register , $hkey) )
	{
		logger("[����:] vc2003ע���Ļ�������".$env_2003."������\n");
		die("vc2003ע���Ļ�������".$env_2003."������\n");
	}

	$hkey->QueryValueEx($env_2003, undef, $path_query);
	if(-1 == index($path_query,$path_2003))
	{
		#$path_query������Ӧ�ó������Ļ������������ܸ���
		if(!$path_query)
		{
			$hkey->SetValueEx($env_2003,undef, REG_SZ,$path_2003);
			logger("ע���������vc2003 ".$env_2003."�������\n");
			print "ע���������vc2003 ".$env_2003."�������\n";
		}
		else
		{
			$hkey->SetValueEx($env_2003,undef, REG_SZ,$path_query.";".$path_2003);
			logger("ע���������vc2003 ".$env_2003."��׷��\n");
			print "ע���������vc2003 ".$env_2003."��׷��\n";
		}
	}
	else
	{
   	    logger("[����:]ע���������vc2003 ".$env_2003."����ӣ������ظ�д\n");
        print "[����:] ע���������vc2003 ".$env_2003."����ӣ������ظ�д\n"
	}
		
	$hkey->Close();	
}

sub get_evn_2003_path($)
{
	(my $in_env) = @_;
	(my $ret_path);
	while(($path_2003, $env_2003) = each %g_environment_path_2003)#fixme ������for����
	{
		if(! -d $path_2003)
		{
			logger("[����:] �޸� ".$in_env."����".$path_2003."·��������\n");
			die("�޸� ".$in_env."����".$path_2003."·��������\n");
		}
		elsif($env_2003 =~ /$in_env/)
		{
			if(!$ret_path)
			{
				$ret_path .= $path_2003;
			}
			else
			{
				$ret_path .=";";
				$ret_path .= $path_2003;
			}
		}
	}
#	logger("\n\n��ȡvc2003��������  ".$in_env." ��ֵ��".$ret_path);
	return $ret_path;
}

sub logger($)
{
	if( ! -d "d:\\log")
	{
		mkdir("d:\\log");
	}

	(my $log_str)=@_;
	open(FILE, ">> d:\\log\\add_vc2003_dev_env.log");
	print FILE $log_str;
	close(FILE);
}

