#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__

#2012_05_24   星期四   add by greshem
 #文档来自于 <<windows_内核驱动服务器启动类型_start_type.txt>> 
start 0  boot	 #boot acpi pci mountmgr ftdisk 等.
start 1	system   #beep fs_rec null
start 2 auto
start 3 manual
start 4 disabled

type  1		#内核级设备驱动程序
type  2		#文件系统驱动o
type  4		#适配器驱动（如鼠标键盘、磁盘驱动器等）
type  8		#文件系统识别驱动（标识计算机上确认使用的文件系统）
type 16		#win32服务，以其自身进程运行，不与其他服务共享可执行文件（即宿主进程
type 32 	#win32服务，作为共享进程运行，与其他服务共享可执行文件（即宿主进程）
type 272	#win32服务，以其自身进程运行，同时服务可与桌面交互，接受用户输入，交互服务必须以localsystem本地系统帐户运行
type 288	#win32服务，以共享进程运行，同时服务可与桌面交互，接受用户输入，交互服务必须以localsystem本地系统帐户运行
########################################################################
richboot type 1  start 0  group "NDIS Wrappter"
richndis type 1  start 0 group "NDIS"
richdisk  type 1 start 0 group "SCSI miniport"
1. 	sc qc disk
2.  E1000 winaoe 的注册表.

