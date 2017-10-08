#!/usr/bin/perl
use Win32::Registry;
#Description: 	��ע���������_NT_SYMBOL_PATHһ�����ֵΪ
#symsrv*symsrv.dll*d:\\symbols*http://msdl.microsoft.com/download/symbols.

my $Register = "Environment"; #û����key����Ϊ��
my ($hkey,@key_list,$key);
my %values;
my $key_value = "symsrv*symsrv.dll*d:\\symbols*http:\/\/msdl.microsoft.com\/download\/symbols";
if( ! $HKEY_CURRENT_USER->Open($Register , $hkey) )
{
	logger("ע�����ӽ�Environment������\n");
	die("ע���Ļ������� ������\n");
}

if($hkey->SetValueEx("_NT_SYMBOL_PATH",undef, REG_SZ,$key_value))
{
	print "����_NT_SYMBOL_PATH�ļ�ֵ�ɹ�\n";
	logger("����_NT_SYMBOL_PATH�ļ�ֵ�ɹ�\n");
}
else
{
	print "����_NT_SYMBOL_PATH�ļ�ֵʧ��\n";
	logger("����_NT_SYMBOL_PATH�ļ�ֵʧ��\n");
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

