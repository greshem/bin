#!/usr/bin/perl
use Win32::Registry;
#Description: 	�ýű��޸�ע���ʵ��������Ҽ����г�windbg.exe��ִ�г���.
#Notice: 		SetValueEx ��Ч�� һ����� SetValue. ����ʹ��ǰ��.

my $Register = "*\\shell\\windbg\\command"; #û����key����Ϊ��
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
		logger("����ע���HKEY_CLASSES_ROOT\\*\\shell\\windbg\\commandʧ�� \n");
		die("����ע���HKEY_CLASSES_ROOT\\*\\shell\\windbg\\commandʧ�� \n");
	}

	my $value;
	my $path_windbg = get_windbg_path();
	if($path_windbg eq "")
	{
		print "windbg.exe ���ڰ�װĿ¼�����exe·����װwindbg\n";
		logger("windbg.exe ���ڰ�װĿ¼,���exe·����װwindbg\n");
	}
	else
	{
		my $command = $path_windbg." \"%L\"";
		$hkey->SetValueEx("",undef, REG_SZ,$command);
		logger("ע���HKEY_CLASSES_ROOT\\*\\shell\\windbg\\commandֵ�Ѿ��������\n");
		print "ע���HKEY_CLASSES_ROOT\\*\\shell\\windbg\\commandֵ�Ѿ��������\n";
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
