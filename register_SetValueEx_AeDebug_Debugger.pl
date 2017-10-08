#!/usr/bin/perl
use Win32::Registry;
#Description: 	�ýű�ʵ���޸�ע���ϵͳ����ʱ�Զ����û���ҽ��dump���ɹ��ߺ�windbg���Թ���.
#Notice: 		SetValueEx ��Ч�� һ����� SetValue. ����ʹ��ǰ��.

my $Register = "SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\\AeDebug"; #û����key����Ϊ��
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
		logger("ע���Ļ������� ������\n");
		die("ע���Ļ������� ������\n");
	}

	my $value;
	if( $hkey->QueryValueEx("Debugger", undef, $value))
	{
		my $path_windbg = get_windbg_path();
		if($path_windbg eq "")
		{
			print "windbg ����ָ��Ŀ¼,����ʧ��\n";
			logger("windbg ����ָ��Ŀ¼,����ʧ��\n");
		}
		else
		{
			my $command = $path_windbg." -p %ld �Cc \".dump \/ma \/u D:\\crashdump\\CrashDump.dmp\" -e %ld �Cg";
			$hkey->SetValueEx("Debugger",undef, REG_SZ,$command);
			logger("Debuggerֵ�Ѿ����ú�\n");
			print "Debuggerֵ�Ѿ����ú�\n";
		}
	}
	else	
	{
		logger("ע���Debugger�����, ����ȥ����\n");
		warn("ע���Debugger�����, ����ȥ����\n");
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
