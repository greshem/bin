#!/usr/bin/perl
#2011_08_10   ������   add by greshem
#����Ҫ�� QueryValueEx �����ǲ���. 
#֮�����еĻ���������ά�������������������������
sub add_path_to_ENV($$)
{
	use Win32::Registry;
	(my $sub_key,my  $in_value)=@_;
	$in_value_pattern=$in_value;
	$in_value_pattern=~s/\\/\\\\/g;

	my $Register = "Environment"; #û����key����Ϊ��
	my $tmp, $tmp2; 
	my $value;
	$HKEY_CURRENT_USER->Open($Register , $hkey) || die $!;
	$hkey->QueryValueEx($sub_key,undef, $value ) or die $!;
	print $value."\n";
	my @array=split(/;/, $value);
	my @tmp = grep{/$in_value_pattern/} @array;
	if(scalar(@tmp) >=1)
	{
		print "$in_value �Ѿ������, ���������\n";
	}
	else
	{
		push (@array, $in_value);
	}
	$last_value=join(";", @array);
	$hkey->SetValueEx($sub_key,undef,REG_SZ, $last_value);
	$hkey->Close();
	print "�����ַ�����: $last_value \n";

}

my $input_dir=shift or warn("usage: $0 input_dir \n");

if( -d $input_dir)
{
	add_path_to_ENV("PATH","$input_dir");
	print (" rundll32.exe shell32.dll,Control_RunDLL sysdm.cpl,,3 \n");
	system (" rundll32.exe shell32.dll,Control_RunDLL sysdm.cpl,,3 \n");
}
else
{
	init_system();
}

#��ӳ��õĵ�ַ. 
sub init_system()
{
	add_path_to_ENV("PATH","c:\\bin");
	add_path_to_ENV("PATH","C:\\Python26");
	add_path_to_ENV("PATH","c:\\cygwin\\bin");
	add_path_to_ENV("PATH","C:\\Ruby192\\bin");
	add_path_to_ENV("PATH","c:\\Perl\\bin");
	add_path_to_ENV("PATH","C:\\Program Files\\Vim\\vim72");
	add_path_to_ENV("PATH","C:\\Program Files\\Bakefile");
	add_path_to_ENV("PATH","C:\\Program Files\\Wireshark");
	add_path_to_ENV("PATH","C:\\Program Files\\Ext2Fsd");
	add_path_to_ENV("PATH","C:\\Program Files\\Subversion\\bin");

	add_path_to_ENV("PATH", "C:\\MPlayer_Windows");
	add_path_to_ENV("PATH", "C:\\Program Files\\HTML Help Workshop");
	add_path_to_ENV("PATH", "C:\\Program Files\\WinCDEmu");
	add_path_to_ENV("PATH", "C:\\Program Files\\WinRAR");
	add_path_to_ENV("PATH", "C:\\Program Files\\Debugging Tools for Windows (x86)\\");
	add_path_to_ENV("PATH", "C:\\Leakdiag\\");

	add_path_to_ENV("PATH", "C:\\Program Files\\Microsoft Visual Studio\\COMMON\\MSDev98\\Bin");
}
