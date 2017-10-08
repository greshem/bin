#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__

dwarf2_dump_info.pl

根据 符号大小 排列符号  便于 关注 那些是  重要的符号. 
	nm  -S --size-sort -l       /usr/sbin/nwconn 
	nm  -S --size-sort -l  /usr/share/diskplat/diskplat

#获取 未定义的符号
 	nm -u 	/usr/sbin/nwconn 
	nm -u  /usr/share/diskplat/diskplat

# print all symbols   
	objdump  -t /usr/share/diskplat/diskplat |c++filt
 	readelf -s  /usr/share/diskplat/diskplat

#
nm --extern-only --defined-only -v --print-file-name /usr/share/diskplat/diskplat


#64bit 

#反汇编
# objdump -d -S  diskplat 


#tcp超时时间. 
# gdb: set tcp timeount 

#查看堆栈, 线程检查. 
# /root/diskplat/trunk/tools_third_part/check_thread/pstack.sh
# /root/diskplat/trunk/tools_third_part/check_thread/diskplat_thread_check.pl

#watch 一个变量 谁在修改这个变量  内存断点. 
#rwatch 

#去除符号表. 
objcopy --strip-debug  diskplat
strip  	diskplat #也可以去掉.

#生成调试信息 单独一个文件 
objcopy --only-keep-debug diskplat diskplat.dbg
#gdb  重新载入 调试信息 
#  symbol-file  diskplat.dbg


#exe  合并调试信息.
objcopy --add-gnu-debuglink=diskplat.dbg diskplat



#去掉一些符号.
readelf -sW libjvm.so | grep 'OBJECT *LOCAL *HIDDEN' | awk '{print $8}' | egrep '[.][0-9]+$' > strip_sym.lst
objcopy --strip-symbols=strip_sym.lst -v xxx.so
这样得到的新so文件就不含有strip掉的符号信息了，strip过程时间会稍长一点。

#数组的打印.
# p *array@len 

#多线程切换 
#info thread 
#set scheduler 

#行号 编辑
#gdb edit 

#不要冻结 其他的线程  多线程调试.
set target-async 1
set pagination off
set non-stop o


#set logging on 


#core-file 转储.

#生成全局变量的  sizeof 的gtest 
 readelf  -s /usr/share/diskplat/diskplat |  sort -k 3 -n  |grep -v FUNC  |grep GLOBAL|c++filt |grep g_

#生成文件局部变量的  sizeof 的gtest  , static 
 readelf  -s /usr/share/diskplat/diskplat |  sort -k 3 -n  |grep -v FUNC  |grep LOCAL |c++filt  |g_


tcpdump -vvve udp port tftp 		#diskplat tftp debug
tcpdump -vvve udp port 67		#diskplat dhcp bootps debug

