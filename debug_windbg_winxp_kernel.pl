#!/usr/bin/perl
foreach (<DATA>)
{
    print $_; 
}
__DATA__
(1).在虚拟机中安装好系统后，关闭虚拟机系统，打开虚拟机系统的设置框，选择Edit virtual machine settings，打开设置对话框.

(2)首先选择Add...按钮添加Serial 设备，然后设置Serial 属性, 命名管道名称为WinDbg 连接时需要用到的 
管道名，\\.\pipe\vndbg, 可以自己命名, 
也可以使用默认的名字 \\.\pipe\com_1

(3)设置好硬件连接方式后，启动虚拟机中的系统，添加调试启动项,Vista 之前的系统通过修改boot.ini 文件实现，
/debug 表示打开内核调试引擎，/debugport=com1 表示采用串口1 通信，/baudrate=115200 设置串口1 的波特率为115200。
设置好启动项后，重启虚拟机中的系统，在选择启动菜单项时停下来，返回主机，通过命令行启动WinDbg, 
boot.ini 文件内容设置如下：(boot.ini为C盘根目录下一个隐藏文件)
[boot loader]
timeout=30
default=multi(0)disk(0)rdisk(0)partition(1)\WINDOWS
[operating systems]
multi(0)disk(0)rdisk(0)partition(1)\WINDOWS="Microsoft Windows XP Professional" /noexecute=optin /fastdetect
multi(0)disk(0)rdisk(0)partition(1)\WINDOWS="Microsoft Windows XP Professional" /noexecute=optin 			/debug /debugport=com1 /baudrate=115200

(4).设置好启动项后，重启虚拟机中的系统，在选择启动菜单项时停下来，返回主机，启动WinDbg, 
通过菜单打开内核调试连接对话框来操作。在菜单中选择symbol file path，在弹出的对话框中写入
"srv*D:/Symbols*http://msdl.microsoft.com/download/symbols;d:\\symbols2" ,再在菜单中选择
#对应 _NT_SYMBOL_PATH 环境变量, 
kernel debugging，在弹出的对话框中设置波特率为115200，port为\\.\pipe\vndgb, 
kernel debugging，在弹出的对话框中设置波特率为115200，port为\\.\pipe\com_1, 
同时勾选reconnect和pipe，然后确定，WinDbg 则会开始等待连接,

此时返回虚拟机中选择调试启动项，一会就能看到WinDbg 中显示连接上虚拟机的信息, 
#==========================================================================
#vmx 可以参看, 
root\develop_network\app_img\app_rtiosrv\*.vmx
