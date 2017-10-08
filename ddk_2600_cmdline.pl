#!/usr/bin/perl
foreach (<DATA>)
{
	print $_;
}
__DATA__
数据通过 shortcut_ddk_parse.pl 执行 获取 再具体的信息可以 参考 develop_perl/shortcut_ddk_parse.pl
########################################################################
Win 2K Checked Build Environment.lnk
C:\WINDOWS\system32\cmd.exe /k E:\WINDDK\2600\bin\w2k\set2k.bat E:\WINDDK\2600 checked 

########################################################################
Win 2K Free Build Environment.lnk
C:\WINDOWS\system32\cmd.exe /k E:\WINDDK\2600\bin\w2k\set2k.bat E:\WINDDK\2600 free 

########################################################################
Win Me Checked Build Environment.lnk
C:\WINDOWS\system32\cmd.exe /k E:\WINDDK\2600\bin\9xbld.bat E:\WINDDK\2600 checked 

########################################################################
Win Me Free Build Environment.lnk
C:\WINDOWS\system32\cmd.exe /k E:\WINDDK\2600\bin\9xbld.bat E:\WINDDK\2600 free 

########################################################################
Win XP Checked 64 Bit Build Environment.lnk
C:\WINDOWS\system32\cmd.exe /k D:\WINDDK\2600\bin\setenv.bat D:\WINDDK\2600 chk 64 

########################################################################
Win XP Checked Build Environment.lnk
C:\WINDOWS\system32\cmd.exe /k D:\WINDDK\2600\bin\setenv.bat D:\WINDDK\2600 chk 

########################################################################
Win XP Free 64 Bit Build Environment.lnk
C:\WINDOWS\system32\cmd.exe /k D:\WINDDK\2600\bin\setenv.bat D:\WINDDK\2600 fre 64 

########################################################################
Win XP Free Build Environment.lnk
C:\WINDOWS\system32\cmd.exe /k D:\WINDDK\2600\bin\setenv.bat D:\WINDDK\2600 fre 

