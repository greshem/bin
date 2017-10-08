#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__
1.
 <<浅谈：Linux 系统上内核以及其他 perf 命令>>
perf record -e /bin/ls 
perf record    --event cpu-clock -f  /bin/ls  #时钟周期
perf report

#ls  有了多少次系统调用? 在哪里发生的?
perf stat  -e syscalls:sys_enter ls 		#统计 sys_enter 的使用.

perf record -e syscalls:sys_enter ls 		#统计系统调用 盘后分析.
perf report 

perf record   -e syscalls:sys_enter find / > /dev/null  #统计 find /的系统调用
perf report  						#之后可以看到 100% 基本都是4个, 目录相关的系统调用.


perf kmem -alloc －l 10 -caller stat  # 




