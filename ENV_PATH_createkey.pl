#!/usr/bin/perl
use Win32::Registry;
#SetValueEx ��Ч�� һ����� SetValue

my $Register = "Environment"; #û����key����Ϊ��
#my $Register = "AppEvents";
my ($hkey,@key_list,$key);
my %values;

#$HKEY_LOCAL_MACHINE->Open($Register,$hkey)|| die $!;
$HKEY_CURRENT_USER->Open($Register , $hkey) || die $!;
#$hkey->Create("LIBPATH_LMYUNIT",$SubKey);
#$hkey->Create("LIBPATH_LMYUNIT",$SubKey);
#$hkey->SetValue("TheName",REG_SZ,"successful33333"); #û�еĻ���ʧ��
$str="c:\\lib";
$hkey->SetValueEx("LIB",undef,REG_SZ, $str);
$hkey->SetValueEx("INCLUDE",undef,REG_SZ, $str);


$hkey->Close();


