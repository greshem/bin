#!/usr/bin/perl
foreach (<DATA>)
{
	print $_;
}
__DATA__
#.net 的一些参数.
regjump.exe HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\.NETFramework 

#控制台的一些
regjump.exe HKEY_CURRENT_USER\Console

当前用户环境变量.
regjump.exe HKEY_CURRENT_USER\Environment
#IE注册表.
regjump.exe HKEY_CURRENT_USER\Software\Microsoft\Internet Explorer\Main 
#vc6.0 注册地址.
regjump.exe HKEY_CURRENT_USER\Software\Microsoft\DevStudio\6.0\Build System\Components\Platforms\Win32 (x86)\Directories

#ip地址配置.
regjump.exe HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters

#系统注册服务.
regjump.exe HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services 

explorer.exe  "C:\Documents and Settings\Administrator\Application Data\AL"
explorer.exe "C:\Program Files\Microsoft Visual Studio"
explorer.exe "C:\Program Files\Richtech"


regjump.exe HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\KnownDLLs
regjump.exe HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer
regjump.exe HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Active Setup\Installed Components

#调试器.
regjump.exe HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AeDebug

#开机autorun
regjump.exe HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run
regjump.exe HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run

#winlogon 附带启动项.
regjump.exe HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\Notify

#系统全局环境变量.
regjump.exe HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Control\Session Manager\Environment
regjump.exe HKEY_LOCAL_MACHINE\SYSTEM\ControlSet003\Control\Session Manager\Environment
regjump.exe HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Environment

#com 的一些路径
regjump.exe HKEY_CLASSES_ROOT\AppID
regjump.exe HKEY_CLASSES_ROOT\CLSID
regjump.exe HKEY_LOCAL_MACHINE\SOFTWARE\Classes\AppID
regjump.exe HKEY_LOCAL_MACHINE\SOFTWARE\Classes\CLSID

