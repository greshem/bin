#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__

#2012_02_29   星期三   add by greshem

#在虚拟机上安装FC3，然后参照后面的文章，将系统的内核升级到2.6.15.5，命名为“FC3-kgdb-client”。Clone一个和预装环境一样的系统，选择"Create a full clone"，命名为“FC3-kgdb-server”。
#分别为两个系统增加一个串口，以"Output to named pipe"方式,其中：
#client端选择"this end is the client", "the other end is a virtual machine"
#Server端选择"this end is the server", "the other end is a virtual machine"
#这里解释一下client和server的区别：
#client（development machine）：即开发机，用于输入命令（例如设置断点）控制target machine的运行。
#server（target machine）：也就是被调试的机器了，其运行受到development machine命令的控制。
########################################################################
#grub 启动设置
title Fedora Core (2.6.15.5-kgdb)
          root (hd0,0)
          kernel /boot/vmlinuz-2.6.15.5-kgdb ro root=/dev/hda1 kgdbwait kgdb8250=0,115200
########################################################################


#就可以用client去连接了，在client上：
#cd /usr/src/linux
gdb ./vmlinux
(gdb) set remotebaud 115200
(gdb) target remote /dev/ttyS0
Remote debugging using /dev/ttyS0
breakpoint () at kernel/kgdb.c:1212
1212                   atomic_set(&kgdb_setting_breakpoint, 0);

上面“1212 atomic_set(&kgdb_setting_breakpoint, 0);”这一行表明已经连接上了。
########################################################################

