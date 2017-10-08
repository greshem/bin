#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__

dwarf2_dump_info.pl

���� ���Ŵ�С ���з���  ���� ��ע ��Щ��  ��Ҫ�ķ���. 
	nm  -S --size-sort -l       /usr/sbin/nwconn 
	nm  -S --size-sort -l  /usr/share/diskplat/diskplat

#��ȡ δ����ķ���
 	nm -u 	/usr/sbin/nwconn 
	nm -u  /usr/share/diskplat/diskplat

# print all symbols   
	objdump  -t /usr/share/diskplat/diskplat |c++filt
 	readelf -s  /usr/share/diskplat/diskplat

#
nm --extern-only --defined-only -v --print-file-name /usr/share/diskplat/diskplat


#64bit 

#�����
# objdump -d -S  diskplat 


#tcp��ʱʱ��. 
# gdb: set tcp timeount 

#�鿴��ջ, �̼߳��. 
# /root/diskplat/trunk/tools_third_part/check_thread/pstack.sh
# /root/diskplat/trunk/tools_third_part/check_thread/diskplat_thread_check.pl

#watch һ������ ˭���޸��������  �ڴ�ϵ�. 
#rwatch 

#ȥ�����ű�. 
objcopy --strip-debug  diskplat
strip  	diskplat #Ҳ����ȥ��.

#���ɵ�����Ϣ ����һ���ļ� 
objcopy --only-keep-debug diskplat diskplat.dbg
#gdb  �������� ������Ϣ 
#  symbol-file  diskplat.dbg


#exe  �ϲ�������Ϣ.
objcopy --add-gnu-debuglink=diskplat.dbg diskplat



#ȥ��һЩ����.
readelf -sW libjvm.so | grep 'OBJECT *LOCAL *HIDDEN' | awk '{print $8}' | egrep '[.][0-9]+$' > strip_sym.lst
objcopy --strip-symbols=strip_sym.lst -v xxx.so
�����õ�����so�ļ��Ͳ�����strip���ķ�����Ϣ�ˣ�strip����ʱ����Գ�һ�㡣

#����Ĵ�ӡ.
# p *array@len 

#���߳��л� 
#info thread 
#set scheduler 

#�к� �༭
#gdb edit 

#��Ҫ���� �������߳�  ���̵߳���.
set target-async 1
set pagination off
set non-stop o


#set logging on 


#core-file ת��.

#����ȫ�ֱ�����  sizeof ��gtest 
 readelf  -s /usr/share/diskplat/diskplat |  sort -k 3 -n  |grep -v FUNC  |grep GLOBAL|c++filt |grep g_

#�����ļ��ֲ�������  sizeof ��gtest  , static 
 readelf  -s /usr/share/diskplat/diskplat |  sort -k 3 -n  |grep -v FUNC  |grep LOCAL |c++filt  |g_


tcpdump -vvve udp port tftp 		#diskplat tftp debug
tcpdump -vvve udp port 67		#diskplat dhcp bootps debug

