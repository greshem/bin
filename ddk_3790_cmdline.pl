#!/usr/bin/perl
foreach (<DATA>)
{
	print $_;
}
__DATA__
########################################################################
Windows 2000 Checked Build Environment.lnk
C:\WINDOWS\system32\cmd.exe /k d:\WINDDK\3790.1830\bin\setenv.bat d:\WINDDK\3790.1830 w2k c 
########################################################################
Windows 2000 Free Build Environment.lnk
C:\WINDOWS\system32\cmd.exe /k d:\WINDDK\3790.1830\bin\setenv.bat d:\WINDDK\3790.1830 w2k f 


########################################################################
Windows Server 2003 Checked IA-64 Bit Build Environment.lnk
C:\WINDOWS\system32\cmd.exe /k d:\WINDDK\3790.1830\bin\setenv.bat d:\WINDDK\3790.1830 chk 64 WNET 
########################################################################
Windows Server 2003 Checked x64 Build Environment.lnk
C:\WINDOWS\system32\cmd.exe /k d:\WINDDK\3790.1830\bin\setenv.bat d:\WINDDK\3790.1830 chk AMD64 WNET 
########################################################################
Windows Server 2003 Checked x86 Build Environment.lnk
C:\WINDOWS\system32\cmd.exe /k d:\WINDDK\3790.1830\bin\setenv.bat d:\WINDDK\3790.1830 chk WNET 
########################################################################
Windows Server 2003 Free IA-64 Bit Build Environment.lnk
C:\WINDOWS\system32\cmd.exe /k d:\WINDDK\3790.1830\bin\setenv.bat d:\WINDDK\3790.1830 fre 64 WNET 
########################################################################
Windows Server 2003 Free x64 Build Environment.lnk
C:\WINDOWS\system32\cmd.exe /k d:\WINDDK\3790.1830\bin\setenv.bat d:\WINDDK\3790.1830 fre AMD64 WNET 
########################################################################
Windows Server 2003 Free x86 Build Environment.lnk
C:\WINDOWS\system32\cmd.exe /k d:\WINDDK\3790.1830\bin\setenv.bat d:\WINDDK\3790.1830 fre WNET 

########################################################################
Windows XP Checked Build Environment.lnk
C:\WINDOWS\system32\cmd.exe /k d:\WINDDK\3790.1830\bin\setenv.bat d:\WINDDK\3790.1830 chk WXP 
########################################################################
Windows XP Free Build Environment.lnk
C:\WINDOWS\system32\cmd.exe /k d:\WINDDK\3790.1830\bin\setenv.bat d:\WINDDK\3790.1830 fre WXP 

