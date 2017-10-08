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
    
	if( ! $HKEY_CURRENT_USER->Open($Register , $hkey) )
	{
		logger("注册表的环境变量 不存在\n");
		die("注册表的环境变量 不存在\n");
	}
	if( $hkey->QueryValueEx($env_2010, undef, $path_query))
	{
		my @path_query = splite_path_query($path_query);
		my $path_2010 = get_evn_2010_path($env_2010);
		my $remain_paths = delete_vs2010_SignaturePath($path_2010,@path_query);	
		$hkey->SetValueEx($env_2010,undef, REG_SZ,$remain_paths);
	}
	$hkey->Close();	
}

sub get_evn_2010_path($)
{
	(my $in_env) = @_;
	(my $ret_path);
	while(($path_2010, $env_2010) = each %g_environment_path_2010)
	{
		if($env_2010 =~ /$in_env/)
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

	return $ret_path;
}

sub splite_path_query($)
{
	(my $in_path_query) = @_;
	my @ret_path_query;
	@ret_path_query = split(/;/,$in_path_query);
	return @ret_path_query;
}

sub delete_vs2010_SignaturePath($@)
{
	my($in_path_2010,@in_path_query) = @_;
	my $remain_paths;
	for(@in_path_query)
	{
		if(-1 != index($in_path_2010,$_))
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
	open(FILE, ">> d:\\log\\delete_vc2010_dev_env.log");
	print FILE $log_str;
	close(FILE);
}

