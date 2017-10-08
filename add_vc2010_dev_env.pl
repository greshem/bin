#!/usr/bin/perl
use Win32::Registry;
#Description: 	修改注册表Environment为编译器指定的环境变量
%g_environment_path_2010 = 
(
	"C:\\Program Files\\Microsoft Visual Studio 10.0\\Team Tools\\Performance Tools"	=>"PATH",
	"C:\\Program Files\\Microsoft Visual Studio 10.0\\VC\\vcpackages"					=>"PATH",
	"C:\\Program Files\\Microsoft Visual Studio 10.0\\Common7\\Tools"					=>"PATH",
	"C:\\Program Files\\Microsoft Visual Studio 10.0\\VC\\bin"							=>"PATH",
	"C:\\Program Files\\Microsoft SDKs\\Windows\\v7.0A\\bin\\NETFX 4.0 Tools"			=>"PATH",
	"C:\\Program Files\\Microsoft SDKs\\Windows\\v7.0A\\bin"							=>"PATH",
	"C:\\Program Files\\Microsoft F#\\v4.0\\"											=>"PATH",
	"C:\\Program Files\\Microsoft Visual Studio 10.0\\VSTSDB\\Deploy"					=>"PATH",
	"C:\\Program Files\\Microsoft Visual Studio 10.0\\Common7\\IDE\\"					=>"PATH",
	"C:\\WINDOWS\\Microsoft.NET\\Framework\\v4.0.30319"									=>"PATH",
	"C:\\WINDOWS\\Microsoft.NET\\Framework\\v3.5"										=>"PATH",
#	"C:\\Program Files\\HTML Help Workshop"												=>"PATH",
	
	"C:\\Program Files\\Microsoft Visual Studio 10.0\\VC\\atlmfc\\include"				=>"INCLUDE",
	"C:\\Program Files\\Microsoft SDKs\\Windows\\v7.0A\\Include"						=>"INCLUDE",
	"C:\\Program Files\\Microsoft Visual Studio 10.0\\VC\\include"						=>"INCLUDE",
	
	"C:\\Program Files\\Microsoft Visual Studio 10.0\\VC\\atlmfc\\lib"					=>"LIB",
	"C:\\Program Files\\Microsoft Visual Studio 10.0\\VC\\lib"							=>"LIB",
	"C:\\Program Files\\Microsoft SDKs\\Windows\\v7.0A\\Lib"							=>"LIB"
					
);

modify_evn(PATH);
modify_evn(LIB);
modify_evn(INCLUDE);
########################################################################
sub modify_evn($)
{

	(my $env_2010) = @_;
	my $path_query;
	my $Register = "Environment";
	my $hkey;

	(my $path_2010) = get_evn_2010_path($env_2010);
	if( ! $HKEY_CURRENT_USER->Open($Register , $hkey) )
	{
		logger("[错误:]vc2010注册表的环境变量".$env_2010."不存在\n");
		die("vc2010注册表的环境变量".$env_2010."不存在\n");
	}

	$hkey->QueryValueEx($env_2010, undef, $path_query);
	if(-1 == index($path_query,$path_2010))
	{
		#$path_query是其他应用程序保留的环境变量，不能覆盖
		if(!$path_query)
		{
			$hkey->SetValueEx($env_2010,undef, REG_SZ,$path_2010);
			logger("注册表环境变量vc2010 ".$env_2010."设置完成\n");
			print "注册表环境变量vc2010 ".$env_2010."设置完成\n";
		}
		else
		{
			$hkey->SetValueEx($env_2010,undef, REG_SZ,$path_query.";".$path_2010);
			logger("注册表环境变量vc2010 ".$env_2010."已追加\n");
			print "注册表环境变量vc2010 ".$env_2010."已追加\n";
		}
	}
	else
	{
        logger("[警告:]注册表环境变量vc2010 ".$env_2010."已添加，无需重复写\n");
      	print "[警告:]注册表环境变量vc2010 ".$env_2010."已添加，无需重复写\n"
	}
	
	$hkey->Close();	
}

sub get_evn_2010_path($)
{
	(my $in_env) = @_;
	(my $ret_path);
	while(($path_2010, $env_2010) = each %g_environment_path_2010)#fixme 这里用for不行
	{
		if(! -d $path_2010)
		{
			logger("[错误:] 修改 ".$in_env."错误：".$path_2010."路径不存在\n");
			die("修改 ".$in_env."错误：".$path_2010."路径不存在\n");
		}
		elsif($env_2010 =~ /$in_env/)
		{
			if(!$ret_path)
			{
				$ret_path .= $path_2010;
			}
			else
			{
				$ret_path .=";";
				$ret_path .= $path_2010;
			}
		}
	}
#	logger("\n\n获取vc2010环境变量  ".$in_env." 的值是".$ret_path);
	return $ret_path;
}

sub logger($)
{
	if( ! -d "d:\\log")
	{
		mkdir("d:\\log");
	}

	(my $log_str)=@_;
	open(FILE, ">> d:\\log\\add_vc2010_dev_env.log");
	print FILE $log_str;
	close(FILE);
}

