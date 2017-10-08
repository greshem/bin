#!/usr/bin/perl
use Win32::Registry;
#Description: 	在注册表中增添_NT_SYMBOL_PATH一项并设置值为
#symsrv*symsrv.dll*d:\\symbols*http://msdl.microsoft.com/download/symbols.

my $Register = "Environment"; #没有子key所以为空
my ($hkey,@key_list,$key);
my %values;
my $key_value = "symsrv*symsrv.dll*d:\\symbols*http:\/\/msdl.microsoft.com\/download\/symbols";
if( ! $HKEY_CURRENT_USER->Open($Register , $hkey) )
{
	logger("注册表的子健Environment不存在\n");
	die("注册表的环境变量 不存在\n");
}

if($hkey->SetValueEx("_NT_SYMBOL_PATH",undef, REG_SZ,$key_value))
{
	print "设置_NT_SYMBOL_PATH的键值成功\n";
	logger("设置_NT_SYMBOL_PATH的键值成功\n");
}
else
{
	print "设置_NT_SYMBOL_PATH的键值失败\n";
	logger("设置_NT_SYMBOL_PATH的键值失败\n");
}
$hkey->Close();

########################################################################
sub logger($)
{
	if( ! -d "d:\\log")
	{
		mkdir("d:\\log");
	}

	(my $log_str)=@_;
	if($^O=~/win32/i)
	{
		open(FILE, "> d:\\log\\Add_registry_NT_SYMBOL.log");
	}
	else
	{
		open(FILE, "> /var/log/Add_registry_NT_SYMBOL.log");
	}

		print FILE $log_str;
		close(FILE);
}

