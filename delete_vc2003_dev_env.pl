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
    
	if( ! $HKEY_CURRENT_USER->Open($Register , $hkey) )
	{
		logger("注册表的环境变量 不存在\n");
		die("注册表的环境变量 不存在\n");
	}
	if( $hkey->QueryValueEx($env_2003, undef, $path_query))
	{
		my @path_query = splite_path_query($path_query);
		my $path_2003 = get_evn_2003_path($env_2003);
		my $remain_paths = delete_vs2003_SignaturePath($path_2003,@path_query);	
		$hkey->SetValueEx($env_2003,undef, REG_SZ,$remain_paths);
	}
	$hkey->Close();	
}

sub get_evn_2003_path($)
{
	(my $in_env) = @_;
	(my $ret_path);
	while(($path_2003, $env_2003) = each %g_environment_path_2003)
	{
		if($env_2003 =~ /$in_env/)
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

	return $ret_path;
}

sub splite_path_query($)
{
	(my $in_path_query) = @_;
	my @ret_path_query;
	@ret_path_query = split(/;/,$in_path_query);
	return @ret_path_query;
}

sub delete_vs2003_SignaturePath($@)
{
	my($in_path_2003,@in_path_query) = @_;
	my $remain_paths;
	for(@in_path_query)
	{
		if(-1 != index($in_path_2003,$_))
		{
			logger($_."删除掉\n");
		}
		else
		{
			if(!$remain_paths)
			{
				$remain_paths = $_;
			}
			else
			{
				$remain_paths .= ";";
				$remain_paths .= $_;
			}
#			logger($_."保留\n");
		}
	}
	return $remain_paths;
}

sub logger($)
{
	if( ! -d "d:\\log")
	{
		mkdir("d:\\log");
	}

	(my $log_str)=@_;
	open(FILE, ">> d:\\log\\delete_vc2003_dev_env.log");
	print FILE $log_str;
	close(FILE);
}

