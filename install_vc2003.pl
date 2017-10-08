#!/usr/bin/perl
if ( -d "C:\\Program Files\\Microsoft Visual Studio .NET 2003")
{
	#die("vc2003 已经安装不用再安装了\n");
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

#iso_copy_out_to_desktop.pl 会把后面传入的 文件拷贝到桌面的.
$desktop_vc2003= "C:\\Documents and Settings\\Administrator\\桌面\\Microsoft Visual Studio .NET 2003.zip";
if ( ! -f $desktop_vc2003 )
{
	print "桌面vc2003不存在, 需要拷贝\n";
	#system ('iso_copy_out_to_desktop.pl "sdb3:\develop_IDE_ISO\develop_IDE2.iso\\vc_all_install\\vc_2003_install\\Microsoft Visual Studio .NET 2003.zip"');
}
else
{
	print "vc2003 桌面存在 不用拷贝\n";
}

if( ! -f  $desktop_vc2003 )
{
	print "出现意外, 需要自己 手动安装 vc2003 \n";
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
