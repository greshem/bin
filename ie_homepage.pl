#!/usr/bin/perl
use Win32::Registry;
#Description: 	ϵͳ��װ��֮��, һ�㻷����������� LIB  �� INCLUDE ��û�����ú�. ����ȫ������һ��.
#Notice: 		SetValueEx ��Ч�� һ����� SetValue. ����ʹ��ǰ��.

sub change_ie_start_page($)
{
	#my $Register = "SOFTWARE\\Microsoft\\Internet Explorer\\Main"; #û����key����Ϊ��

	my ($Register)=@_;
	my ($hkey,@key_list,$key);
	my %values;

	#if( ! $HKEY_LOCAL_MACHINE->Open($Register , $hkey) )
	if( ! $HKEY_CURRENT_USER->Open($Register , $hkey) )
	{
		die("ע����IE ������\n");
	}

	my $value;
	if( ! $hkey->QueryValueEx("Start Page", undef, $value))
	{
		$hkey->SetValueEx("Start Page",undef, REG_SZ,"http://www.sohu.com/");
		warn("IE  Start Page ������, ���ó�sohu.com \n");
	}
	else
	{
		$hkey->SetValueEx("Start Page",undef, REG_SZ,"http://www.soso.com/");
		warn("IE Start Page ����, �޸����ò� soso.com \n");
	}
	$hkey->Close();
}


change_ie_start_page("SOFTWARE\\Microsoft\\Internet Explorer\\Main");
