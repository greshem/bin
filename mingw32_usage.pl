#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__
#==========================================================================
#������f16 x64��ƽ̨������Ե�.
#w32api ��.
rpm -ql mingw32-w32api-3.17-1.fc16.noarch
rpm -ql mingw32-w32api-3.17-1.fc16.noarch |grep "\.h"
rpm -ql mingw32-w32api-3.17-1.fc16.noarch |grep "\.a"

#==========================================================================
#��ȡ֧�ֵ����е� ԭ���ĺ���, ͷ�ļ�.
cd /usr/i686-pc-mingw32/sys-root/mingw/include
grep  -H  WINAPI *  

#==========================================================================
#��ȡ���� ͨ�� ��̬��ķ�ʽ.
cd /usr/i686-pc-mingw32/sys-root/mingw/lib
i686-pc-mingw32-nm   libuser32.a  |grep T 

#==========================================================================
#DDK����.
i686-pc-mingw32-gcc -o HelloDrv.obj -O3 -c HelloDrv.c
i686-pc-mingw32-ld HelloDrv.obj --subsystem=native --image-base=0x10000 --file-alignment=0x1000 --section-alignment=0x1000 --entry=_DriverEntry -nostartfiles -nostdlib -L E:\MinGWStudio\MinGW\lib -l ntoskrnl -o HelloDrv.sys

#==========================================================================
#res 
#���ճ���Ӧ������ĸ�ʽ�� res ��mingw ������coff 
i686-pc-mingw32-windres   AppMenu.rc  -o test.res -O coff
i686-pc-mingw32-windres   AppMenu.rc  -o test.res -O coff
i686-pc-mingw32-windres   AppMenu.rc  -o test.res -O res 
i686-pc-mingw32-windres  	-g  -Wall   -o AppMenu AppMenu.o  test.res

#########################################################################
#subsystem -m windows
i686-pc-mingw32-gcc hello.c -o hello.exe -mwindows

########################################################################
#mingw �����windows �İ汾̫����.
/usr/i686-pc-mingw32/sys-root/mingw/include/windef.h
11 #ifndef WINVER
12 //#define WINVER 0x0400
13 #define WINVER 0x0700
#���޸�һ�� һЩ����������.

