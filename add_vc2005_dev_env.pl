#!/usr/bin/perl
use Win32::Registry;
#Description: 	修改注册表Environment为编译器指定的环境变量
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
		logger("[错误:] vc2005注册表的环境变量".$env_2005."不存在\n");
		die("vc2005注册表的环境变量".$env_2005."不存在\n");
	}

	$hkey->QueryValueEx($env_2005, undef, $path_query);
	if(-1 == index($path_query,$path_2005))
	{
		#$path_query是其他应用程序保留的环境变量，不能覆盖
		if(!$path_query)
		{
			$hkey->SetValueEx($env_2005,undef, REG_SZ,$path_2005);
			logger("注册表环境变量vc2005 ".$env_2005."设置完成\n");
			print "注册表环境变量vc2005 ".$env_2005."设置完成\n";
		}
		else
		{
			$hkey->SetValueEx($env_2005,undef, REG_SZ,$path_query.";".$path_2005);
			logger("注册表环境变量vc2005 ".$env_2005."已追加\n");
			print "注册表环境变量vc2005 ".$env_2005."已追加\n";
		}
	}
	else
	{
        logger("[警告:] 注册表环境变量vc2005 ".$env_2005."已添加，无需重复写\n");
      	print "[警告:] 注册表环境变量vc2005 ".$env_2005."已添加，无需重复写\n"
	}
		
	$hkey->Close();	
}

sub get_evn_2005_path($)
{
	(my $in_env) = @_;
	(my $ret_path);
	while(($path_2005, $env_2005) = each %g_environment_path_2005)#fixme 这里用for不行
	{
		if(! -d $path_2005)
		{
			logger("[错误:] 修改 ".$in_env."错误：".$path_2005."路径不存在\n");
			die("\n修改 ".$in_env."错误：".$path_2005."路径不存在\n");
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
#	logger("\n\n获取vc2005环境变量  ".$in_env." 的值是".$ret_path);
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

