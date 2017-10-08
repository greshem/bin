#!/usr/bin/perl
use Win32::Registry;
#Description: 	该脚本修改注册表，实现在鼠标右键中列出windbg.exe可执行程序.
#Notice: 		SetValueEx 的效果 一般好于 SetValue. 这里使用前者.

my $Register = "*\\shell\\windbg\\command"; #没有子key所以为空
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
	if( ! $HKEY_CLASSES_ROOT->Create($Register , $hkey) )
	{
		logger("创建注册表HKEY_CLASSES_ROOT\\*\\shell\\windbg\\command失败 \n");
		die("创建注册表HKEY_CLASSES_ROOT\\*\\shell\\windbg\\command失败 \n");
	}

	my $value;
	my $path_windbg = get_windbg_path();
	if($path_windbg eq "")
	{
		print "windbg.exe 不在安装目录，检查exe路径或安装windbg\n";
		logger("windbg.exe 不在安装目录,检查exe路径或安装windbg\n");
	}
	else
	{
		my $command = $path_windbg." \"%L\"";
		$hkey->SetValueEx("",undef, REG_SZ,$command);
		logger("注册表HKEY_CLASSES_ROOT\\*\\shell\\windbg\\command值已经设置完成\n");
		print "注册表HKEY_CLASSES_ROOT\\*\\shell\\windbg\\command值已经设置完成\n";
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
		
	open(FILE, "> d:\\log\\set_register_openWith_windbg.log");
	print FILE $log_str;
	
	close(FILE);
}

########################################################################
modify_register();
