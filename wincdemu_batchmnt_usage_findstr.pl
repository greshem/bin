#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__
#==========================================================================
#������������ο�
c:\\bin\\program_files_get_all_exe.pl wincdemu

"c:\\Program Files (x86)\\WinCDEmu\\batchmnt.exe"
"c:\\Program Files (x86)\\WinCDEmu\\batchmnt64.exe"
"c:\\Program Files (x86)\\WinCDEmu\\uninstall.exe"
"c:\\Program Files (x86)\\WinCDEmu\\uninstall64.exe"
"c:\\Program Files (x86)\\WinCDEmu\\vmnt.exe"
"c:\\Program Files (x86)\\WinCDEmu\\vmnt64.exe"

#ie.pl  "c:\Program Files (x86)\WinCDEmu"

#==========================================================================
#mount  exploit-db.iso
batchmnt64.exe j:\\sdb1\\_xfile\\2013_all_iso\\_xfile_2013_03_04.iso   p
batchmnt64.exe P:\\_xfile_2013_04\\exploit-db\\2013_04_10_archive.iso       q
findstr /I ms q:\\files.csv |grep MS05


#==========================================================================
#����:
batchmnt64.exe input.iso    p /wait #������ʽ  mount ���ع��� 
batchmnt64.exe input.iso   p		#�첽��ʽ  mount iso
batchmnt64.exe /unmount p:   		#ע��ð��  ж�� P: 
batchmnt64.exe /unmountall  		# ж�����еĹ���

#�г�����
"c:\Program Files (x86)\WinCDEmu\batchmnt.exe" /list
batchmnt64.exe /list
batchmnt.exe  /list