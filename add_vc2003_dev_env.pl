#!/usr/bin/perl
use Win32::Registry;
#Description: 	修改注册表Environment为编译器指定的环境变量
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
		logger("[错误:] vc2003注册表的环境变量".$env_2003."不存在\n");
		die("vc2003注册表的环境变量".$env_2003."不存在\n");
	}

	$hkey->QueryValueEx($env_2003, undef, $path_query);
	if(-1 == index($path_query,$path_2003))
	{
		#$path_query是其他应用程序保留的环境变量，不能覆盖
		if(!$path_query)
		{
			$hkey->SetValueEx($env_2003,undef, REG_SZ,$path_2003);
			logger("注册表环境变量vc2003 ".$env_2003."设置完成\n");
			print "注册表环境变量vc2003 ".$env_2003."设置完成\n";
		}
		else
		{
			$hkey->SetValueEx($env_2003,undef, REG_SZ,$path_query.";".$path_2003);
			logger("注册表环境变量vc2003 ".$env_2003."已追加\n");
			print "注册表环境变量vc2003 ".$env_2003."已追加\n";
		}
	}
	else
	{
   	    logger("[警告:]注册表环境变量vc2003 ".$env_2003."已添加，无需重复写\n");
        print "[警告:] 注册表环境变量vc2003 ".$env_2003."已添加，无需重复写\n"
	}
		
	$hkey->Close();	
}

sub get_evn_2003_path($)
{
	(my $in_env) = @_;
	(my $ret_path);
	while(($path_2003, $env_2003) = each %g_environment_path_2003)#fixme 这里用for不行
	{
		if(! -d $path_2003)
		{
			logger("[错误:] 修改 ".$in_env."错误：".$path_2003."路径不存在\n");
			die("修改 ".$in_env."错误：".$path_2003."路径不存在\n");
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
#	logger("\n\n获取vc2003环境变量  ".$in_env." 的值是".$ret_path);
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

