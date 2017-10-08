#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__

#2012_02_29   ������   add by greshem

#��������ϰ�װFC3��Ȼ����պ�������£���ϵͳ���ں�������2.6.15.5������Ϊ��FC3-kgdb-client����Cloneһ����Ԥװ����һ����ϵͳ��ѡ��"Create a full clone"������Ϊ��FC3-kgdb-server����
#�ֱ�Ϊ����ϵͳ����һ�����ڣ���"Output to named pipe"��ʽ,���У�
#client��ѡ��"this end is the client", "the other end is a virtual machine"
#Server��ѡ��"this end is the server", "the other end is a virtual machine"
#�������һ��client��server������
#client��development machine��������������������������������öϵ㣩����target machine�����С�
#server��target machine����Ҳ���Ǳ����ԵĻ����ˣ��������ܵ�development machine����Ŀ��ơ�
########################################################################
#grub ��������
title Fedora Core (2.6.15.5-kgdb)
          root (hd0,0)
          kernel /boot/vmlinuz-2.6.15.5-kgdb ro root=/dev/hda1 kgdbwait kgdb8250=0,115200
########################################################################


#�Ϳ�����clientȥ�����ˣ���client�ϣ�
#cd /usr/src/linux
gdb ./vmlinux
(gdb) set remotebaud 115200
(gdb) target remote /dev/ttyS0
Remote debugging using /dev/ttyS0
breakpoint () at kernel/kgdb.c:1212
1212                   atomic_set(&kgdb_setting_breakpoint, 0);

���桰1212 atomic_set(&kgdb_setting_breakpoint, 0);����һ�б����Ѿ��������ˡ�
########################################################################

