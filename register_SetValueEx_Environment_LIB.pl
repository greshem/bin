#!/usr/bin/perl
use Win32::Registry;
#Description: 	ϵͳ��װ��֮��, һ�㻷����������� LIB  �� INCLUDE ��û�����ú�. ����ȫ������һ��.
#Notice: 		SetValueEx ��Ч�� һ����� SetValue. ����ʹ��ǰ��.

my $Register = "Environment"; #û����key����Ϊ��
my ($hkey,@key_list,$key);
my %values;

if( ! $HKEY_CURRENT_USER->Open($Register , $hkey) )
{
	die("ע���Ļ������� ������\n");
}

my $value;
if( ! $hkey->QueryValueEx("LIB", undef, $value))
{
	warn("��������LIB ������\n");
	$hkey->SetValueEx("LIB",undef, REG_SZ,"d:\\usr\\lib");
	
}
else
{
	warn("��������LIB ����, ����ȥ����\n");
}
#==========================================================================
if( ! $hkey->QueryValueEx("INCLUDE", undef, $value))
{
	warn("��������INCLUDE ������\n");
	$hkey->SetValueEx("INCLUDE",undef, REG_SZ,"d:\\usr\\include");
}
else
{
	warn("��������INCLUDE ����, ����ȥ����\n");
}

$hkey->Close();



