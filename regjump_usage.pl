#!/usr/bin/perl
foreach (<DATA>)
{
	print $_;
}
__DATA__
#.net ��һЩ����.
regjump.exe HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\.NETFramework 

#����̨��һЩ
regjump.exe HKEY_CURRENT_USER\Console

��ǰ�û���������.
regjump.exe HKEY_CURRENT_USER\Environment
#IEע���.
regjump.exe HKEY_CURRENT_USER\Software\Microsoft\Internet Explorer\Main 
#vc6.0 ע���ַ.
regjump.exe HKEY_CURRENT_USER\Software\Microsoft\DevStudio\6.0\Build System\Components\Platforms\Win32 (x86)\Directories

#ip��ַ����.
regjump.exe HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters

#ϵͳע�����.
regjump.exe HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services 

explorer.exe  "C:\Documents and Settings\Administrator\Application Data\AL"
explorer.exe "C:\Program Files\Microsoft Visual Studio"
explorer.exe "C:\Program Files\Richtech"


regjump.exe HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\KnownDLLs
regjump.exe HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer
regjump.exe HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Active Setup\Installed Components

#������.
regjump.exe HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AeDebug

#����autorun
regjump.exe HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run
regjump.exe HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run

#winlogon ����������.
regjump.exe HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\Notify

#ϵͳȫ�ֻ�������.
regjump.exe HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Control\Session Manager\Environment
regjump.exe HKEY_LOCAL_MACHINE\SYSTEM\ControlSet003\Control\Session Manager\Environment
regjump.exe HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Environment

#com ��һЩ·��
regjump.exe HKEY_CLASSES_ROOT\AppID
regjump.exe HKEY_CLASSES_ROOT\CLSID
regjump.exe HKEY_LOCAL_MACHINE\SOFTWARE\Classes\AppID
regjump.exe HKEY_LOCAL_MACHINE\SOFTWARE\Classes\CLSID

