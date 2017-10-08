#!/usr/bin/perl
use Win32::Registry;
#Description: 	�޸�ע���EnvironmentΪ������ָ���Ļ�������
%g_environment_path_2008 = 
(
	"C:\\Program Files\\Microsoft Visual Studio 9.0\\Common7\\IDE"			=>"PATH",
	"C:\\Program Files\\Microsoft Visual Studio 9.0\\VC\\BIN"				=>"PATH",
	"C:\\Program Files\\Microsoft Visual Studio 9.0\\Common7\\Tools"		=>"PATH",
	"C:\\WINDOWS\\Microsofi.NET\\Framework\\v3.5"							=>"PATH",
	"C:\\WINDOWS\\Microsoft.NET\\Framework\\v2.0.50727"						=>"PATH",
	"C:\\Program Files\\Microsoft Visual Studio 9.0\\VC\\VCPackages"		=>"PATH",
	"C:\\Program Files\\Microsoft SDKs\\Windows\\v7.0A\\bin"				=>"PATH",
	
	"C:\\Program Files\\Microsoft Visual Studio 9.0\\VC\\ATLMFC\\INCLUDE"	=>"INCLUDE",
	"C:\\Program Files\\Microsoft Visual Studio 9.0\\VC\\INCLUDE"			=>"INCLUDE",
	"C:\\Program Files\\Microsoft SDKs\\Windows\\v7.0A\\Include"			=>"INCLUDE",
	
	"C:\\Program Files\\Microsoft Visual Studio 9.0\\VC\\ATLMFC\\LIB"		=>"LIB",
	"C:\\Program Files\\Microsoft Visual Studio 9.0\\VC\\LIB"				=>"LIB",
	"C:\\Program Files\\Microsoft SDKs\\Windows\\v7.0A\\Lib"				=>"LIB"
					
);

modify_evn(PATH);
modify_evn(LIB);
modify_evn(INCLUDE);
########################################################################
sub modify_evn($)
{

	(my $env_2008) = @_;
	my $path_query;
	my $Register = "Environment";
	my $hkey;

        (my $path_2008) = get_evn_2008_path($env_2008);
	if( ! $HKEY_CURRENT_USER->Open($Register , $hkey) )
	{
		logger("[����:] vc2008ע���Ļ�������".$env_2008."������\n");
		die("vc2008ע���Ļ�������".$env_2008."������\n");
	}

	$hkey->QueryValueEx($env_2008, undef, $path_query);
	if(-1 == index($path_query,$path_2008))
	{
		#$path_query������Ӧ�ó������Ļ������������ܸ���
		if(!$path_query)
		{
			$hkey->SetValueEx($env_2008,undef, REG_SZ,$path_2008);
			logger("ע���������vc2008 ".$env_2008."�������\n");
			print "ע���������vc2008 ".$env_2008."�������\n";
		}
		else
		{
			$hkey->SetValueEx($env_2008,undef, REG_SZ,$path_query.";".$path_2008);
			logger("ע���������vc2008 ".$env_2008."��׷��\n");
			print "ע���������vc2008 ".$env_2008."��׷��\n";
		}
	}
	else
	{
 		logger("[����:] ע���������vc2008 ".$env_2008."����ӣ������ظ�д\n");
        print "[����:] ע���������vc2008 ".$env_2008."����ӣ������ظ�д\n"
	}

	$hkey->Close();	
}

sub get_evn_2008_path($)
{
	(my $in_env) = @_;
	(my $ret_path);
	while(($path_2008, $env_2008) = each %g_environment_path_2008)#fixme ������for����
	{
		if(! -d $path_2008)
		{
			logger("[����:] �޸� ".$in_env."����".$path_2008."·��������\n");
			die("�޸� ".$in_env."����".$path_2008."·��������\n");
		}
		elsif($env_2008 =~ /$in_env/)
		{
			if(!$ret_path)
			{
				$ret_path .= $path_2008;
			}
			else
			{
				$ret_path .=";";
				$ret_path .= $path_2008;
			}
		}
	}
#	logger("\n\n��ȡvc2008��������  ".$in_env." ��ֵ��".$ret_path);
	return $ret_path;
}

sub logger($)
{
	if( ! -d "d:\\log")
	{
		mkdir("d:\\log");
	}

	(my $log_str)=@_;
	open(FILE, ">> d:\\log\\add_vc2008_dev_env.log");
	print FILE $log_str;
	close(FILE);
}

