#!/usr/bin/perl
if ( -d "C:\\Program Files\\Microsoft Visual Studio .NET 2003")
{
	#die("vc2003 �Ѿ���װ�����ٰ�װ��\n");
}

if($^O=~/win32/i)
{
    do("c:\\bin\\iso_get_mobile_disk_label.pl");
}
else
{
    do("/bin/iso_get_mobile_disk_label.pl");
}

#$dev_iso=

#iso_copy_out_to_desktop.pl ��Ѻ��洫��� �ļ������������.
$desktop_vc2003= "C:\\Documents and Settings\\Administrator\\����\\Microsoft Visual Studio .NET 2003.zip";
if ( ! -f $desktop_vc2003 )
{
	print "����vc2003������, ��Ҫ����\n";
	#system ('iso_copy_out_to_desktop.pl "sdb3:\develop_IDE_ISO\develop_IDE2.iso\\vc_all_install\\vc_2003_install\\Microsoft Visual Studio .NET 2003.zip"');
}
else
{
	print "vc2003 ������� ���ÿ���\n";
}

if( ! -f  $desktop_vc2003 )
{
	print "��������, ��Ҫ�Լ� �ֶ���װ vc2003 \n";
}
print ("move  \"$desktop_vc2003\"  \"c:\\Program\ Files\\\" ");
system("move  \"$desktop_vc2003\"  \"c:\\Program\ Files\\\" ");

$vc2003_in_programs= "C:\\Program Files\\Microsoft Visual Studio .NET 2003.zip";
if( -f  $vc2003_in_programs)
{
	print  ("\"C:\\Program Files\\WinRAR\\WinRar.exe\"  x \"$vc2003_in_programs\"");
	#winrar x  input.rar  dest_path
	system ("\"C:\\Program Files\\WinRAR\\WinRar.exe\"  x \"$vc2003_in_programs\"   \"C:\\Program Files\\\" ");
}
