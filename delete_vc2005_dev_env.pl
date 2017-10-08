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
    
	if( ! $HKEY_CURRENT_USER->Open($Register , $hkey) )
	{
		logger("注册表的环境变量 不存在\n");
		die("注册表的环境变量 不存在\n");
	}
	if( $hkey->QueryValueEx($env_2005, undef, $path_query))
	{
		my @path_query = splite_path_query($path_query);
		my $path_2005 = get_evn_2005_path($env_2005);
		my $remain_paths = delete_vs2005_SignaturePath($path_2005,@path_query);	
		$hkey->SetValueEx($env_2005,undef, REG_SZ,$remain_paths);
	}
	$hkey->Close();	
}

sub get_evn_2005_path($)
{
	(my $in_env) = @_;
	(my $ret_path);
	while(($path_2005, $env_2005) = each %g_environment_path_2005)
	{
		if($env_2005 =~ /$in_env/)
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

	return $ret_path;
}

sub splite_path_query($)
{
	(my $in_path_query) = @_;
	my @ret_path_query;
	@ret_path_query = split(/;/,$in_path_query);
	return @ret_path_query;
}

sub delete_vs2005_SignaturePath($@)
{
	my($in_path_2005,@in_path_query) = @_;
	my $remain_paths;
	for(@in_path_query)
	{
		if(-1 != index($in_path_2005,$_))
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
	open(FILE, ">> d:\\log\\delete_vc2005_dev_env.log");
	print FILE $log_str;
	close(FILE);
}

