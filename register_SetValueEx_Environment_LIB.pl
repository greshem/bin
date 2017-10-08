#!/usr/bin/perl
use Win32::Registry;
#Description: 	系统安装好之后, 一般环境变量里面的 LIB  和 INCLUDE 都没有设置好. 这里全局设置一下.
#Notice: 		SetValueEx 的效果 一般好于 SetValue. 这里使用前者.

my $Register = "Environment"; #没有子key所以为空
my ($hkey,@key_list,$key);
my %values;

if( ! $HKEY_CURRENT_USER->Open($Register , $hkey) )
{
	die("注册表的环境变量 不存在\n");
}

my $value;
if( ! $hkey->QueryValueEx("LIB", undef, $value))
{
	warn("环境变量LIB 不存在\n");
	$hkey->SetValueEx("LIB",undef, REG_SZ,"d:\\usr\\lib");
	
}
else
{
	warn("环境变量LIB 存在, 不用去设置\n");
}
#==========================================================================
if( ! $hkey->QueryValueEx("INCLUDE", undef, $value))
{
	warn("环境变量INCLUDE 不存在\n");
	$hkey->SetValueEx("INCLUDE",undef, REG_SZ,"d:\\usr\\include");
}
else
{
	warn("环境变量INCLUDE 存在, 不用去设置\n");
}

$hkey->Close();



