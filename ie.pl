#!/usr/bin/perl
$input=shift or die("Usage: $0 input_thing \n");
#explorer.exe

do("c:\\bin\\iso_get_mobile_disk_label.pl");
our $input;

if($input=~/(^\"|\"$|^\'|\'$_)/  ) 
{
	#warn("#windows ��cmd û�ж� ����������� \" ���д���  ע��,�����ļ������ҵ�, ���ȥ��һ��\n");
	$input=~s/(^\"|\"$|^\'|\'$)//g;
	#print "#Input: ��Ϊ $input\n";
}
if($input=~/\\\\/  ) 
{
	#warn("#windows �µ�·�� ����Ĳ���������\/ \n");
	$input=~s/\\\\/\\/g;
	#print "#Input: ��Ϊ $input\n";
}
if($input=~/\/\//)
{
	$input=~s/\/\//\\/g;
}
if($input=~/\//)
{
	$input=~s/\//\\/g;
}



MAIN:
if(-d $input)
{
	print ("explorer.exe $input\n");
	system("explorer.exe $input\n");
}
elsif( -f $input)
{
	print ("explorer.exe /select,$input\n");
	system("explorer.exe /select,$input \n");
}
elsif ($input=~/^(sdb1|sdb2|sdb3|sdb4).*.iso$/) #����
{
	print ("#���ڹ����е��ļ�, ���ع���Ȼ�󿽱�,��λ\n");
	$input=change_mobile_path_to_win_path($input);
	print "goto MAIN ��ǩ\n";
	goto MAIN;
}
elsif ($input=~/^(sdb1|sdb2|sdb3|sdb4).*\.iso/) #���ݹ����е��ļ�.
{
	print ("#���ڹ����е��ļ�, ���ع���Ȼ�󿽱�,��λ\n");
	print ("c:\\bin\\iso_copy_out_to_desktop.pl  $input \n");
}
elsif ($input=~/^(sdb1|sdb2|sdb3|sdb4)/)
{
	print ("#�ƶ�Ӳ���ϵ��ļ�\n");
	$input=change_mobile_path_to_win_path($input);
	#print ("explorer.exe $path\n");
	#print ("explorer.exe /select,$path \n");
	print "goto MAIN ��ǩ\n";
	goto MAIN;
}
else
{
	print "#�������, ��ӡƥ���ע���·��,\n";
	list_common_path_in_DATA($input);
	if($^O=~/win/i)
	{
		system("c:\\bin\\mobile_harddisk_skeletion.pl $input ");	
	}
	else
	{
		system("/bin/mobile_harddisk_skeletion.pl $input ");	
	}
	print ("explorer.exe .");
	system("explorer.exe .");
}

########################################################################
sub list_common_path_in_DATA($)
{
	(my $pattern)=@_;
	foreach (<DATA>)
	{
			
		if($_=~/$pattern/i)
		{
			print $_ ;
		}
	}
}
__DATA__
regjump.exe HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\.NETFramework 
regjump.exe HKEY_CURRENT_USER\Console
regjump.exe HKEY_CURRENT_USER\Environment
regjump.exe HKEY_CURRENT_USER\Software\Microsoft\Internet Explorer\Main 
regjump.exe HKEY_CURRENT_USER\Software\Microsoft\DevStudio\6.0\Build System\Components\Platforms\Win32 (x86)\Directories
regjump.exe HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters

regjump.exe HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services 
explorer.exe  "C:\Documents and Settings\Administrator\Application Data\AL"

explorer.exe "C:\Program Files\Microsoft Visual Studio"
explorer.exe "C:\Program Files\Richtech"

regjump.exe HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run
regjump.exe HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\KnownDLLs
regjump.exe HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer
regjump.exe HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Active Setup\Installed Components


cd /var/cache/yum/x86_64/13/fedora-debuginfo/packages

cd /var/cache/yum/fedora-debuginfo/packages

cd /var/spool/mqueue && ls -la -h
cd /var/spool/mail/ && ls -la -h
cd /var/spool/clientmqueue/ && ls -la -h


cd /lib/modules/2.6.33.3-85.fc13.x86_64/build
cd /usr/share/doc/systemtap-1.2/examples/
cd /vld/sys/ml45/program/lond

#��ҳ.
http://www.petty-china.com/petty_china/index.php
http://www.petty-china.com/petty_china_new/index.php
http://www.sino-pet.com/sino_pet/index.php

#��̨.
#http://www.petty-china.com/petty_china/inifile_web/  #, ���û��.
http://www.petty-china.com/petty_china_new/inifile_web/
http://www.sino-pet.com/sino_pet/inifile_web/

http://192.168.0.234/
http://192.168.1.73/

ie.pl  "E:\svn_working_path"
ie.pl  "d:\log"
ie.pl  "C:\Documents and Settings\Administrator\����"

ie.pl   "c:\\bin"
ie.pl   "c:\\cygwin\\bin"
ie.pl   "C:\\Ruby192\\bin"
ie.pl   "c:\\Perl\\bin"
ie.pl   "C:\\Program Files\\Vim\\vim72"
ie.pl   "C:\\Program Files\\Bakefile"
ie.pl   "C:\\Program Files\\Wireshark"
ie.pl   "C:\\Program Files\\Ext2Fsd"
ie.pl   "C:\\Program Files\\Subversion\\bin"

ie.pl    "C:\\MPlayer_Windows"
ie.pl    "C:\\Program Files\\HTML Help Workshop"
ie.pl    "C:\\Program Files\\WinCDEmu"
ie.pl    "C:\\Program Files\\WinRAR"
ie.pl    "C:\\Program Files\\Debugging Tools for Windows (x86)\\"
ie.pl    "C:\\Leakdiag\\"

ie.pl    "C:\\Program Files\\Microsoft Visual Studio\\COMMON\\MSDev98\\Bin"

ie.pl  "C:\\Documents and Settings\\Administrator\\Application Data\\AL\\aliases.txt"
