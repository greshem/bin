#!/usr/bin/perl
use Win32::Registry;
#Description: 	系统安装好之后, 一般环境变量里面的 LIB  和 INCLUDE 都没有设置好. 这里全局设置一下.
#Notice: 		SetValueEx 的效果 一般好于 SetValue. 这里使用前者.

sub change_ie_start_page($)
{
	#my $Register = "SOFTWARE\\Microsoft\\Internet Explorer\\Main"; #没有子key所以为空

	my ($Register)=@_;
	my ($hkey,@key_list,$key);
	my %values;

	#if( ! $HKEY_LOCAL_MACHINE->Open($Register , $hkey) )
	if( ! $HKEY_CURRENT_USER->Open($Register , $hkey) )
	{
		die("注册表的IE 不存在\n");
	}

	my $value;
	if( ! $hkey->QueryValueEx("Start Page", undef, $value))
	{
		$hkey->SetValueEx("Start Page",undef, REG_SZ,"http://www.sohu.com/");
		warn("IE  Start Page 不存在, 设置成sohu.com \n");
	}
	else
	{
		$hkey->SetValueEx("Start Page",undef, REG_SZ,"http://www.soso.com/");
		warn("IE Start Page 存在, 修改设置层 soso.com \n");
	}
	$hkey->Close();
}


change_ie_start_page("SOFTWARE\\Microsoft\\Internet Explorer\\Main");
