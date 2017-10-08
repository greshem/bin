#!/usr/bin/perl
use Win32::Registry;
#Description: 	修改注册表Environment为编译器指定的环境变量
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
		logger("[错误:] vc98注册表的环境变量".$env_98."不存在\n");
		die("vc98注册表的环境变量".$env_98."不存在\n");
	}

	$hkey->QueryValueEx($env_98, undef, $path_query);
	if(-1 == index($path_query,$path_98))
	{
		#$path_query是其他应用程序保留的环境变量，不能覆盖
		if(!$path_query)
		{
			$hkey->SetValueEx($env_98,undef, REG_SZ,$path_98);
			logger("注册表环境变量vc98 ".$env_98."设置完成\n");
			print "注册表环境变量vc98 ".$env_98."设置完成\n"
		}
		else
		{
			$hkey->SetValueEx($env_98,undef, REG_SZ,$path_query.";".$path_98);
			logger("注册表环境变量vc98 ".$env_98."已追加\n");
			print "注册表环境变量vc98 ".$env_98."已追加\n"
		}
	}
	else
	{
		logger("注册表环境变量vc98 ".$env_98."已添加，无需重复写\n");
		print "注册表环境变量vc98 ".$env_98."已添加，无需重复写\n"
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
			logger("[错误:] 修改 ".$in_env."错误：".$path_98."路径不存在\n");
			die("\n修改 ".$in_env."错误：".$path_98."路径不存在\n");
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
#	logger("\n\n获取vc98环境变量  ".$in_env." 的值是".$ret_path);
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

