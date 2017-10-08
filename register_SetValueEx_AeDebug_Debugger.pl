#!/usr/bin/perl
use Win32::Registry;
#Description: 	该脚本实现修改注册表系统崩溃时自动调用华生医生dump生成工具和windbg调试工具.
#Notice: 		SetValueEx 的效果 一般好于 SetValue. 这里使用前者.

my $Register = "SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\\AeDebug"; #没有子key所以为空
my ($hkey,@key_list,$key);
my %values;

sub get_windbg_path()
{
	my $path_windbg;
	if(-f "C:\\Program Files\\Debugging Tools for Windows (x86)\\WinDbg.exe")
	{
		$path_windbg = "\"C:\\Program Files\\Debugging Tools for Windows (x86)\\WinDbg.exe\"";
	}
	elsif(-f "C:\\Program Files\\Debugging Tools for Windows\\WinDbg.exe")
	{
		$path_windbg = "\"C:\\Program Files\\Debugging Tools for Windows\\WinDbg.exe\"";
	}
	else
	{
		$path_windbg = "";
	}
	return $path_windbg;
}

sub modify_register()
{
	if( ! $HKEY_LOCAL_MACHINE->Open($Register , $hkey) )
	{
		logger("注册表的环境变量 不存在\n");
		die("注册表的环境变量 不存在\n");
	}

	my $value;
	if( $hkey->QueryValueEx("Debugger", undef, $value))
	{
		my $path_windbg = get_windbg_path();
		if($path_windbg eq "")
		{
			print "windbg 不在指定目录,操作失败\n";
			logger("windbg 不在指定目录,操作失败\n");
		}
		else
		{
			my $command = $path_windbg." -p %ld –c \".dump \/ma \/u D:\\crashdump\\CrashDump.dmp\" -e %ld –g";
			$hkey->SetValueEx("Debugger",undef, REG_SZ,$command);
			logger("Debugger值已经设置好\n");
			print "Debugger值已经设置好\n";
		}
	}
	else	
	{
		logger("注册表Debugger项不存在, 不用去设置\n");
		warn("注册表Debugger项不存在, 不用去设置\n");
	}

	$hkey->Close();
}

sub logger($)
{
	if( ! -d "d:\\log")
	{
		mkdir("d:\\log");
	}

	(my $log_str)=@_;
		
	open(FILE, "> d:\\log\\SetValueEx_AeDebug_Debugger.log");
	print FILE $log_str;
	
	close(FILE);
}

########################################################################
modify_register();
