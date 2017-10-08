#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__
#==========================================================================
#都是在f16 x64的平台下面测试的.
#w32api 包.
rpm -ql mingw32-w32api-3.17-1.fc16.noarch
rpm -ql mingw32-w32api-3.17-1.fc16.noarch |grep "\.h"
rpm -ql mingw32-w32api-3.17-1.fc16.noarch |grep "\.a"

#==========================================================================
#获取支持的所有的 原生的函数, 头文件.
cd /usr/i686-pc-mingw32/sys-root/mingw/include
grep  -H  WINAPI *  

#==========================================================================
#获取函数 通过 静态库的方式.
cd /usr/i686-pc-mingw32/sys-root/mingw/lib
i686-pc-mingw32-nm   libuser32.a  |grep T 

#==========================================================================
#DDK编译.
i686-pc-mingw32-gcc -o HelloDrv.obj -O3 -c HelloDrv.c
i686-pc-mingw32-ld HelloDrv.obj --subsystem=native --image-base=0x10000 --file-alignment=0x1000 --section-alignment=0x1000 --entry=_DriverEntry -nostartfiles -nostdlib -L E:\MinGWStudio\MinGW\lib -l ntoskrnl -o HelloDrv.sys

#==========================================================================
#res 
#按照常理应该输出的格式是 res 在mingw 里面是coff 
i686-pc-mingw32-windres   AppMenu.rc  -o test.res -O coff
i686-pc-mingw32-windres   AppMenu.rc  -o test.res -O coff
i686-pc-mingw32-windres   AppMenu.rc  -o test.res -O res 
i686-pc-mingw32-windres  	-g  -Wall   -o AppMenu AppMenu.o  test.res

#########################################################################
#subsystem -m windows
i686-pc-mingw32-gcc hello.c -o hello.exe -mwindows

########################################################################
#mingw 定义的windows 的版本太低了.
/usr/i686-pc-mingw32/sys-root/mingw/include/windef.h
11 #ifndef WINVER
12 //#define WINVER 0x0400
13 #define WINVER 0x0700
#宏修改一下 一些函数就有了.

