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

   	logger("修改注册表".$env_98."\n"); 
	if( ! $HKEY_CURRENT_USER->Open($Register , $hkey) )
	{
		logger("注册表的环境变量 不存在\n");
		die("注册表的环境变量 不存在\n");
	}
	if( $hkey->QueryValueEx($env_98, undef, $path_query))
	{
		my @path_query = splite_path_query($path_query);
		my $path_98 = get_evn_98_path($env_98);
		my $remain_paths = delete_vs98_SignaturePath($path_98,@path_query);	
		$hkey->SetValueEx($env_98,undef, REG_SZ,$remain_paths);
	}
	logger("\n");
	$hkey->Close();	
}

sub get_evn_98_path($)
{
	(my $in_env) = @_;
	(my $ret_path);
	while(($path_98, $env_98) = each %g_environment_path_98)
	{
		if($env_98 =~ /$in_env/)
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

	return $ret_path;
}

sub splite_path_query($)
{
	(my $in_path_query) = @_;
	my @ret_path_query;
	@ret_path_query = split(/;/,$in_path_query);
	return @ret_path_query;
}

sub delete_vs98_SignaturePath($@)
{
	my($in_path_98,@in_path_query) = @_;
	my $remain_paths;
	for(@in_path_query)
	{
		if(-1 != index($in_path_98,$_))
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
	open(FILE, ">> d:\\log\\delete_vc98_dev_env.log");
	print FILE $log_str;
	close(FILE);
}

